//
//  MethodTimer.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-28.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MethodIntervalBlocker : NSObject

- (id) initWithInterval: (float) sec;

/*
 the block is called if and only if it has been more than the interval since last time any block is called through this object
 */
- (void) addToCaller: (void (^) (void)) b;

@end
