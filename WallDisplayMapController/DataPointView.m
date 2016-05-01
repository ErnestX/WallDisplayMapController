//
//  DataPointView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "DataPointView.h"

#define LABEL_LEFT_MARGIN 1.3

@interface DataPointView ()
@property (readwrite) MetricName metricName;
@end

@implementation DataPointView {
    UILabel* metricNameLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!metricNameLabel) {
            metricNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_LEFT_MARGIN, 0.0, self.bounds.size.width, self.bounds.size.height)];
            metricNameLabel.textColor = [UIColor whiteColor];
            metricNameLabel.adjustsFontSizeToFitWidth = YES;
            metricNameLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height];
            [self addSubview:metricNameLabel];
        }
    }
    
    return self;
}

- (id)initWithMetricName:(MetricName)m {
    self = [super init];
    
    NSLog(@"%d", self.subviews.count);
    if (self) {
        self.metricName = m;
        self.backgroundColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
        self.layer.cornerRadius = self.bounds.size.width/2.0;
        
        metricNameLabel.text = [[[[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]substringToIndex:1]uppercaseString]; // get the first charactor
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = self.bounds.size.width/2.0;
    metricNameLabel.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
}

@end
