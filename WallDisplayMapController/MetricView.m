//
//  MetricView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricView.h"
#import "GraphLineView.h"

#define MIN_RENDER_POSITION 0.1
#define MAX_RENDER_POSITION 0.9
#define DATA_POINT_DIAMETER 10
#define LINE_WIDTH 2

@implementation MetricView
{
    CGFloat dataPointPosition;
    UIView* dataPointView;
    GraphLineView* leftLineView;
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
    dataPointPosition = p;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"set frame");
    
    if (leftLineView) {
        [self updateLeftLineAccordingToFrame];
    }
}

- (void)updateLeftLineAccordingToFrame {
    if (leftLineView) {
        CGFloat angle = atan((dataPointPosition-leftLineView.connectedToDataPointWithHeight)*self.frame.size.height
                             / leftLineView.absHorizontalDistance);
        NSLog(@"%f, %f, %f, %f, %f", angle, dataPointPosition, leftLineView.connectedToDataPointWithHeight, self.frame.size.height, leftLineView.absHorizontalDistance);
        leftLineView.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1); // use layer transfrom to avoid trouble with auto layout
    }
}

- (void)showLeftLineWithPrevDataPointHeight:(CGFloat)prevH absHorizontalDistance:(CGFloat)prevD {
    if (!leftLineView) {
        // alloc new
        leftLineView = [[GraphLineView alloc]initWithColor:[UIColor redColor]
                            connectedToDataPointWithHeight:prevH
                                     absHorizontalDistance:prevD anchorPointOnRight:YES];
//        leftLineView.layer.transform = CATransform3DMakeRotation(0.5, 0, 0, 1); // use layer transfrom to avoid trouble with auto layout
//        [self updateLeftLineAccordingToFrame];
        [self addSubview:leftLineView];
        [self sendSubviewToBack:leftLineView];
        
        // auto layout
        leftLineView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray <NSLayoutConstraint*>* leftLineViewConstraints = [[NSMutableArray alloc]init];
        [leftLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:leftLineView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:dataPointView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]];
        [leftLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:leftLineView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:dataPointView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];
        [leftLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:leftLineView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:30]];
        [leftLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:leftLineView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:LINE_WIDTH]];
        [NSLayoutConstraint activateConstraints:leftLineViewConstraints];
    }
    // init
}

- (void)showRightLineWithNextDataPointHeight:(CGFloat)nextH absHorizontalDistance:(CGFloat)nextD {
    if (!rightLineView) {
        // alloc new
        rightLineView = [UIView new];
        rightLineView.layer.anchorPoint = CGPointMake(0.0, 0.5); // rotates relative to the center of the right edge
        rightLineView.layer.transform = CATransform3DMakeRotation(-0.5, 0, 0, 1); // use layer transfrom to avoid trouble with auto layout
        rightLineView.backgroundColor = [UIColor redColor];
        [self addSubview:rightLineView];
        [self sendSubviewToBack:rightLineView];
        
        // auto layout
        rightLineView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray <NSLayoutConstraint*>* rightLineViewConstraints = [[NSMutableArray alloc]init];
        [rightLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:rightLineView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:dataPointView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:0.0]];
        [rightLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:rightLineView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:dataPointView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];
        [rightLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:rightLineView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:30]];
        [rightLineViewConstraints addObject:[NSLayoutConstraint constraintWithItem:rightLineView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:LINE_WIDTH]];
        [NSLayoutConstraint activateConstraints:rightLineViewConstraints];
    }
    // init
}

- (void)showIcons {
    
}

@end
