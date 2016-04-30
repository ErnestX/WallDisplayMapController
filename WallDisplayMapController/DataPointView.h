//
//  DataPointView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MetricsConfigs.h"

@interface DataPointView : UIView
@property (readonly) MetricName metricName;

/**
 can be called multiple times to rewrite previous settings
 */
- (id)initWithMetricName:(MetricName)m;

@end
