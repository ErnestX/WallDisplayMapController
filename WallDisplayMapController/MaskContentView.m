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
        lblNoInfo.text = @"Sorry, there is no detailed information to be displayed for this metric.";
        [contentView addSubview:lblNoInfo];
        
        [lblNoInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.width.lessThanOrEqualTo(@500);
            make.centerY.equalTo(contentView);
        }];
        
    } else {
        // display three circle charts
        NSArray *circlesData = data[@"chart_content"][@"detail_info"];
        [circlesData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
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
