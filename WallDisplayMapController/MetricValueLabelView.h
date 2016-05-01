//
//  MetricValueLabelView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-05-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricsConfigs.h"

@interface MetricValueLabelView : UIView
@property (readonly)MetricName metricName;

- (id)initWithMetricName:(MetricName)m value:(CGFloat)v;

@end
