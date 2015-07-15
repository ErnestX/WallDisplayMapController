//
//  DroppableNumberView.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-14.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableChart.h"

@interface DroppableNumberView : DroppableChart

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate;
- (void)updateWithMainMeasure:(NSString *)main subMeasure:(NSString *)sub description:(NSString *)desc type:(NSString *)type;

@end
