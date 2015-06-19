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

@implementation MobilityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(120.0, -90.0, 200.0, 400.0)];
    self.barChart.labelFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0];

    self.barChart.backgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
    [self addSubview:self.barChart];
        

    self.lblPlan = [[UILabel alloc] init];
    self.lblPlan.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblPlan];
        
    self.lblExisting = [[UILabel alloc] init];
    self.lblExisting.textColor = [UIColor lightGrayColor];
    self.lblExisting.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblExisting];
        
    // init circle charts
        
    self.arrModeInfo = @[@0.86, @0.27, @0.47];
    self.arrCircleCharts = [NSMutableArray array];
    for (int i=0; i<[self.arrModeInfo count]; i++) {
        PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(50+i*215.0, 300.0, 150.0, 150.0)
                                                                    total:@1.0
                                                                  current:self.arrModeInfo[i]
                                                                clockwise:YES
                                                                   shadow:YES
                                                              shadowColor:[UIColor colorWithFlatVersionOf:PNLightGrey]
                                                     displayCountingLabel:YES
                                                        overrideLineWidth:@25];
        [circleChart setStrokeColor:COLOR_LIGHT_BLUE];
        circleChart.countingLabelFontSize = 20.0;
        [self.arrCircleCharts addObject:circleChart];
        [self addSubview:circleChart];
    }
        
    }
    return self;
}

- (void)updateWithModelDict:(NSDictionary *)dict {

    // Update bar chart
    self.barChart.yLabelFormatter = ^NSString *(CGFloat yLabelValue) {
        return [NSString stringWithFormat:@"%d", (int)yLabelValue];
    };
    self.barChart.barBackgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
    self.barChart.barWidth = 50.0;
    self.barChart.strokeColors = @[COLOR_LIGHT_BLUE, [UIColor grayColor]];
    [self.barChart setXLabels:@[@"plan", @"existing"]];
    self.barChart.showLabel = NO;
    [self.barChart setYValues:@[dict[@"plan_value"], dict[@"existing_value"]]];
    [self.barChart strokeChart];
    
    
    self.barChart.transform = CGAffineTransformMakeRotation(0.5*M_PI);
    
    // Todo: update label
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
