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

// for debugging purposes
#define TEST_LATLON
#define TEST_ZOOM
#define TEST_HEADING
#define TEST_TILT

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

//void die(const char *fmt, ...)
//{
//    va_list ap;
//    va_start(ap, fmt);
//    vfprintf(stderr, fmt, ap);
//    va_end(ap);
//    fprintf(stderr, "\n");
//    exit(1);
//}
//
//void die_on_error(int x, char const *context)
//{
//    if (x < 0) {
//        fprintf(stderr, "%s: %s\n", context, amqp_error_string2(x));
//        exit(1);
//    }
//}
//
//void die_on_amqp_error(amqp_rpc_reply_t x, char const *context)
//{
//    switch (x.reply_type) {
//        case AMQP_RESPONSE_NORMAL:
//            return;
//            
//        case AMQP_RESPONSE_NONE:
//            fprintf(stderr, "%s: missing RPC reply type!\n", context);
//            break;
//            
//        case AMQP_RESPONSE_LIBRARY_EXCEPTION:
//            fprintf(stderr, "%s: %s\n", context, amqp_error_string2(x.library_error));
//            break;
//            
//        case AMQP_RESPONSE_SERVER_EXCEPTION:
//            switch (x.reply.id) {
//                case AMQP_CONNECTION_CLOSE_METHOD: {
//                    amqp_connection_close_t *m = (amqp_connection_close_t *) x.reply.decoded;
//                    fprintf(stderr, "%s: server connection error %d, message: %.*s\n",
//                            context,
//                            m->reply_code,
//                            (int) m->reply_text.len, (char *) m->reply_text.bytes);
//                    break;
//                }
//                case AMQP_CHANNEL_CLOSE_METHOD: {
//                    amqp_channel_close_t *m = (amqp_channel_close_t *) x.reply.decoded;
//                    fprintf(stderr, "%s: server channel error %d, message: %.*s\n",
//                            context,
//                            m->reply_code,
//                            (int) m->reply_text.len, (char *) m->reply_text.bytes);
//                    break;
//                }
//                default:
//                    fprintf(stderr, "%s: unknown server error, method id 0x%08X\n", context, x.reply.id);
//                    break;
//            }
//            break;
//    }
//    
//    exit(1);
//}


@end
