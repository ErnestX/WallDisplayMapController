//
//  MetricValueLabelView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-05-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricValueLabelView.h"

#define LABEL_LEFT_MARGIN 2

static CGFloat const FONT_SIZE_CONST = -4.0;

@interface MetricValueLabelView ()
@property (readwrite)MetricName metricName;
@end

@implementation MetricValueLabelView {
    UILabel* metricValueLabel;
}

- (id)init {
    self = [super init];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        if (!metricValueLabel) {
            metricValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_LEFT_MARGIN, 0.0, self.bounds.size.width, self.bounds.size.height)];
            metricValueLabel.adjustsFontSizeToFitWidth = NO;
            metricValueLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height + FONT_SIZE_CONST];
            metricValueLabel.textColor = [UIColor whiteColor];
            [self addSubview:metricValueLabel];
        }
    }
    return self;
}

- (id)initWithMetricName:(MetricName)m value:(CGFloat)v {
    self.metricName = m;
    
    self.backgroundColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
    
    metricValueLabel.text = [NSString stringWithFormat:@"%.01f", v];
    
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    metricValueLabel.frame = CGRectMake(LABEL_LEFT_MARGIN, 0.0, self.bounds.size.width, self.bounds.size.height);
    metricValueLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height + FONT_SIZE_CONST];
}

@end
