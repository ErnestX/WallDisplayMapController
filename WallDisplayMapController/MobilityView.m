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
@property NSMutableArray *arrPieCharts;

@end

@implementation MobilityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(15.0, 15.0, 300.0, 400.0)];
    self.barChart.labelFont = [UIFont fontWithName:@"Helvetica-Neue" size:14.0];

    self.barChart.backgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
    [self addSubview:self.barChart];
    }
    return self;
}

- (void)updateWithModelDict:(NSDictionary *)dict {

    self.barChart.yLabelFormatter = ^NSString *(CGFloat yLabelValue) {
        return [NSString stringWithFormat:@"%d", (int)yLabelValue];
    };
    [self.barChart setXLabels:@[@"plan", @"existing"]];
    self.barChart.showLabel = NO;
    [self.barChart setYValues:@[dict[@"plan_value"], dict[@"existing_value"]]];

    [self.barChart strokeChart];

}

@end
