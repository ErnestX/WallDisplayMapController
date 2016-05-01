//
//  LegendViewCell.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricsConfigs.h"
#import "MetricPickerDelegate.h"

@interface LegendViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
@property (readonly) MetricName metricName;

- (id)initForReuseWithMetricName:(MetricName)m myDelegate:(id<MetricPickerDelegate>)md;
- (id)initAsAddButton;

@end
