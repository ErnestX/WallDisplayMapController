//
//  MetricsDictionary.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsHistoryDataCenter.h"
#import "MetricNameTypeDef.h"

@implementation MetricsHistoryDataCenter {
    NSMutableArray<NSDictionary*>* metricsData;
}

+ (MetricsHistoryDataCenter *)sharedInstance {
    static MetricsHistoryDataCenter *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
        //TODO init self
    });
    
    return instance;
}

- (NSInteger)getTotalNumberOfData {
    //    return metricsData.count; // the right thing to do
    
    // stub for testing
    return 50;
}

- (NSDictionary*)getMetricsDataAtTimeIndex:(NSInteger)index {
    //    return [metricsData objectAtIndex:index]; // the right thing to do
    
    // stub for testing
    srand48(arc4random()); // set random seed
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:index/50.0], [NSNumber numberWithInteger:people],
                         [NSNumber numberWithFloat:(50-index)/50.0], [NSNumber numberWithInteger:dwelling],
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:active], nil];
    return dic;
}

@end
