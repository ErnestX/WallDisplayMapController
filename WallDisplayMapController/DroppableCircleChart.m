//
//  DroppableCircleChart.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableCircleChart.h"
#import "PNChart.h"
#import <ChameleonFramework/Chameleon.h>

const CGFloat CIRCLE_EDGE_INSET = 30.0;

@implementation DroppableCircleChart {
    PNCircleChart *circleChart;
    NSDictionary *dictTypeColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        dictTypeColor = @{@"Mobility" : COLOR_LIGHT_BLUE,
                          @"Buildings" : COLOR_WATERMELON,
                          @"Energy" : FlatGreen,
                          @"DistrictEnergy" : FlatPlum};
        
        circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(CIRCLE_EDGE_INSET, CIRCLE_EDGE_INSET, self.frame.size.width-2*CIRCLE_EDGE_INSET, self.frame.size.height-2*CIRCLE_EDGE_INSET)
                                                                    total:@100
                                                                  current:@0
                                                                clockwise:YES
                                                                   shadow:YES
                                                              shadowColor:[UIColor colorWithFlatVersionOf:PNLightGrey]
                                                     displayCountingLabel:NO
                                                        overrideLineWidth:@35];
        circleChart.userInteractionEnabled = NO;
        [self addSubview:circleChart];

        
    }
    return self;
}

- (void)updateCircleChartWithCurrent:(NSNumber *)current type:(NSString *)type icon:(NSString *)iconName {
    [circleChart setStrokeColor:dictTypeColor[type]];
    [circleChart strokeChart];
    [circleChart updateChartByCurrent:current];
}

@end
