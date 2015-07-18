//
//  MaskContentView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MaskContentView.h"
#import "Masonry.h"
#import "DroppableCircleChart.h"
#import "DetailViewController.h"
#import <Chameleon.h>

@implementation MaskContentView {
    DetailViewController *targetVC;
    UIView *contentView;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)tvc {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        targetVC = (DetailViewController *)tvc;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMask:)];
        [self addGestureRecognizer:tap];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 700.0, 400.0)];
        contentView.center = self.center;
        contentView.backgroundColor = ClearColor;
        [self addSubview:contentView];

    }
    return self;
}

- (void)showContent:(NSDictionary *)data {
    if (!data[@"chart_content"][@"detail_info"]) {
        UILabel *lblNoInfo = [[UILabel alloc] init];
        lblNoInfo.textColor = COLOR_BG_WHITE;
        lblNoInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
        lblNoInfo.textAlignment = NSTextAlignmentCenter;
        lblNoInfo.numberOfLines = 0;
        lblNoInfo.lineBreakMode = NSLineBreakByWordWrapping;
        lblNoInfo.text = @"Sorry, there is no detailed information to be displayed for this indicator.";
        [contentView addSubview:lblNoInfo];
        
        UIImageView *iconError = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error_img2.png"]];
        iconError.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:iconError];
        
        [lblNoInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.width.lessThanOrEqualTo(@500);
            make.centerY.equalTo(contentView);
        }];
        
        [iconError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.bottom.equalTo(lblNoInfo.mas_top).with.offset(-20.0f);
            make.width.height.equalTo(@50);
        }];
        
    } else {
        NSString *type = data[@"chart_content"][@"detail_info"][@"type"];
        
        if ([type isEqualToString:@"circles"]) {
            NSArray *content = data[@"chart_content"][@"detail_info"][@"data"];
            
            [content enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *iconName = [NSString stringWithFormat:@"%@_icon.png", obj[@"key"]];
                    NSNumber *currentValue = obj[@"value"];
                    
                    CGFloat circleSide = 700.0/3;
                    
                    DroppableCircleChart *circleChart = [[DroppableCircleChart alloc] initWithFrame:CGRectMake(idx*circleSide, 400.0/2-circleSide/2, circleSide, circleSide)];
                    circleChart.isDraggable = NO;
                    [circleChart clearBg];
                    [circleChart setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
                    [circleChart changeTextColorTo:FlatWhite];
                    for (UIGestureRecognizer *recognizer in circleChart.gestureRecognizers) {
                        [circleChart removeGestureRecognizer:recognizer];
                    }
                    [contentView addSubview:circleChart];
                    [circleChart updateCircleChartWithCurrent:currentValue
                                                         type:data[@"chart_category"]
                                                         icon:iconName];
                });
                
                
            }];

        } else {
            NSDictionary *content = data[@"chart_content"][@"detail_info"][@"data"];
            
            NSString *title = content[@"title"];
            NSString *subtitle = content[@"subtitle"];
            
            UILabel *lblTitle = [[UILabel alloc] init];
            lblTitle.text = title;
            lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40.0f];
            lblTitle.textColor = COLOR_BG_WHITE;
            [contentView addSubview:lblTitle];
            
            UILabel *lblSub = [[UILabel alloc] init];
            lblSub.text = subtitle;
            lblSub.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0f];
            lblSub.textColor = COLOR_BG_WHITE;
            lblSub.numberOfLines = 0;
            lblSub.lineBreakMode = NSLineBreakByWordWrapping;
            [contentView addSubview:lblSub];
            
            [lblSub mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(contentView);
                make.width.lessThanOrEqualTo(@500);
            }];
            
            [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.bottom.equalTo(lblSub.mas_top).with.offset(-20.0f);
            }];

            
        }
        
        
    }
    


}

- (void) handleTapOnMask:(UIPanGestureRecognizer*)recognizer {
    DEFINE_WEAK_SELF
    [targetVC deselectCellWithIndex:self.itemIndex];
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
