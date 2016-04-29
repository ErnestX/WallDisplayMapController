//
//  MetricsDataEntry.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsDataEntry.h"

@interface MetricsDataEntry()
@property (readwrite, nonnull) NSDictionary<NSNumber*, NSNumber*>* metricsValues;
@property (readwrite, nonnull) NSString* previewImagePath;
@property (readwrite, nonnull) NSDate* timeStamp;
@property (readwrite, nonnull) NSString* tag;
@property (readwrite) BOOL flag;
@end

@implementation MetricsDataEntry

- (nullable instancetype)initWithMetricsValues:(nonnull NSDictionary<NSNumber *,NSNumber *> *)dic
                              previewImagePath:(nonnull NSString *)path
                                     timeStamp:(nonnull NSDate*)ts
                                           tag:(nonnull NSString*)tg
                                          flag:(BOOL)f {
    self = [super init];
    if (self) {
        self.metricsValues = dic;
        self.previewImagePath = path;
        self.timeStamp = ts;
        self.tag = tg;
        self.flag = f;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]initWithMetricsValues:self.metricsValues
                                                               previewImagePath:self.previewImagePath
                                                                      timeStamp:self.timeStamp
                                                                            tag:self.tag
                                                                           flag:self.flag];
    return newEntry;
}

@end
