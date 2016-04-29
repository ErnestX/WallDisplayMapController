//
//  MetricDataEntry.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricsDataEntry : NSObject <NSCopying, NSCoding>

/*
 this is the raw values for the metrics
 */
@property (readonly, nonnull) NSDictionary<NSNumber*, NSNumber*>* metricsValues;
@property (readonly, nonnull) NSString* previewImageFileName;
@property (readonly, nonnull) NSDate* timeStamp;
@property (readonly, nonnull) NSString* tag;
@property (readonly) BOOL flag;

- (nullable instancetype)initWithMetricsValues:(nonnull NSDictionary<NSNumber *,NSNumber *> *)dic
                          previewImageFileName:(nonnull NSString *)path
                                     timeStamp:(nonnull NSDate*)ts
                                           tag:(nonnull NSString*)tg
                                          flag:(BOOL)f;

@end
