//
//  MapWallDisplayController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapWallDisplayController.h"

#define HOST_NAME "192.168.0.104"
#define PORT_NUMBER 5672
#define QUEUE_NAME amqp_cstring_bytes("/tableplus/controls/earth/TableDesigner [884535663]/56c5d2dc-cb33-480f-a6fd-69a402073de2")
#define ROUTING_KEY amqp_cstring_bytes("/tableplus/controls/earth")
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
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
        amqp_queue_declare_ok_t *q = amqp_queue_declare(_conn, 10, QUEUE_NAME, 0, 0, 0, 1, AMQP_EMPTY_TABLE);
        amqp_bytes_t queuename = amqp_bytes_malloc_dup(q->queue);
        
        // binding queue with exchange
        amqp_queue_bind(_conn, 10, queuename, EXCHANGE_NAME, ROUTING_KEY, AMQP_EMPTY_TABLE);
    });
    
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
    amqp_status_enum code =  amqp_destroy_connection(_conn);
    if (code == AMQP_STATUS_OK) {
        NSLog(@"CLOSE CONNECTION SUCCESS");
    } else {
        NSLog(@"CLOSE CONNECTION FAILED, error code is: %d", code);
    }
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

@end
