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
#import "RabbitMQManager.h"
#import "DetailViewController.h"
#import "ThresholdChangeRequest.h"
#import <Chameleon.h>

@interface MaskContentView()<UITextFieldDelegate>

@end

@implementation MaskContentView {
    DetailViewController *targetVC;
    UIView *contentView;
    UIButton *btnSubmit;
    NSMutableArray *arrKeys;
    
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
        
        arrKeys = [NSMutableArray array];

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
            
            NSArray *thresHolds = content[@"additional"];
            if (thresHolds && [thresHolds count] > 0) {
                
                [lblSub mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.and.top.equalTo(contentView);
                    make.width.lessThanOrEqualTo(@500);
                }];
                
                
                for (int i=0; i<[thresHolds count]; i++) {
                    NSString *itemThreshold = thresHolds[i];
                    NSString *strPlaceHolder = [NSString stringWithFormat:@"%@ Threshold:", itemThreshold];
                    
                    UILabel *lblTitle = [[UILabel alloc] init];
                    lblTitle.attributedText = [[NSAttributedString alloc] initWithString:strPlaceHolder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:1.0],
                                                                                                                     NSFontAttributeName :[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]}];

                    [contentView addSubview:lblTitle];
                    
                    NSArray *currentThresholds = data[@"chart_content"][@"thresholds"];
                    NSString *temp = [NSString stringWithFormat:@"Current: %@", [currentThresholds[i][@"thresh_value"] stringValue]];
                    
                    UILabel *lblCurrentValue = [[UILabel alloc] init];
                    lblCurrentValue.attributedText = [[NSAttributedString alloc] initWithString:temp attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.7 alpha:0.7],
                                                                                                                            NSFontAttributeName :[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]}];
                    [contentView addSubview:lblCurrentValue];
                    
                    UITextField *tf = [[UITextField alloc] init];
                    tf.delegate = self;
                    tf.textAlignment = NSTextAlignmentLeft;
                    tf.tintColor = [UIColor lightGrayColor];
                    tf.keyboardAppearance = UIKeyboardAppearanceDark;
                    tf.returnKeyType = i==thresHolds.count-1? UIReturnKeyDone:UIReturnKeyNext;
                    tf.keyboardType = UIKeyboardTypeDecimalPad;
                    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                    tf.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
                    tf.textColor = [UIColor whiteColor];
                    tf.tag = 10000+i;
                    
                    [contentView addSubview:tf];
                    
                    [arrKeys addObject:[self getConstDictionary][itemThreshold]];
                    
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = [UIColor lightGrayColor];
                    [contentView addSubview:line];
                    
                    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(contentView).with.offset(35.0f);
                        make.width.equalTo(contentView).multipliedBy(2.0f).dividedBy(3.0f);
                        make.height.equalTo(@50.0);
                        make.centerY.equalTo(contentView.mas_top).with.offset(65.0 + 50.0 * i);
                    }];
                    
                    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.equalTo(tf.mas_leading).with.offset(-10.0f);
                        make.centerY.equalTo(tf);
                    }];
                    
                    [lblCurrentValue mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(tf.mas_trailing).with.offset(5.0f);
                        make.baseline.equalTo(lblTitle.mas_baseline);
                    }];
                    
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.equalTo(lblCurrentValue);
                        make.leading.equalTo(lblTitle);
                        make.height.equalTo(@1.0);
                        make.bottom.equalTo(tf);
                    }];
                    
                    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
                    btnSubmit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0];
                    [btnSubmit setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
                    [btnSubmit setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.3] forState:UIControlStateHighlighted];
                    [btnSubmit addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [contentView addSubview:btnSubmit];
                    
                    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(contentView);
                        make.centerY.equalTo(contentView).with.offset(-25.0);
                    }];
                    
                    
                    [[self viewWithTag:10000] becomeFirstResponder];

                }
                
            } else {
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
    


}

- (void)submitButtonPressed:(UIButton *)sender {
    [self hideMask];
    ThresholdChangeRequest *req = [[ThresholdChangeRequest alloc] init];
    
    [arrKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITextField *tf = (UITextField *)[contentView viewWithTag:10000+idx];
        if (!tf.text || tf.text.length==0) return;
        [req addKey:obj withValue:tf.text];
    }];
        
    [[RabbitMQManager sharedInstance] publishThresholdChangeWithBody:req.toString];
    
    
}

- (void) handleTapOnMask:(UIPanGestureRecognizer*)recognizer {
    
    __block BOOL shouldHideMask = YES;
    NSArray *subviews = [contentView subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *tf = obj;
            if ([tf isFirstResponder]) {
                [tf resignFirstResponder];
                shouldHideMask = NO;
                *stop = YES;
                return;
            }
        }
    }];
    
    if (shouldHideMask) {
        [self hideMask];
    }

}

- (void)hideMask {
    DEFINE_WEAK_SELF
    [targetVC deselectCellWithIndex:self.itemIndex];
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
                         [weakSelf removeFromSuperview];
                     }];

}

- (NSDictionary*)getConstDictionary {
    NSDictionary *result = @{@"Active" : @"active_density_threshold",
                             @"Transit" : @"transit_density_threshold",
                             @"DE" : @"district_threshold_FAR"};
    return result;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [[self viewWithTag:textField.tag+1] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
