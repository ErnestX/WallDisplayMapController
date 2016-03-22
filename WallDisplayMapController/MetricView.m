//
//  MetricView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricView.h"

@implementation MetricView

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd {
    self = [self initWithMetricName:m position:p color:c];
    
    // TODO
    
    return self;
}

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd {
    self = [self initWithMetricName:m position:p color:c];
    
    // TODO
    
    return self;
}

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd {
    self = [self initWithMetricName:m position:p color:c];
    
    // TODO
    
    return self;
}

- (id)initWithMetricName:(NSString*)m position:(CGFloat)p color:(UIColor*)c  {
    
    // draw dot
    
    return self;
}

- (void)hideLeftLine {
    
}

- (void)hideRightLine {
    
}

- (void)showLeftLineWithPrevDataPointHeight:(CGFloat)prevH absHorizontalDistance:(CGFloat)prevD {
    
}

- (void)showRightLineWithNextDataPointHeight:(CGFloat)nextH absHorizontalDistance:(CGFloat)nextD {
    
}

- (void)showIcons {
    
}

@end
