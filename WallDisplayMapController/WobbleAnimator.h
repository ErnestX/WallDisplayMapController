//
//  WobbleAnimation.h
//  WobbleAnimation
//
//  Created by Jialiang Xiang on 2015-06-25.
//  Copyright (c) 2015 Jialiang Xiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface WobbleAnimator : NSObject

- (instancetype)initWithTarget:(UIView*) t;
- (void)startAnimation;
- (void)stopAnimation;

@end
