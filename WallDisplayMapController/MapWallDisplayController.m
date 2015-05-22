//
//  MapWallDisplayController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapWallDisplayController.h"

#define HOST_NAME "192.168.0.105"
#define PORT_NUMBER 5672
#define QUEUE_NAME "ios"
#define EXCHANGE_NAME "DefaultExchange"
#define VHOST_NAME "/"
#define USER_NAME "guest"
#define PASSWORD "guest"
#define EXCHANGE_TYPE "direct"

@interface MapWallDisplayController()

@property amqp_connection_state_t conn;

@end

@implementation MapWallDisplayController

- (void) openRMQConnection {
    // open connection
    _conn = amqp_new_connection();
    amqp_socket_t *socket = amqp_tcp_socket_new(_conn);
    
    // open socket
    int socketopen = amqp_socket_open(socket, HOST_NAME, PORT_NUMBER);
    if (socketopen == AMQP_STATUS_OK) {
        NSLog(@"SOCKET OPENED");
    } else {
        NSLog(@"SOCKET OPEN FAILED: %d", socketopen);
    }
    
    sleep(3);
    
    // login to remote broker
    amqp_rpc_reply_t arrt = amqp_login(_conn,VHOST_NAME,0,524288,0,AMQP_SASL_METHOD_PLAIN,USER_NAME,PASSWORD);
    if (arrt.reply_type == AMQP_RESPONSE_NORMAL) {
        NSLog(@"LOGIN TO REMOTE BROKER SUCCESSFUL");
    } else {
        NSLog(@"LOGIN UNSUCCESSFUL: %d", arrt.reply_type);
    }

    // open channel
    amqp_channel_open(_conn, 10);
    amqp_get_rpc_reply(_conn);
    
    // declare exchange
    amqp_exchange_declare(_conn, 10, amqp_cstring_bytes(EXCHANGE_NAME), amqp_cstring_bytes(EXCHANGE_TYPE), 0, 1, 0, 0, AMQP_EMPTY_TABLE);
    
    // declare queue
    amqp_queue_declare_ok_t *q = amqp_queue_declare(_conn, 10, amqp_cstring_bytes(QUEUE_NAME), 0, 0, 0, 1, AMQP_EMPTY_TABLE);
    amqp_bytes_t queuename = amqp_bytes_malloc_dup(q->queue);
    
    // binding queue with exchange
    amqp_queue_bind(_conn, 10, queuename, amqp_cstring_bytes(EXCHANGE_NAME), amqp_cstring_bytes(QUEUE_NAME), AMQP_EMPTY_TABLE);
    
}

- (void) closeRMQConnection {
    // release memory owned by the connection
    amqp_maybe_release_buffers(_conn);
    
    // unbind queue with exchange
    amqp_queue_unbind(_conn, 10, amqp_cstring_bytes(QUEUE_NAME), amqp_cstring_bytes(EXCHANGE_NAME), amqp_cstring_bytes(QUEUE_NAME), AMQP_EMPTY_TABLE);
    
    // close channel
    amqp_channel_close(_conn, 10, AMQP_REPLY_SUCCESS);
    
    // close and destroy connection
    amqp_connection_close(_conn, AMQP_REPLY_SUCCESS);
    amqp_destroy_connection(_conn);
}

- (BOOL) setMapFacingDirection:(float)faceingDirection
{
    NSLog(@"setMapFacingDireciton %f", faceingDirection);
    
    return NO; //stub
}

- (BOOL) setMapPitch:(float)pitch
{
    NSLog(@"setMapPitch %f", pitch);
    
    return NO; //stub
}

- (BOOL) setMapZoom:(float)zoomFactor
{
    NSLog(@"setMapZoom %f", zoomFactor);
    
    return NO; //stub
}

- (BOOL) setMapLat:(double)lat Lon:(double)lon
{
    NSLog(@"setMapLat %f, Lon %f", lat, lon);
    
    return NO; //stub
}

@end
