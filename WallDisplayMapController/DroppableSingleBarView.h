//
//  DroppableSingleBarView.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-14.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableChart.h"

@interface DroppableSingleBarView : DroppableChart

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate;
- (void)updateWithArrayThresholds:(NSArray *)arrThresholds current:(NSNumber *)current title:(NSString *)title type:(NSString *)type;

@end
