//
//  DroppableChart.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-29.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#define BUTTON_SIZE 20.0
#import "DroppableChart.h"

@implementation DroppableChart

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.animator = [[WobbleAnimator alloc] initWithTarget:self];
        self.btnDelete = [DeleteButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(10.0, BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE);
        self.btnDelete.hidden = YES;
        [self addSubview:self.btnDelete];
        
    }
    return self;
}

@end
