//
//  MapWallDisplayController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapWallDisplayController.h"

#include <time.h>
#include <sys/time.h>
#include <unistd.h>

// queue names
#define QUEUE_NAME_EARTH amqp_cstring_bytes("/tableplus/controls/earth/TableDesigner [884535663]/56c5d2dc-cb33-480f-a6fd-69a402073de2")
#define QUEUE_NAME_WIDGET amqp_cstring_bytes("/widget/test/queue")

// routing keys
#define ROUTING_KEY_EARTH amqp_cstring_bytes("/tableplus/controls/earth")
#define ROUTING_KEY_WIDGET amqp_cstring_bytes("/widget/test")

#define HOST_NAME "192.168.0.101"
#define PORT_NUMBER 5672
#define EXCHANGE_NAME amqp_cstring_bytes("DefaultExchange")
#define VHOST_NAME "/"
#define USER_NAME "guest"
#define PASSWORD "guest"
#define EXCHANGE_TYPE amqp_cstring_bytes("direct")

#define TEST_LATLON
#define TEST_ZOOM
#define TEST_HEADING
#define TEST_TILT

#define RMQ_OPEN_CONN_FAILED @"rmq_open_connection_fail"
#define RMQ_OPEN_CONN_OK @"rmq_open_connection_ok"
#define RMQ_CONN_WILL_OPEN @"rmq_connection_about_to_open"




#define SUMMARY_EVERY_US 1000000

@interface MapWallDisplayController()

@property amqp_connection_state_t conn;

@property MethodIntervalCaller* intervalCaller;
@property float facingDirectionIncrement;
@property float pitchIncrement;
@property float zoomFactorIncrement;
@property double latIncrement;
@property double lonIncrement;

@end

@implementation MapWallDisplayController

+(MapWallDisplayController *)sharedInstance
{
    static MapWallDisplayController *instance;
    static dispatch_once_t done;
    dispatch_once(&done,^{
        instance = [[MapWallDisplayController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // init caller
        self.intervalCaller = [[MethodIntervalCaller alloc] initWithInterval:0.08];
        
        // init increments
        [self initIncrements];
        
    }
    return self;
}

- (void) openRMQConnection {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_CONN_WILL_OPEN object:nil];
    
//    __weak typeof(self) weakSelf = self;
    // open connection
    _conn = amqp_new_connection();
    amqp_socket_t *socket = amqp_tcp_socket_new(_conn);
    
    // open socket
    int socketopen = amqp_socket_open(socket, HOST_NAME, PORT_NUMBER);
    if (socketopen == AMQP_STATUS_OK) {
        NSLog(@"SOCKET OPENED");
        
    } else {
        NSLog(@"SOCKET OPEN FAILED: %d", socketopen);
        [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_FAILED object:nil];
    }
    
    sleep(2);
    
    // login to remote broker
    amqp_rpc_reply_t arrt = amqp_login(_conn,VHOST_NAME,0,524288,0,AMQP_SASL_METHOD_PLAIN,USER_NAME,PASSWORD);
    if (arrt.reply_type == AMQP_RESPONSE_NORMAL) {
        NSLog(@"LOGIN TO REMOTE BROKER SUCCESSFUL");
        [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_OK object:nil];
    } else {
        NSLog(@"LOGIN UNSUCCESSFUL: %d", arrt.reply_type);
        [[NSNotificationCenter defaultCenter] postNotificationName:RMQ_OPEN_CONN_FAILED object:nil];
    }
    
    // open channel
    amqp_channel_open(_conn, 10);
    amqp_get_rpc_reply(_conn);
    
    // declare exchange
    amqp_exchange_declare(_conn, 10, EXCHANGE_NAME, EXCHANGE_TYPE, 0, 1, 0, 0, AMQP_EMPTY_TABLE);
    
    // declare queue
    amqp_queue_declare_ok_t *q = amqp_queue_declare(_conn, 10, QUEUE_NAME_EARTH, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
    amqp_queue_declare_ok_t *qWidget = amqp_queue_declare(_conn, 10, QUEUE_NAME_WIDGET, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
    amqp_bytes_t queuename = amqp_bytes_malloc_dup(q->queue);
    amqp_bytes_t queuenameWidget = amqp_bytes_malloc_dup(qWidget->queue);
    
    // binding queue with exchange
    amqp_queue_bind(_conn, 10, queuename, EXCHANGE_NAME, ROUTING_KEY_EARTH, AMQP_EMPTY_TABLE);
    amqp_queue_bind(_conn, 10, queuenameWidget, EXCHANGE_NAME, ROUTING_KEY_WIDGET, AMQP_EMPTY_TABLE);
    
    amqp_basic_consume(_conn, 10, queuenameWidget, amqp_empty_bytes, 0, 1, 0, AMQP_EMPTY_TABLE);
    die_on_amqp_error(amqp_get_rpc_reply(_conn), "Consuming");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        run(_conn);


    });
    
}

static void run(amqp_connection_state_t conn)
{
    int received = 0;
    amqp_frame_t frame;
    
    while (1) {
        amqp_rpc_reply_t ret;
        amqp_envelope_t envelope;
        
        amqp_maybe_release_buffers(conn);
        
        // amqp_consume_message is a blocking function
        // it's okay to use here since the enclosing function is
        // being called in a background thread
        ret = amqp_consume_message(conn, &envelope, NULL, 0);
        
        if (AMQP_RESPONSE_NORMAL != ret.reply_type) {
            if (AMQP_RESPONSE_LIBRARY_EXCEPTION == ret.reply_type &&
                AMQP_STATUS_UNEXPECTED_STATE == ret.library_error) {
                if (AMQP_STATUS_OK != amqp_simple_wait_frame(conn, &frame)) {
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
                            ret = amqp_read_message(conn, frame.channel, &message, 0);
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
            
            // TODO: parse xml into a dictionary??
            NSDictionary *dict = [NSDictionary dictionaryWithXMLString:msg];
            
            NSLog(@"message: %@", msg);
        }
        
        received++;
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
    } else {
        NSLog(@"CLOSE CONNECTION FAILED, error code is: %d", code);
    }
}

- (void) sendRequest:(EarthControlRequest *)request {
    // publish request to rmqp server
    int statuscode = amqp_basic_publish(_conn, 10, EXCHANGE_NAME, ROUTING_KEY_EARTH, 0, 0, NULL, amqp_cstring_bytes(request.toString.UTF8String));
    
    if (statuscode == AMQP_STATUS_OK) {
        NSLog(@"publish successful");
    } else {
        NSLog(@"publish failed: %d", statuscode);
    }
}

- (void) sendRequestAtInterval
{
    if ([self incrementsUpdated]) {
        EarthControlRequest *request = [[EarthControlRequest alloc] init];
        [request addKey:@"tilt" withValue:[NSString stringWithFormat:@"%f", self.pitchIncrement/(2*M_PI)*360]];
        [request addKey:@"lat" withValue:[NSString stringWithFormat:@"%f", self.latIncrement]];
        [request addKey:@"lon" withValue:[NSString stringWithFormat:@"%f", self.lonIncrement]];
        [request addKey:@"range" withValue:[NSString stringWithFormat:@"%f", self.zoomFactorIncrement]];
        [request addKey:@"heading" withValue:[NSString stringWithFormat:@"%f", self.facingDirectionIncrement/(2*M_PI)*360]];
        
        [request addKey:@"method" withValue:@"xx"];
        
        
        #ifdef TEST_HEADING
            [self sendRequest:request];
        #endif
        
        // reset after each sending
        [self initIncrements];
    }
}

- (void) increaseMapFacingDirectionBy: (float) angle
{
    NSLog(@"increaseFacingDirectionBy: %f", angle);
    self.facingDirectionIncrement = angle;
    
     __weak typeof(self) weakSelf = self;
    [self.intervalCaller addToCaller:^(void){
        [weakSelf sendRequestAtInterval];
    }];
}

- (void) increaseMapPitchBy:(float)angle
{
    //NSLog(@"increaseMapPitchBy: %f", angle);
    self.pitchIncrement = angle;
    
    __weak typeof(self) weakSelf = self;
    [self.intervalCaller addToCaller:^(void){
        [weakSelf sendRequestAtInterval];
    }];
}

- (void) increaseMapZoomBy:(float)zoomFactor
{
    //NSLog(@"increaseMapZoomBy: %f", zoomFactor);
    self.zoomFactorIncrement = zoomFactor;
    
    __weak typeof(self) weakSelf = self;
    [self.intervalCaller addToCaller:^(void){
        [weakSelf sendRequestAtInterval];
    }];
}

- (void) increaseMapLatBy:(double)lat LonBy:(double)lon
{
    //NSLog(@"increaseLatBy: %f LonBy: %f", lat, lon);
    self.latIncrement = lat;
    self.lonIncrement = lon;
    
    __weak typeof(self) weakSelf = self;
    [self.intervalCaller addToCaller:^(void){
        [weakSelf sendRequestAtInterval];
    }];
}

- (void) initIncrements
{
    self.facingDirectionIncrement = 0;
    self.pitchIncrement = 0;
    self.zoomFactorIncrement = 1;
    self.latIncrement = 0;
    self.lonIncrement = 0;
}

- (BOOL) incrementsUpdated
{
    return (self.facingDirectionIncrement != 0 ||
            self.pitchIncrement != 0 ||
            self.zoomFactorIncrement != 1 ||
            self.latIncrement != 0 ||
            self.lonIncrement != 0);
}

void die(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fprintf(stderr, "\n");
    exit(1);
}

void die_on_error(int x, char const *context)
{
    if (x < 0) {
        fprintf(stderr, "%s: %s\n", context, amqp_error_string2(x));
        exit(1);
    }
}

void die_on_amqp_error(amqp_rpc_reply_t x, char const *context)
{
    switch (x.reply_type) {
        case AMQP_RESPONSE_NORMAL:
            return;
            
        case AMQP_RESPONSE_NONE:
            fprintf(stderr, "%s: missing RPC reply type!\n", context);
            break;
            
        case AMQP_RESPONSE_LIBRARY_EXCEPTION:
            fprintf(stderr, "%s: %s\n", context, amqp_error_string2(x.library_error));
            break;
            
        case AMQP_RESPONSE_SERVER_EXCEPTION:
            switch (x.reply.id) {
                case AMQP_CONNECTION_CLOSE_METHOD: {
                    amqp_connection_close_t *m = (amqp_connection_close_t *) x.reply.decoded;
                    fprintf(stderr, "%s: server connection error %d, message: %.*s\n",
                            context,
                            m->reply_code,
                            (int) m->reply_text.len, (char *) m->reply_text.bytes);
                    break;
                }
                case AMQP_CHANNEL_CLOSE_METHOD: {
                    amqp_channel_close_t *m = (amqp_channel_close_t *) x.reply.decoded;
                    fprintf(stderr, "%s: server channel error %d, message: %.*s\n",
                            context,
                            m->reply_code,
                            (int) m->reply_text.len, (char *) m->reply_text.bytes);
                    break;
                }
                default:
                    fprintf(stderr, "%s: unknown server error, method id 0x%08X\n", context, x.reply.id);
                    break;
            }
            break;
    }
    
    exit(1);
}


@end
