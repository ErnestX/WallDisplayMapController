//
//  DroppableChart.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-29.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#define BUTTON_SIZE 45.0
#import "DroppableChart.h"

@implementation DroppableChart

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.animator = [[WobbleAnimator alloc] initWithTarget:self];
        self.btnDelete = [DeleteButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(8.0, 25.0-10.0, BUTTON_SIZE, BUTTON_SIZE);
        self.btnDelete.hidden = YES;
        [self addSubview:self.btnDelete];
        
        self.lblInfo = [[InfoLabel alloc] initWithFrame:CGRectMake(8.0, 25.0-10.0, BUTTON_SIZE, BUTTON_SIZE)];
        self.lblInfo.hidden = YES;
        [self addSubview:self.lblInfo];
        
        
    }
    return self;
}

@end
