//
//  DroppableBarChart.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "JDDroppableView.h"

@interface DroppableBarChart : JDDroppableView

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate;
- (void)updateBarChartWithValues:(NSArray *)values labels:(NSArray *)labels type:(NSString *)type;

@end
