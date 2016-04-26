//
//  MetricsDictionary.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetricsHistoryDataCenterDelegate.h"

@class MetricsDataEntry;

@interface MetricsHistoryDataCenter : NSObject

/*
 this property is readonly and immutable
 */
@property (readonly) NSArray<MetricsDataEntry*>* metricsData;

/**
 this is a singleton class
 */
+ (MetricsHistoryDataCenter *)instance;

- (void)setDelegate:(nonnull id<MetricsHistoryDataCenterDelegate>)delegate;
- (NSInteger)getTotalNumberOfData;
- (MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index;
- (void)addNewEntry:(MetricsDataEntry*)entry;

@end
