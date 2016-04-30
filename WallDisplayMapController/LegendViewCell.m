//
//  LegendViewCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "LegendViewCell.h"

@interface LegendViewCell ()
@property (readwrite) MetricName metricName;
@end

@implementation LegendViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    return self;
}

- (id)initForReuseWithMetricName:(MetricName)m {
    self.metricName = m;
    
    self.textLabel.text = [[MetricsConfigs instance] getDisplayNameForMetric:self.metricName];
    self.textLabel.textColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
}

@end
