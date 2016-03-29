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
#define LINE_LENGTH 40

@implementation MetricView
{
    CGRect oldFrame;
    CGFloat dataPointPosition;
    UIView* dataPointView;
    NSLayoutConstraint* dataPointCenterYConstraint;
    GraphLineView* leftLineView;
    GraphLineView* rightLineView;
}

- (id)initWithMetricName:(NSString*)m position:(CGFloat)p color:(UIColor*)c {
    dataPointPosition = p;
    
    // draw the data point (each metric view contains only one data point)
    if (!dataPointView) {
        dataPointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DATA_POINT_DIAMETER, DATA_POINT_DIAMETER)];
        NSAssert(dataPointView, @"init failed");
        [self addSubview:dataPointView];
    }
    
    dataPointView.backgroundColor = c;
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0; // the border is within the bound (inset)
    
    [self updateDataPointAccoridngToFrameSize:self.frame.size];
//    [self updateExistingLinesAccordingToFrameHeight:self.frame.size.height];
    
    return self;
}

- (void)removeLeftLine {
    if (leftLineView) {
        [leftLineView removeFromSuperview];
        leftLineView = nil;
    }
}

- (void)removeRightLine {
    if (rightLineView) {
        [rightLineView removeFromSuperview];
        rightLineView = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.frame.size, oldFrame.size)) {
        [self updateDataPointAccoridngToFrameSize:self.frame.size];
        [self updateExistingLinesAccordingToFrameHeight:self.frame.size.height];
        oldFrame = self.frame;
    }
}

- (void)updateDataPointAccoridngToFrameSize:(CGSize)size {
    // map the position to a different range for rendering
    CGFloat renderPos = dataPointPosition * (MAX_RENDER_POSITION - MIN_RENDER_POSITION) + MIN_RENDER_POSITION; // map p from 0-1 to rendering range
    dataPointView.center = CGPointMake(size.width/2.0, size.height * renderPos);
}

- (void)updateExistingLinesAccordingToFrameHeight:(CGFloat)h {
    if (leftLineView) {
        leftLineView.center = dataPointView.center;
        CGFloat angle = atan((dataPointPosition-leftLineView.connectedToDataPointWithHeight)
                             * h*(MAX_RENDER_POSITION - MIN_RENDER_POSITION)
                             / leftLineView.absHorizontalDistance);
        leftLineView.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1); // use layer transfrom to avoid trouble with auto layout
    }
    if (rightLineView) {
        rightLineView.center = dataPointView.center;
        CGFloat angle = atan((rightLineView.connectedToDataPointWithHeight - dataPointPosition)
                             * h*(MAX_RENDER_POSITION - MIN_RENDER_POSITION)
                             / rightLineView.absHorizontalDistance);
        rightLineView.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1); // use layer transfrom to avoid trouble with auto layout
    }
}

- (void)addLeftLineWithPrevDataPointHeight:(CGFloat)prevH absHorizontalDistance:(CGFloat)prevD {
    if (!leftLineView) {
        // alloc new
        leftLineView = [[[GraphLineView alloc]
                         initWithFrame:CGRectMake(0, 0, LINE_LENGTH, LINE_WIDTH)]
                        initWithColor:[UIColor redColor]
                        connectedToDataPointWithHeight:prevH
                        absHorizontalDistance:prevD
                        anchorPointOnRight:YES];
    
        [self addSubview:leftLineView];
        [self sendSubviewToBack:leftLineView];
    } else {
        leftLineView = [leftLineView initWithColor:[UIColor redColor]
                    connectedToDataPointWithHeight:prevH
                             absHorizontalDistance:prevD
                                anchorPointOnRight:YES];
    }
    
    [self updateExistingLinesAccordingToFrameHeight:self.frame.size.height];
}

- (void)addRightLineWithNextDataPointHeight:(CGFloat)nextH absHorizontalDistance:(CGFloat)nextD {
    if (!rightLineView) {
        // alloc new
        rightLineView = [[[GraphLineView alloc]initWithFrame:CGRectMake(0, 0, LINE_LENGTH, LINE_WIDTH)]
                         initWithColor:[UIColor redColor]
                         connectedToDataPointWithHeight:nextH
                         absHorizontalDistance:nextD
                         anchorPointOnRight:NO];
        [self addSubview:rightLineView];
        [self sendSubviewToBack:rightLineView];
    } else {
        rightLineView = [rightLineView initWithColor:[UIColor redColor]
                      connectedToDataPointWithHeight:nextH
                               absHorizontalDistance:nextD
                                  anchorPointOnRight:NO];
    }
    
    [self updateExistingLinesAccordingToFrameHeight:self.frame.size.height];
}

- (void)showIcons {
    
}

@end
