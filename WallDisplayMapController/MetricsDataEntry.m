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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.metricsValues = [aDecoder decodeObjectForKey:@"metricsValues"];
        self.previewImagePath = [aDecoder decodeObjectForKey:@"previewImagePath"];
        self.timeStamp = [aDecoder decodeObjectForKey:@"timeStamp"];
        self.tag = [aDecoder decodeObjectForKey:@"tag"];
        self.flag = [aDecoder decodeBoolForKey:@"flag"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.metricsValues forKey:@"metricsValues"];
    [aCoder encodeObject:self.previewImagePath forKey:@"previewImagePath"];
    [aCoder encodeObject:self.timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeBool:self.flag forKey:@"flag"];
}

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
