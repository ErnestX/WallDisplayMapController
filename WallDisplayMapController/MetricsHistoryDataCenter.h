//
//  MetricsDictionary.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MetricsDataEntry;

@interface MetricsHistoryDataCenter : NSObject
@property (readonly) NSMutableArray<MetricsDataEntry*>* metricsData;

/**
 this is a singleton class
 */
+ (MetricsHistoryDataCenter *)instance;

- (NSInteger)getTotalNumberOfData;
- (MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index;

@end
