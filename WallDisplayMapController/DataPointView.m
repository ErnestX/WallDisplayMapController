//
//  DataPointView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "DataPointView.h"

@interface DataPointView ()
@property (readwrite) MetricName metricName;
@end

@implementation DataPointView

- (id)initWithMetricName:(MetricName)m {
    self = [super init];
    if (self) {
        self.metricName = m;
        self.backgroundColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
        self.layer.cornerRadius = self.bounds.size.width/2.0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = self.bounds.size.width/2.0;
}

@end
