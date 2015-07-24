//
//  RabbitMQManager.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-19.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#include <time.h>
#include <sys/time.h>
#include <unistd.h>

#import "RabbitMQManager.h"
#import <amqp.h>
#import <amqp_framing.h>
#import "amqp_tcp_socket.h"
#import "NSOperationQueue+Timeout.h"
#import "XMLDictionary.h"

@interface RabbitMQManager()

@property amqp_connection_state_t conn;
@property NSString *strIP;
@property BOOL isConnectionOpen;

@end

@implementation RabbitMQManager

+ (RabbitMQManager *)sharedInstance {
    static RabbitMQManager *instance;
    static dispatch_once_t done;
    dispatch_once(&done,^{
        instance = [[RabbitMQManager alloc] init];
        instance.isConnectionOpen = NO;
    });
    return instance;
}

- (void) openRMQConnection {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_CONN_WILL_OPEN object:nil];
    
    // open connection
    _conn = amqp_new_connection();
    amqp_socket_t *socket = amqp_tcp_socket_new(_conn);
    
    DEFINE_WEAK_SELF
    NSOperationQueue *opQ = [[NSOperationQueue alloc] init];
    [opQ addOperationWithBlock:^(NSOperation *operation) {
        // open socket
        int socketopen = amqp_socket_open(socket, [weakSelf.strIP UTF8String], PORT_NUMBER);
        if (socketopen == AMQP_STATUS_OK) {
            NSLog(@"SOCKET OPENED");
            sleep(2);
            
            // login to remote broker
            amqp_rpc_reply_t arrt = amqp_login(_conn,VHOST_NAME,0,524288,0,AMQP_SASL_METHOD_PLAIN,USER_NAME,PASSWORD);
            if (arrt.reply_type == AMQP_RESPONSE_NORMAL) {
                NSLog(@"LOGIN TO REMOTE BROKER SUCCESSFUL");
                [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_OK object:nil];
            } else {
                NSLog(@"LOGIN UNSUCCESSFUL: %d", arrt.reply_type);
                [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_FAILED object:nil];
                return;
            }
            
            // open channel
            amqp_channel_open(_conn, 10);
            amqp_get_rpc_reply(_conn);
            
            // declare exchange
            amqp_exchange_declare(_conn, 10, EXCHANGE_NAME, EXCHANGE_TYPE, 0, 1, 0, 0, AMQP_EMPTY_TABLE);
            
            // declare queue
            amqp_queue_declare_ok_t *qEarth = amqp_queue_declare(_conn, 10, QUEUE_NAME_EARTH, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
            amqp_queue_declare_ok_t *qWidget = amqp_queue_declare(_conn, 10, QUEUE_NAME_WIDGET, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
            amqp_bytes_t queuenameEarth = amqp_bytes_malloc_dup(qEarth->queue);
            amqp_bytes_t queuenameWidget = amqp_bytes_malloc_dup(qWidget->queue);
            
            // binding queue with exchange
            amqp_queue_bind(_conn, 10, queuenameEarth, EXCHANGE_NAME, ROUTING_KEY_EARTH, AMQP_EMPTY_TABLE);
            amqp_queue_bind(_conn, 10, queuenameWidget, EXCHANGE_NAME, ROUTING_KEY_WIDGET, AMQP_EMPTY_TABLE);
            
            amqp_basic_consume(_conn, 10, queuenameWidget, amqp_empty_bytes, 0, 1, 0, AMQP_EMPTY_TABLE);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_CONSUMER_THREAD_STARTED object:nil];
            self.isConnectionOpen = YES;
            
        } else {
            NSLog(@"SOCKET OPEN FAILED: %d", socketopen);
            [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_FAILED object:nil];
            return;
        }
    } timeout:5.0 timeoutBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_FAILED object:nil];
        return;
    }];
    
}

- (void)beginConsumingWidgetsWithCallbackBlock:(void (^)(NSString *message))callbackBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        int received = 0;
        amqp_frame_t frame;
        
        while (1) {
            amqp_rpc_reply_t ret;
            amqp_envelope_t envelope;
            
            amqp_maybe_release_buffers(_conn);
            
            // amqp_consume_message is a blocking function
            // it's okay to use here since the enclosing function is
            // being called in a background thread
            ret = amqp_consume_message(_conn, &envelope, NULL, 0);
            
            if (AMQP_RESPONSE_NORMAL != ret.reply_type) {
                if (AMQP_RESPONSE_LIBRARY_EXCEPTION == ret.reply_type &&
                    AMQP_STATUS_UNEXPECTED_STATE == ret.library_error) {
                    if (AMQP_STATUS_OK != amqp_simple_wait_frame(_conn, &frame)) {
                        return;
                    }
                    
                    if (AMQP_FRAME_METHOD == frame.frame_type) {
                        switch (frame.payload.method.id) {
                            case AMQP_BASIC_ACK_METHOD:
                                /* if we've turned publisher confirms on, and we've published a message
                                 * here is a message being confirmed
                                 */
                                
                                break;
                            case AMQP_BASIC_RETURN_METHOD:
                                /* if a published message couldn't be routed and the mandatory flag was set
                                 * this is what would be returned. The message then needs to be read.
                                 */
                            {
                                amqp_message_t message;
                                ret = amqp_read_message(_conn, frame.channel, &message, 0);
                                if (AMQP_RESPONSE_NORMAL != ret.reply_type) {
                                    return;
                                }
                                
                                amqp_destroy_message(&message);
                            }
                                
                                break;
                                
                            case AMQP_CHANNEL_CLOSE_METHOD:
                                /* a channel.close method happens when a channel exception occurs, this
                                 * can happen by publishing to an exchange that doesn't exist for example
                                 *
                                 * In this case you would need to open another channel redeclare any queues
                                 * that were declared auto-delete, and restart any consumers that were attached
                                 * to the previous channel
                                 */
                                return;
                                
                            case AMQP_CONNECTION_CLOSE_METHOD:
                                /* a connection.close method happens when a connection exception occurs,
                                 * this can happen by trying to use a channel that isn't open for example.
                                 *
                                 * In this case the whole connection must be restarted.
                                 */
                                return;
                                
                            default:
                                fprintf(stderr ,"An unexpected method was received %d\n", frame.payload.method.id);
                                return;
                        }
                    }
                }
                
            } else {
                
                
                NSString *msg = [[NSString alloc] initWithBytesNoCopy:envelope.message.body.bytes
                                                               length:envelope.message.body.len
                                                             encoding:NSUTF8StringEncoding
                                                         freeWhenDone:YES];
                if (callbackBlock) {
                    callbackBlock(msg);
                }

            }
            
            received++;
        }
    });
    
}

- (void)publishEarthControlWithBody:(NSString *)body {
    int statuscode = amqp_basic_publish(_conn, 10, EXCHANGE_NAME, ROUTING_KEY_EARTH, 0, 0, NULL, amqp_cstring_bytes(body.UTF8String));
    
    if (statuscode == AMQP_STATUS_OK) {
        NSLog(@"publish successful");
    } else {
        NSLog(@"publish failed: %d", statuscode);
    }
}

- (void) closeRMQConnection {
    // release memory owned by the connection
    amqp_maybe_release_buffers(_conn);

    // unbind queue with exchange
    amqp_queue_unbind(_conn, 10, QUEUE_NAME_EARTH, EXCHANGE_NAME, ROUTING_KEY_EARTH, AMQP_EMPTY_TABLE);
    amqp_queue_unbind(_conn, 10, QUEUE_NAME_WIDGET, EXCHANGE_NAME, ROUTING_KEY_WIDGET, AMQP_EMPTY_TABLE);
    
    // close channel
    amqp_channel_close(_conn, 10, AMQP_REPLY_SUCCESS);
    
    // close and destroy connection
    amqp_connection_close(_conn, AMQP_REPLY_SUCCESS);
    amqp_status_enum code =  amqp_destroy_connection(_conn);
    if (code == AMQP_STATUS_OK) {
        NSLog(@"CLOSE CONNECTION SUCCESS");
        self.isConnectionOpen = NO;
        return;
    } else {
        NSLog(@"CLOSE CONNECTION FAILED, error code is: %d", code);
        return;
    }
}

- (BOOL)connected {
    return self.isConnectionOpen;
}

- (NSString *)getIPAddress {
    return self.strIP;
    
}

- (void)setIPAddress:(NSString *)ip {
    self.strIP = ip;
}

@end
