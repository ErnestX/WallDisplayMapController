//
//  GraphLineView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-28.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricsConfigs.h"

@interface GraphLineView : UIView
@property (readonly) MetricName metricName;
@property (readonly) CGFloat connectedToDataPointWithHeight;
@property (readonly) CGFloat absHorizontalDistance;

/**
 can be called multiple times to rewrite previous settings
 */
- (id)initWithMetricName:(MetricName)m connectedToDataPointWithHeight:(CGFloat)h absHorizontalDistance:(CGFloat)d anchorPointOnRight:(BOOL)onRight;

@end
