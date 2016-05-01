//
//  MetricValueLabelView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-05-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricValueLabelView.h"

@interface MetricValueLabelView ()
@property (readwrite)MetricName metricName;
@end

@implementation MetricValueLabelView {
    UILabel* metricValueLabel;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        if (!metricValueLabel) {
            metricValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
            metricValueLabel.adjustsFontSizeToFitWidth = YES;
            metricValueLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height];
            [self addSubview:metricValueLabel];
        }
    }
    return self;
}

- (id)initWithMetricName:(MetricName)m value:(CGFloat)v {
    self.metricName = m;
    
    metricValueLabel.textColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
    metricValueLabel.text = [NSString stringWithFormat:@"%.02f", v];
    
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    metricValueLabel.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    metricValueLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height];
}

@end
