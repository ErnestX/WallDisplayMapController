//
//  MetricDataEntry.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricsDataEntry : NSObject

@property (readonly, nonnull) NSDictionary<NSNumber*, NSNumber*>* metricsValues;
@property (readonly, nonnull) NSString* previewImagePath;

- (nullable instancetype)initWithMetricsValues:(nonnull NSDictionary<NSNumber*, NSNumber*>*)dic
                     previewImagePath:(nonnull NSString*)path;

@end
