//
//  DroppableSingleBarView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-14.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableSingleBarView.h"
#import "Masonry.h"
#import <Chameleon.h>

@implementation DroppableSingleBarView {
    
    UIView *vStrokeBar;
    UIView *vBarBg;
    
    UILabel *lblTitle;
    
    /* Array of dictionaries that contain 2 k-v pairs: iconName and valueOnBar */
    NSMutableArray *arrThresholdLables;

    /* current value on the right hand side of the bar */
    UILabel *lblCurrentValue;
    
    CGFloat maxValue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLOR_BG_WHITE;
        maxValue = 0.0;
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:25.0f];
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.numberOfLines = 0;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblTitle];
        
        vBarBg = [[UIView alloc] init];
        vBarBg.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        [self addSubview:vBarBg];
        
        vStrokeBar = [[UIView alloc] init];
        [self addSubview:vStrokeBar];
        
        DEFINE_WEAK_SELF
        [vBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf).with.offset(50.0f);
            make.width.equalTo(@20);
            make.bottom.equalTo(weakSelf).with.offset(-5.0f);
            make.height.equalTo(weakSelf.mas_height).multipliedBy(0.9f);
        }];
        
        [vStrokeBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(vBarBg);
            make.height.equalTo(@0);
        }];
        
        lblCurrentValue = [[UILabel alloc] init];
        lblCurrentValue.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0];
        [self addSubview:lblCurrentValue];
        
        [lblCurrentValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.centerX.equalTo(vBarBg).with.offset(30.0f);
        }];
        
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf).with.offset(20.0f);
            make.trailing.lessThanOrEqualTo(vBarBg.mas_leading).with.offset(-35.0f);
            make.bottom.equalTo(vBarBg).with.offset(-20.0f);
        }];
        
        arrThresholdLables = [NSMutableArray arrayWithCapacity:5];
        
        [self layoutIfNeeded];

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

- (void)updateWithArrayThresholds:(NSArray *)arrThresholds current:(NSNumber *)current title:(NSString *)title type:(NSString *)type {
    
    [arrThresholdLables makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [arrThresholdLables removeAllObjects];
    
    lblTitle.text = title;
    
    DEFINE_WEAK_SELF

    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:arrThresholds.count];
    [arrThresholds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        temp[idx] = dict[@"thresh_value"];
    }];
    maxValue = MAX([current doubleValue], [[temp valueForKeyPath:@"@max.doubleValue"] doubleValue]);
    maxValue = maxValue * 1.2;
    vStrokeBar.backgroundColor = DICT_COLOR_TYPE[type];
    
    // Stroke bar
    [vStrokeBar mas_updateConstraints:^(MASConstraintMaker *make) {
        float percent = [current floatValue] / maxValue;
        make.height.equalTo(vBarBg).multipliedBy(percent);
    }];
    
    lblCurrentValue.text = [current stringValue];
    lblCurrentValue.textColor = DICT_COLOR_TYPE[type];
    
    [lblCurrentValue mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vStrokeBar.mas_top);
    }];
    
    // Add threshold labels
    [arrThresholds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *iconBg = [[UIView alloc] init];
            iconBg.backgroundColor = DICT_COLOR_TYPE[type];
            iconBg.layer.cornerRadius = 27.0/2;
            iconBg.layer.masksToBounds = YES;
            [weakSelf addSubview:iconBg];
            
            UIImageView *ivTh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dict[@"thresh_icon"]]];
            ivTh.contentMode = UIViewContentModeScaleAspectFit;
            [iconBg addSubview:ivTh];
            
            UIView *vLine = [[UIView alloc] init];
            vLine.backgroundColor = [UIColor lightGrayColor];
            [vBarBg addSubview:vLine];
            [vBarBg bringSubviewToFront:vLine];
            
            [iconBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(vBarBg).with.offset(-31.0f);
                make.width.height.equalTo(@27);
        
                float percent = [dict[@"thresh_value"] floatValue]/maxValue;
                float total = weakSelf.frame.size.height*0.9-5.0;
                make.top.equalTo(vBarBg.mas_top).with.offset(total*(1-percent));
            }];
            
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(vBarBg).multipliedBy(1.2f);
                make.trailing.equalTo(vBarBg);
                make.height.equalTo(@1.0);
                make.centerY.equalTo(iconBg);
            }];
            
            [ivTh mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(iconBg);
                make.height.width.equalTo(@17.0);
            }];
            
            [arrThresholdLables addObject:iconBg];
            
        });
    }];
    
    
    // Animate update constraint
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [vStrokeBar layoutIfNeeded];
                     }
                     completion:nil];
}


@end
