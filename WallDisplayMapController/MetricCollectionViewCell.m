//
//  MetricCollectionViewCell.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-03.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MetricCollectionViewCell.h"
#import "DroppableChart.h"
#import "DroppableBarChart.h"
#import "DroppableCircleChart.h"

@implementation MetricCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)updateWithData:(NSDictionary *)dict {
    NSString *chartType = dict[@"chart_type"];
    NSDictionary *content = dict[@"chart_content"];
    NSString *chartCategory = dict[@"chart_category"];
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([chartType isEqualToString:CHART_TYPE_BAR]) {
        DroppableBarChart *barChart = [[DroppableBarChart alloc] initWithFrame:self.bounds];
        barChart.isDraggable = NO;
        barChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in barChart.gestureRecognizers) {
            [barChart removeGestureRecognizer:recognizer];
        }
        [self addSubview:barChart];
        [barChart updateBarChartWithValues:[content allValues]
                                    labels:[content allKeys]
                                      type:chartCategory];
        

    } else if ([chartType isEqualToString:CHART_TYPE_CIRCLE]) {
        DroppableCircleChart *circleChart = [[DroppableCircleChart alloc] initWithFrame:self.bounds];
        circleChart.isDraggable = NO;
        circleChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in circleChart.gestureRecognizers) {
            [circleChart removeGestureRecognizer:recognizer];
        }        [self addSubview:circleChart];
        [circleChart updateCircleChartWithCurrent:[content allValues][0]
                                             type:chartCategory
                                             icon:[content allKeys][0]];
        

    } else if ([chartType isEqualToString:CHART_TYPE_PIE]) {
        // not now

    } else {
        // custom, not now
    }
}

- (void)changeBgColor:(UIColor *)color {
    
}

- (void)startAnimatingWithTarget:(id)target {
    DroppableChart *chart = (DroppableChart *)[self viewWithTag:33333];
    [chart.btnDelete addTarget:target
                        action:@selector(deleteElement:)
              forControlEvents:UIControlEventTouchUpInside];
    chart.btnDelete.hidden = NO;
    [chart bringSubviewToFront:chart.btnDelete];
    [chart.animator startAnimation];
}

- (void)stopAnimating {
    DroppableChart *chart = (DroppableChart *)[self viewWithTag:33333];
    chart.btnDelete.hidden = YES;
    [chart.btnDelete removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [chart.animator stopAnimation];
}

@end
