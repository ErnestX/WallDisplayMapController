//
//  MetricsDictionary.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetricsHistoryDataCenterDelegate.h"
#import "MetricsConfigs.h"

@class MetricsDataEntry;

@interface MetricsHistoryDataCenter : NSObject

/*
 this property is readonly and immutable
 notice that thresholds are not recorded
 */
@property (readonly, nonnull) NSArray<MetricsDataEntry*>* metricsData;
@property (readonly, nonnull) NSMutableDictionary<NSNumber*,NSNumber*>* maxValueDic;
@property (readonly, nonnull) NSMutableDictionary<NSNumber*,NSNumber*>* minValueDic;

/**
 this is a singleton class
 */
+ (nonnull MetricsHistoryDataCenter *)instance;

- (void)setDelegate:(nonnull id<MetricsHistoryDataCenterDelegate>)d;
- (NSInteger)getTotalNumberOfData;

- (nullable MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index;

- (void)addNewEntryWithScreenshot:(nonnull UIImage*)ss;

- (void)addNewDummyEntry;

- (nonnull NSString*)getAbsPathToScreenshotFolder;

//- (void)confirmAndWipeAllDataFromDisk;

@end
