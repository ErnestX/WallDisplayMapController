//
//  MetricView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricView.h"

#define MIN_RENDER_POSITION 0.1
#define MAX_RENDER_POSITION 0.9
#define DATA_POINT_DIAMETER 10
#define LINE_WIDTH 2

@implementation MetricView
{
    UIView* dataPointView;
    UIView* leftLineView;
    UIView* rightLineView;
}

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd {
    self = [self initWithMetricName:m position:p color:c];
    NSAssert(self, @"init failed");
    
    [self showLeftLineWithPrevDataPointHeight:ph absHorizontalDistance:pd];
    [self showRightLineWithNextDataPointHeight:nh absHorizontalDistance:nd];
    
    return self;
}

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd {
    self = [self initWithMetricName:m position:p color:c];
    NSAssert(self, @"init failed");
    
    [self showLeftLineWithPrevDataPointHeight:ph absHorizontalDistance:pd];
    
    return self;
}

- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd {
    self = [self initWithMetricName:m position:p color:c];
    NSAssert(self, @"init failed");
    
    [self showRightLineWithNextDataPointHeight:nh absHorizontalDistance:nd];
    
    return self;
}

- (id)initWithMetricName:(NSString*)m position:(CGFloat)p color:(UIColor*)c {
    // map the position to a different range for rendering
    CGFloat renderPos = p * (MAX_RENDER_POSITION - MIN_RENDER_POSITION) + MIN_RENDER_POSITION; // map p from 0-1 to rendering range
    
    // draw the data point (each metric view contains only one data point)
    dataPointView = [UIView new];
    NSAssert(dataPointView, @"init failed");
    
    dataPointView.backgroundColor = c;
    
    [self addSubview:dataPointView];
    
    dataPointView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray <NSLayoutConstraint*>* dataPointViewConstraints = [[NSMutableArray alloc]init];
    [dataPointViewConstraints addObject:[NSLayoutConstraint constraintWithItem:dataPointView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0.0]];
    [dataPointViewConstraints addObject:[NSLayoutConstraint constraintWithItem:dataPointView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY // can't use height, so will use centerY and multiply by 2.0
                                                                 multiplier:2.0 * renderPos // set center y
                                                                   constant:0.0]];
    [dataPointViewConstraints addObject:[NSLayoutConstraint constraintWithItem:dataPointView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:DATA_POINT_DIAMETER]];
    [dataPointViewConstraints addObject:[NSLayoutConstraint constraintWithItem:dataPointView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:DATA_POINT_DIAMETER]];
    [NSLayoutConstraint activateConstraints:dataPointViewConstraints];
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0; // the border is within the bound (inset)
    
    return self;
}

- (void)hideLeftLine {
    if (leftLineView) {
        leftLineView.hidden = true;
    }
}

- (void)hideRightLine {
    if (rightLineView) {
        rightLineView.hidden = true;
    }
}

- (void)showLeftLineWithPrevDataPointHeight:(CGFloat)prevH absHorizontalDistance:(CGFloat)prevD {
    if (!leftLineView) {
        // alloc new
        leftLineView = [UIView new];
        leftLineView.layer.anchorPoint = CGPointMake(1.0, 0.5); // rotates relative to the center of the right edge
        
        // auto layout
        leftLineView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray <NSLayoutConstraint*>* leftLineViewConstraints = [[NSMutableArray alloc]init];
        [leftLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:leftLineView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:dataPointView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]];
        // TODO: incomplete! Need to figure out how to deal with transformaiton in auto layout
    }
    // init
}

- (void)showRightLineWithNextDataPointHeight:(CGFloat)nextH absHorizontalDistance:(CGFloat)nextD {
    if (!rightLineView) {
        // alloc new
    }
    // init
}

- (void)showIcons {
    
}

@end
