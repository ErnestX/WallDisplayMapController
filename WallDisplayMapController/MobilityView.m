//
//  MobilityView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-17.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MobilityView.h"
#import "PNChart.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>

@interface MobilityView()

@property PNBarChart *barChart;
@property UILabel *lblPlan;
@property UILabel *lblExisting;

@property NSMutableArray *arrCircleCharts;
@property NSArray *arrModeInfo;

@end

#define COLOR_LIGHT_BLUE [UIColor colorWithRed:0.518 green:0.824 blue:0.867 alpha:1.0]
#define COLOR_BG_WHITE [UIColor colorWithWhite:0.988 alpha:1.0]

@implementation MobilityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(120.0, -90.0, 200.0, 400.0)];
    self.barChart.labelFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0];
    self.barChart.labelTextColor = [UIColor lightGrayColor];
    self.barChart.backgroundColor = COLOR_BG_WHITE;
    [self addSubview:self.barChart];
        

    self.lblPlan = [[UILabel alloc] init];
    self.lblPlan.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblPlan];
        
    self.lblExisting = [[UILabel alloc] init];
    self.lblExisting.textColor = [UIColor lightGrayColor];
    self.lblExisting.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblExisting];
        
    // init circle charts
        
    self.arrModeInfo = @[@86, @27, @47];
    NSArray *arrModes = @[@"Active", @"Transit", @"Vehicle"];
    NSArray *arrIcons = @[@"walkingPersonIcon.png", @"busIcon.png", @"carIcon.png"];
    self.arrCircleCharts = [NSMutableArray array];
    for (int i=0; i<[self.arrModeInfo count]; i++) {
        PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(50+i*215.0, 350.0, 150.0, 150.0)
                                                                    total:@100
                                                                  current:self.arrModeInfo[i]
                                                                clockwise:YES
                                                                   shadow:YES
                                                              shadowColor:[UIColor colorWithFlatVersionOf:PNLightGrey]
                                                     displayCountingLabel:NO
                                                        overrideLineWidth:@25];
        [circleChart setStrokeColor:COLOR_LIGHT_BLUE];
        [self.arrCircleCharts addObject:circleChart];
        
        UILabel *lblMode = [[UILabel alloc] init];
        lblMode.text = [NSString stringWithFormat:@"%@: %@%%", arrModes[i], [self.arrModeInfo[i] stringValue]];
        lblMode.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25.0];
        lblMode.textAlignment = NSTextAlignmentCenter;
        lblMode.textColor = [UIColor lightGrayColor];
        [self addSubview:lblMode];
        
        [self addSubview:circleChart];
        
        [lblMode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(circleChart);
            make.bottom.equalTo(circleChart.mas_bottom).with.offset(40.0f);
        }];
        
        // Adding Icons
        
        UIView *bg = [[UIView alloc] init];
        bg.layer.cornerRadius = 37.0;
        bg.layer.masksToBounds = YES;
        bg.backgroundColor = COLOR_LIGHT_BLUE;
        UIImageView *ivIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrIcons[i]]];
        [self addSubview:bg];
        [bg addSubview:ivIcon];
        
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(circleChart);
            make.width.equalTo(@74);
            make.height.equalTo(@74);
        }];
        
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bg);
            make.width.height.equalTo(@52);
        }];
    
    }
        
        UILabel *lblForCircleCharts = [[UILabel alloc] init];
        lblForCircleCharts.textColor = [UIColor lightGrayColor];
        lblForCircleCharts.textAlignment = NSTextAlignmentCenter;
        lblForCircleCharts.numberOfLines = 0;
        lblForCircleCharts.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:@"Mode \n(% of annual trips by travel mode)"];
        [strAtt addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold"
                                             size:50.0]
                       range:NSMakeRange(0, 4)];
        [strAtt addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold"
                                             size:17.0]
                       range:NSMakeRange(4, strAtt.length-5)];
        lblForCircleCharts.attributedText = strAtt;
        
        [self addSubview:lblForCircleCharts];
        __weak typeof(self) weakSelf = self;
        [lblForCircleCharts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.arrCircleCharts[1]);
            make.bottom.equalTo(((UIView *)weakSelf.arrCircleCharts[1]).mas_top).with.offset(-20.0f);
        }];

        
        
    }
    return self;
}

- (void)updateWithModelDict:(NSDictionary *)dict {

    // Update bar chart
    self.barChart.yLabelFormatter = ^NSString *(CGFloat yLabelValue) {
        return [NSString stringWithFormat:@"%d", (int)yLabelValue];
    };
    self.barChart.barBackgroundColor = COLOR_BG_WHITE;
    self.barChart.barWidth = 50.0;
    self.barChart.strokeColors = @[COLOR_LIGHT_BLUE, [UIColor lightGrayColor]];
    [self.barChart setXLabels:@[@"plan", @"existing"]];
    self.barChart.showLabel = NO;
    [self.barChart setYValues:@[dict[@"plan_value"], dict[@"existing_value"]]];
    [self.barChart strokeChart];
    
    
    self.barChart.transform = CGAffineTransformMakeRotation(0.5*M_PI);
    
    // update label
    NSNumber *temp = dict[@"plan_value"];
    NSString *strPlan = [NSString stringWithFormat:@"%@ km/person in a year", temp];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strPlan];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:65.0]
                      range:NSMakeRange(0, [temp stringValue].length)];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:COLOR_LIGHT_BLUE
                      range:NSMakeRange(0, [temp stringValue].length)];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0]
                      range:NSMakeRange([temp stringValue].length, strPlan.length - [temp stringValue].length)];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor lightGrayColor]
                      range:NSMakeRange([temp stringValue].length, strPlan.length - [temp stringValue].length)];

    self.lblPlan.attributedText = attString;
    
    __weak typeof(self) weakSelf = self;
    [self.lblPlan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(30.0f);
        make.leading.equalTo(weakSelf.barChart.mas_trailing).with.offset(30.0f);
    }];
    
    
    temp = dict[@"existing_value"];
    NSString *strExisting = [NSString stringWithFormat:@"%@  Existing", temp];
    NSMutableAttributedString *attStrEx = [[NSMutableAttributedString alloc] initWithString:strExisting];
    [attStrEx addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:60.0]
                      range:NSMakeRange(0, [temp stringValue].length)];
    [attStrEx addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0] range:NSMakeRange([temp stringValue].length, strExisting.length - [temp stringValue].length)];
    
    
    self.lblExisting.attributedText = attStrEx;
    [self.lblExisting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblPlan.mas_baseline).with.offset(25.0f);
        make.leading.equalTo(weakSelf.lblPlan.mas_leading).with.offset(2.0f);
    }];
    
    // circle charts
    [self.arrCircleCharts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PNCircleChart *circleChart = obj;
        [circleChart strokeChart];
        
    }];


}

@end
