//
//  MetricsConfigurations.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MetricName) {
    people,
    dwelling,
    active,
    populationDensity
};

@interface MetricsConfigs : NSObject

/**
 this is a singleton class
 */
+ (MetricsConfigs*)instance;

- (UIImage*)getIconForMetric:(MetricName)m;
- (UIColor*)getColorForMetric:(MetricName)m;

@end
