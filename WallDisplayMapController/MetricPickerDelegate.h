//
//  MetricPickerDelegate.h
//  
//
//  Created by Jialiang Xiang on 2016-04-30.
//
//

#import <Foundation/Foundation.h>
#import "MetricsConfigs.h"

@protocol MetricPickerDelegate <NSObject>

@required
- (void)showPickerViewController:(UIViewController*)pvc fromView:(UIView*)v;
- (void)setMetricsConfigArrayByReplacingMetricAtIndexOfCell:(UITableViewCell*)cell withMetric:(MetricName)m;

@end
