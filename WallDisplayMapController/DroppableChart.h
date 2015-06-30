//
//  DroppableChart.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-29.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "JDDroppableView.h"

@interface DroppableChart : JDDroppableView

@property NSDictionary *dictChart;
@property NSInteger *chartTag;
@property NSString *chartType;
@property NSString *chartCategory;

@end
