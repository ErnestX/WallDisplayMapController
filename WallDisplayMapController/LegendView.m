//
//  LegendView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "LegendView.h"

@implementation LegendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        self.layer.borderWidth = 5.0; // the border is within the bound (inset)
    }
    
    return self;
}


@end