//
//  DroppableCircleChart.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "JDDroppableView.h"

@interface DroppableCircleChart : JDDroppableView

- (void)updateCircleChartWithCurrent:(NSNumber *)current type:(NSString *)type icon:(NSString *)iconName;

@end
