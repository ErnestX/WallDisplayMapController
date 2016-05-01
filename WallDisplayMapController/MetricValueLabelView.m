//
//  MetricValueLabelView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-05-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricValueLabelView.h"
#import "MetricsHistoryDataCenter.h" // I'm not sure if this dependency is a good idea... but otherwise it would be such a long pass from the container controller all the way to metric view for a purpose this trival...  

@interface MetricValueLabelView ()
@property (readwrite)MetricName metricName;
@end

@implementation MetricValueLabelView {
    UILabel* metricValueLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
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
    metricValueLabel.text = [NSString stringWithFormat:@"%f", v];
    
    return self;
}

@end
