//
//  DroppableBarChart.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableBarChart.h"
#import "PNChart.h"
#import <ChameleonFramework/Chameleon.h>

@implementation DroppableBarChart {
    
    NSDictionary *dictTitle;
    PNBarChart *barChart;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate {
    
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addDropTarget:target];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        dictTitle = @{@"CEEI_vkt" : @"Existing",
                      @"model_vkt" : @"Current design",
                      @"dwellings" : @"Dwellings",
                      @"people" : @"People"};
        
        barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        barChart.labelMarginTop = 10.0;
        barChart.labelFont = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:15.0];
        barChart.labelTextColor = [UIColor lightGrayColor];
        barChart.backgroundColor = ClearColor;//COLOR_BG_WHITE;
        barChart.yLabelFormatter = ^NSString *(CGFloat yLabelValue) {
            return [NSString stringWithFormat:@"%d", (int)yLabelValue];
        };
        barChart.barBackgroundColor = ClearColor;//COLOR_BG_WHITE;
        [self addSubview:barChart];
    }
    return self;
}


- (void)updateBarChartWithValues:(NSArray *)values labels:(NSArray *)labels type:(NSString *)type {
    
    barChart.barWidth = barChart.frame.size.width/([values count]*2);
    barChart.strokeColor = DICT_COLOR_TYPE[type];
    
    NSMutableArray *arrLabels = [NSMutableArray array];
//    [labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSString *text = (NSString *)obj;
//        arrLabels[idx] = dictTitle[text];
//        
//    }];
//    
    for (int i=0; i<labels.count; i++) {
        arrLabels[i] = dictTitle[labels[i]];
    }
    barChart.showLabel = YES;
    [barChart setXLabels:arrLabels];
    barChart.showLabel = NO;
    [barChart setYValues:values];
    [barChart strokeChart];
    
    [barChart.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *lblYValue = obj;
        if (lblYValue.tag >= 10086) {
            [lblYValue removeFromSuperview];
        }
    }];
    
    [barChart.bars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PNBar *bar = obj;
        UILabel *lblBar = [[UILabel alloc] initWithFrame:CGRectMake(bar.frame.origin.x, bar.strokeHeight, bar.frame.size.width, 30.0)];
        lblBar.tag = 10086+idx;
        lblBar.text = [(NSNumber *)values[idx] stringValue];
        lblBar.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:16.0];
        lblBar.textColor = barChart.labelTextColor;
        lblBar.textAlignment = NSTextAlignmentCenter;
        lblBar.alpha = 1.0;
        [barChart addSubview:lblBar];
        
        
    }];
    
}


@end
