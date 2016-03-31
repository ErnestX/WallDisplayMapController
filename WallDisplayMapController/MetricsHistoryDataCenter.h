//
//  MetricsDictionary.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricsHistoryDataCenter : NSObject

/**
 this is a singleton class
 */
+ (MetricsHistoryDataCenter *)sharedInstance;

- (NSInteger)getTotalNumberOfData;
- (NSDictionary*)getMetricsDataAtTimeIndex:(NSInteger)index;

@end
