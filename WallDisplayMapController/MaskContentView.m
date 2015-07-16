//
//  MaskContentView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MaskContentView.h"
#import "Masonry.h"
#import <Chameleon.h>

@implementation MaskContentView 

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)targetVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMask:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) handleTapOnMask:(UIPanGestureRecognizer*)recognizer {
    DEFINE_WEAK_SELF
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}


@end
