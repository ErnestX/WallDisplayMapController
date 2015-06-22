//
//  MapWallDisplayController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapWallDisplayController.h"
#import "RabbitMQManager.h"

#include <time.h>
#include <sys/time.h>
#include <unistd.h>

// for debugging purposes
#define TEST_LATLON
#define TEST_ZOOM
#define TEST_HEADING
#define TEST_TILT

@interface MapWallDisplayController()

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
    
    [[RabbitMQManager sharedInstance] publishEarthControlWithBody:request.toString];
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
