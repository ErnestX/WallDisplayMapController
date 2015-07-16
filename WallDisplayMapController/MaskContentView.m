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

@implementation MaskContentView {
    UIView *contentView;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)targetVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMask:)];
        [self addGestureRecognizer:tap];        

    }
    return self;
}

- (void)showContent:(NSDictionary *)data {
    DEFINE_WEAK_SELF
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [weakSelf addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.equalTo(@400);
        make.width.equalTo(@700);
    }];
    
    if (!data[@"detail_info"]) {
        UILabel *lblNoInfo = [[UILabel alloc] init];
        lblNoInfo.textColor = COLOR_BG_WHITE;
        lblNoInfo.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0];
        lblNoInfo.textAlignment = NSTextAlignmentCenter;
        lblNoInfo.numberOfLines = 0;
        lblNoInfo.lineBreakMode = NSLineBreakByWordWrapping;
        lblNoInfo.text = @"Sorry, there are no detailed information to be displayed for this element.";
        [contentView addSubview:lblNoInfo];
        
        [lblNoInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(contentView);
        }];
        
        
    } else {
        
    }
    


}

- (void) handleTapOnMask:(UIPanGestureRecognizer*)recognizer {
    DEFINE_WEAK_SELF
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}


@end
