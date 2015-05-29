//
//  RequestSender.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-29.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "RequestSender.h"

@implementation RequestSender {
    NSTimer* timer;
    EarthControlRequest* request;
}

- (id)init
{
    self = [super init];
    if (self) {
        // init timer
        timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(sendRequest) userInfo:nil repeats:YES];
        
        // init request
        request = [[EarthControlRequest alloc] init];
        [request addKey:@"tilt" withValue:@"xx"];
        [request addKey:@"lat" withValue:@"xx"];
        [request addKey:@"lon" withValue:@"xx"];
        [request addKey:@"range" withValue:@"xx"];
        [request addKey:@"heading" withValue:@"xx"];
        [request addKey:@"method" withValue:@"xx"];
    }
    
    return self;
}

- (void)sendRequestToIncrease:(LookParameter) para ByValue:(NSString*) value
{
    
}

- (void)sendRequest
{
    
}

@end
