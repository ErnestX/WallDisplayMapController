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
#define QUEUE_NAME amqp_cstring_bytes("/tableplus/controls/earth/TableDesigner [884535663]/56c5d2dc-cb33-480f-a6fd-69a402073de2")
#define ROUTING_KEY amqp_cstring_bytes("/tableplus/controls/earth")
#define EXCHANGE_NAME amqp_cstring_bytes("DefaultExchange")
#define VHOST_NAME "/"
#define USER_NAME "guest"
#define PASSWORD "guest"
#define EXCHANGE_TYPE amqp_cstring_bytes("direct")

//#define TEST_LATLON
//#define TEST_ZOOM
#define TEST_HEADING
//#define TEST_TILT

@interface MapWallDisplayController()

@property amqp_connection_state_t conn;

@end

@implementation MapWallDisplayController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openRMQConnection];
    }
    return self;
}

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
    
    sleep(2);
    
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
    amqp_exchange_declare(_conn, 10, EXCHANGE_NAME, EXCHANGE_TYPE, 0, 1, 0, 0, AMQP_EMPTY_TABLE);
    
    // declare queue
    amqp_queue_declare_ok_t *q = amqp_queue_declare(_conn, 10, QUEUE_NAME, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
    amqp_bytes_t queuename = amqp_bytes_malloc_dup(q->queue);
    
    // binding queue with exchange
    amqp_queue_bind(_conn, 10, queuename, EXCHANGE_NAME, ROUTING_KEY, AMQP_EMPTY_TABLE);
    
}

- (void) closeRMQConnection {
    // release memory owned by the connection
    amqp_maybe_release_buffers(_conn);
    
    // unbind queue with exchange
    amqp_queue_unbind(_conn, 10, QUEUE_NAME, EXCHANGE_NAME, ROUTING_KEY, AMQP_EMPTY_TABLE);
    
    // close channel
    amqp_channel_close(_conn, 10, AMQP_REPLY_SUCCESS);
    
    // close and destroy connection
    amqp_connection_close(_conn, AMQP_REPLY_SUCCESS);
    amqp_destroy_connection(_conn);
}

- (void) sendRequest:(EarthControlRequest *)request {
    // publish request to rmqp server
    int statuscode = amqp_basic_publish(_conn, 10, EXCHANGE_NAME, ROUTING_KEY, 0, 0, NULL, amqp_cstring_bytes(request.toString.UTF8String));
    
    if (statuscode == AMQP_STATUS_OK) {
        NSLog(@"publish successful");
    } else {
        NSLog(@"publish failed: %d", statuscode);
    }
}

- (void) increaseMapFacingDirectionBy: (float) angle
{
    NSLog(@"increaseFacingDirectionBy: %f", angle);
    
    EarthControlRequest *request = [[EarthControlRequest alloc] init];
    [request addKey:@"tilt" withValue:@"xx"];
    [request addKey:@"lat" withValue:@"xx"];
    [request addKey:@"lon" withValue:@"xx"];
    [request addKey:@"range" withValue:@"xx"];
    [request addKey:@"heading" withValue:[NSString stringWithFormat:@"%f", angle*360.0/(2*M_PI)]];
    
    [request addKey:@"method" withValue:@"heading"];
    
    
#ifdef TEST_HEADING
    [self sendRequest:request];
#endif
}

- (void) increaseMapPitchBy:(float)angle
{
//    NSLog(@"increaseMapPitchBy: %f", angle);
    
    EarthControlRequest *request = [[EarthControlRequest alloc] init];
    [request addKey:@"tilt" withValue:[NSString stringWithFormat:@"%f", angle*360.0/(2*M_PI)]];
    
    [request addKey:@"lat" withValue:@"xx"];
    [request addKey:@"lon" withValue:@"xx"];
    [request addKey:@"range" withValue:@"xx"];
    [request addKey:@"heading" withValue:@"xx"];
    
    [request addKey:@"method" withValue:@"tilt"];
    
    
#ifdef TEST_TILT
    [self sendRequest:request];
#endif
}

- (void) increaseMapZoomBy:(float)zoomFactor
{
//    NSLog(@"increaseMapZoomBy: %f", zoomFactor);
    
    EarthControlRequest *request = [[EarthControlRequest alloc] init];
    [request addKey:@"tilt" withValue:@"xx"];
    
    [request addKey:@"lat" withValue:@"xx"];
    [request addKey:@"lon" withValue:@"xx"];
    [request addKey:@"range" withValue:[NSString stringWithFormat:@"%f", zoomFactor]];
    [request addKey:@"heading" withValue:@"xx"];
    
    [request addKey:@"method" withValue:@"zoom"];
    
    
#ifdef TEST_ZOOM
    [self sendRequest:request];
#endif
    
}

- (void) increaseMapLatBy:(double)lat LonBy:(double)lon
{
//    NSLog(@"increaseLatBy: %f LonBy: %f", lat, lon);
    
    EarthControlRequest *request = [[EarthControlRequest alloc] init];
    [request addKey:@"lat" withValue:[NSString stringWithFormat:@"%f", lat]];
    [request addKey:@"lon" withValue:[NSString stringWithFormat:@"%f", lon]];
    [request addKey:@"range" withValue:@"xx"];
    [request addKey:@"tilt" withValue:@"xx"];
    [request addKey:@"heading" withValue:@"xx"];
    
    [request addKey:@"method" withValue:@"latlon"];
    
    
#ifdef TEST_LATLON
    [self sendRequest:request];
#endif
    
    
}

@end
