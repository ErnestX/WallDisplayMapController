//
//  LandUseView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-19.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "LandUseView.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"
#import "PNChart.h"


@interface LandUseView()

@property PNBarChart *barChart;
@property UILabel *lblPeople;
@property UILabel *lblDwellings;

@property NSArray *arrTypeKeys;
@property NSMutableArray *arrCircleCharts;
@property NSMutableArray *arrLabelTypes;

@end

@implementation LandUseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(120.0, -90.0, 200.0, 400.0)];
        self.barChart.labelFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0];
        self.barChart.labelTextColor = [UIColor lightGrayColor];
        self.barChart.backgroundColor = COLOR_BG_WHITE;
        [self addSubview:self.barChart];
        
        
        self.lblPeople = [[UILabel alloc] init];
        self.lblPeople.textAlignment = NSTextAlignmentCenter;
        self.lblPeople.textColor = [UIColor lightGrayColor];
        self.lblPeople.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:65.0];
        [self addSubview:self.lblPeople];
        
        self.lblDwellings = [[UILabel alloc] init];
        self.lblDwellings.textColor = [UIColor lightGrayColor];
        self.lblDwellings.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:65.0];
        self.lblDwellings.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblDwellings];
        
        // init circle charts
        self.arrTypeKeys = @[@"Single detached", @"Rowhouse", @"Apartment"];
        NSArray *arrIcons = @[@"houseIcon.png", @"rowHouseIcon.png", @"apartmentIcon.png"];
        self.arrCircleCharts = [NSMutableArray array];
        self.arrLabelTypes = [NSMutableArray array];
        for (int i=0; i<[self.arrTypeKeys count]; i++) {
            PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(50+i*215.0, 350.0, 150.0, 150.0)
                                                                        total:@100
                                                                      current:@0
                                                                    clockwise:YES
                                                                       shadow:YES
                                                                  shadowColor:[UIColor colorWithFlatVersionOf:PNLightGrey]
                                                         displayCountingLabel:NO
                                                            overrideLineWidth:@25];
            [circleChart setStrokeColor:COLOR_WATERMELON];
            [self.arrCircleCharts addObject:circleChart];
            
            UILabel *lblMode = [[UILabel alloc] init];
            lblMode.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25.0];
            lblMode.textAlignment = NSTextAlignmentCenter;
            lblMode.textColor = [UIColor lightGrayColor];
            [self.arrLabelTypes addObject:lblMode];
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
            bg.backgroundColor = COLOR_WATERMELON;
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
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:@"Unit Type \n(% of all residential units)"];
        [strAtt addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold"
                                             size:50.0]
                       range:NSMakeRange(0, 9)];
        [strAtt addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold"
                                             size:17.0]
                       range:NSMakeRange(9, strAtt.length-10)];
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
    self.barChart.strokeColor = COLOR_WATERMELON;
    [self.barChart setXLabels:@[@"People", @"Dwellings"]];
    self.barChart.showLabel = NO;
    [self.barChart setYValues:@[dict[@"people_value"], dict[@"dwelling_value"]]];
    [self.barChart strokeChart];
    
    
    self.barChart.transform = CGAffineTransformMakeRotation(0.5*M_PI);
    
    // update label
    NSNumber *temp = dict[@"people_value"];
    NSString *strPlan = [NSString stringWithFormat:@"%@ People", temp];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strPlan];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:COLOR_WATERMELON
                      range:NSMakeRange(0, [temp stringValue].length)];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40.0]
                      range:NSMakeRange([temp stringValue].length, strPlan.length - [temp stringValue].length)];
    
    self.lblPeople.attributedText = attString;
    
    __weak typeof(self) weakSelf = self;
    [self.lblPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(30.0f);
        make.leading.equalTo(weakSelf.barChart.mas_trailing).with.offset(30.0f);
    }];
    
    
    temp = dict[@"dwelling_value"];
    NSString *strExisting = [NSString stringWithFormat:@"%@ Dwellings", temp];
    NSMutableAttributedString *attStrEx = [[NSMutableAttributedString alloc] initWithString:strExisting];
    [attStrEx addAttribute:NSForegroundColorAttributeName
                      value:COLOR_WATERMELON
                      range:NSMakeRange(0, [temp stringValue].length)];
    [attStrEx addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40.0] range:NSMakeRange([temp stringValue].length, strExisting.length - [temp stringValue].length)];
    
    
    self.lblDwellings.attributedText = attStrEx;
    [self.lblDwellings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblPeople.mas_baseline).with.offset(25.0f);
        make.leading.equalTo(weakSelf.lblPeople.mas_leading).with.offset(2.0f);
    }];
    
    // circle charts
    [self.arrCircleCharts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PNCircleChart *circleChart = obj;
        circleChart.current = dict[weakSelf.arrTypeKeys[idx]];
        [circleChart strokeChart];
        
        UILabel *lblType = weakSelf.arrLabelTypes[idx];
        lblType.text = [NSString stringWithFormat:@"%@: %@%%", weakSelf.arrTypeKeys[idx], [circleChart.current stringValue]];
        
    }];
}

@end
