//
//  DroppableCircleChart.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableChart.h"

@interface DroppableCircleChart : DroppableChart

- (void)updateCircleChartWithCurrent:(NSNumber *)current type:(NSString *)type icon:(NSString *)iconName;

- (void)clearBg;
- (void)setShadowColor:(UIColor *)color;
- (void)changeTextColorTo:(UIColor *)color;

@end
