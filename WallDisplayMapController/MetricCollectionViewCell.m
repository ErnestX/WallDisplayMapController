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
#import "DroppableNumberView.h"
#import "DroppableSingleBarView.h"

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
    
    NSArray *filteredKeys = [[content allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !([(NSString *)evaluatedObject isEqualToString:@"ch_key"] ||
                 [(NSString *)evaluatedObject isEqualToString:@"detail_info"]);
    }]] ;
    NSArray *filteredValues = [[content allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !([evaluatedObject isKindOfClass:[NSString class]] ||
                 [evaluatedObject isKindOfClass:[NSDictionary class]]);
    }]];
    
    if ([chartType isEqualToString:CHART_TYPE_BAR]) {
        DroppableBarChart *barChart = [[DroppableBarChart alloc] initWithFrame:self.bounds];
        barChart.isDraggable = NO;
        barChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in barChart.gestureRecognizers) {
            [barChart removeGestureRecognizer:recognizer];
        }
        [self addSubview:barChart];
        
        [barChart updateBarChartWithValues:filteredValues
                                    labels:filteredKeys
                                      type:chartCategory];
        
        

    } else if ([chartType isEqualToString:CHART_TYPE_CIRCLE]) {
        DroppableCircleChart *circleChart = [[DroppableCircleChart alloc] initWithFrame:self.bounds];
        circleChart.isDraggable = NO;
        circleChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in circleChart.gestureRecognizers) {
            [circleChart removeGestureRecognizer:recognizer];
        }
        [self addSubview:circleChart];
        [circleChart updateCircleChartWithCurrent:filteredValues[0]
                                             type:chartCategory
                                             icon:filteredKeys[0]];
        

    } else if ([chartType isEqualToString:CHART_TYPE_PIE]) {
        // not now

    } else if ([chartType isEqualToString:CHART_TYPE_NUMBER]) {
        DroppableNumberView *circleChart = [[DroppableNumberView alloc] initWithFrame:self.bounds];
        circleChart.isDraggable = NO;
        circleChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in circleChart.gestureRecognizers) {
            [circleChart removeGestureRecognizer:recognizer];
        }
        [self addSubview:circleChart];
        [circleChart updateWithMainMeasure:content[@"main"] subMeasure:content[@"sub"] description:content[@"desc"] type:chartCategory];
        
    } else if ([chartType isEqualToString:CHART_TYPE_SINGLE_BAR]) {
        DroppableSingleBarView *circleChart = [[DroppableSingleBarView alloc] initWithFrame:self.bounds];
        circleChart.isDraggable = NO;
        circleChart.tag = 33333;
        for (UIGestureRecognizer *recognizer in circleChart.gestureRecognizers) {
            [circleChart removeGestureRecognizer:recognizer];
        }
        [self addSubview:circleChart];
        [circleChart updateWithArrayThresholds:content[@"thresholds"] current:content[@"current"] title:content[@"title"] type:chartCategory];

    } else {
        // custom, not now
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesMoved:touches withEvent:event];
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

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
    } else {
        self.backgroundColor = COLOR_BG_WHITE;
    }
    
}

@end
