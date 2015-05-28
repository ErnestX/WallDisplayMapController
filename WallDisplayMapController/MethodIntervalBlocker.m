//
//  MethodTimer.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-28.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MethodIntervalBlocker.h"

@implementation MethodIntervalBlocker {
    float interval;
    CFTimeInterval lastStamp;
}

- (id) initWithInterval: (float) sec {
    self = [super init];
    if (self) {
        interval = sec;
        lastStamp = CACurrentMediaTime();
    }
    
    return self;
}

- (void) addToCaller: (void (^) (void)) b
{
    CFTimeInterval stamp = CACurrentMediaTime();
    
    if (stamp - lastStamp > interval) {
        // that's enough elapse
        lastStamp = stamp;
        b();
    } else {
        //ignore block
        return;
    }
}

@end
