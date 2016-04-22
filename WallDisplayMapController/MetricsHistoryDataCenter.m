//
//  MetricsDictionary.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsHistoryDataCenter.h"
#import "MetricsConfigs.h"
#import "MetricsDataEntry.h"

@implementation MetricsHistoryDataCenter {
    NSMutableArray<NSDictionary*>* metricsData;
}

+ (MetricsHistoryDataCenter *)instance {
    static MetricsHistoryDataCenter *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
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

- (MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index {
    //    return [metricsData objectAtIndex:index]; // the right thing to do (don't forget to copy the object instead of using the original reference) 
    
    // stub for testing
    srand48(arc4random()); // set random seed
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:index/50.0], [NSNumber numberWithInteger:people],
                         [NSNumber numberWithFloat:(50-index)/50.0], [NSNumber numberWithInteger:dwelling],
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:active], nil];
    
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    // TODO: stub
    if (index%2) {
        path = [mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"];
    } else {
        path = [mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"];
    }
    
    MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]initWithMetricsValues:dic previewImagePath:path];
    
    return newEntry;
}

@end
