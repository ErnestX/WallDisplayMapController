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

@interface MetricsDataEntry ()
@property (readwrite) NSMutableArray<MetricsDataEntry*>* metricsData;
@end

@implementation MetricsHistoryDataCenter

+ (MetricsHistoryDataCenter *)instance {
    static MetricsHistoryDataCenter *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //init instance
        if (instance) {
            // init properties
            instance->_metricsData = [NSMutableArray array]; // a trick I do not fully understand yet to access readonly property from here.
            for (int i=0; i<50; i++) {
                // stub for testing
                srand48(arc4random()); // set random seed
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:i/50.0], [NSNumber numberWithInteger:people],
                                     [NSNumber numberWithFloat:(50-i)/50.0], [NSNumber numberWithInteger:dwelling],
                                     [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:active], nil];
                
                NSString* path;
                NSBundle *mainBundle = [NSBundle mainBundle];
                // stub for testing
                if (i%2) {
                    path = [mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"];
                } else {
                    path = [mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"];
                }
                
                MetricsDataEntry* entry = [[MetricsDataEntry alloc]initWithMetricsValues:dic previewImagePath:path];
                [instance.metricsData addObject:entry];
            }
        }
    });
    
    return instance;
}

- (NSInteger)getTotalNumberOfData {
    return self.metricsData.count;
}

- (MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index {
    return [self.metricsData objectAtIndex:index];
}

@end
