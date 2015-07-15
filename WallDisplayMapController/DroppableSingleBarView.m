//
//  DroppableSingleBarView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-14.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableSingleBarView.h"
#import "PNBarChart.h"

@implementation DroppableSingleBarView {
    PNBarChart *barChart;
    
    UILabel *lblCurrentValue;
    NSMutableArray *arrThresholdLables;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate {
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addDropTarget:target];
    }
    return self;
}



@end
