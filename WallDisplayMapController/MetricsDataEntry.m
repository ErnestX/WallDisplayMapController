//
//  MetricsDataEntry.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsDataEntry.h"

@interface MetricsDataEntry()
@property (nonnull) NSDictionary<NSNumber*, NSNumber*>* metricsValues;
@property (nonnull) NSString* previewImagePath;
@end

@implementation MetricsDataEntry

- (nullable instancetype)initWithMetricsValues:(nonnull NSDictionary<NSNumber *,NSNumber *> *)dic
                              previewImagePath:(nonnull NSString *)path {
    self = [super init];
    if (self) {
        self.metricsValues = dic;
        self.previewImagePath = path;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]initWithMetricsValues:self.metricsValues
                                                               previewImagePath:self.previewImagePath];
    return newEntry;
}

@end
