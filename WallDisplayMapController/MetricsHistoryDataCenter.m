//
//  MetricsDictionary.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsHistoryDataCenter.h"
#import "MetricsDataEntry.h"

#import "GlobalManager.h"
#import "DensityModel.h"
#import "EnergyModel.h"
#import "BuildingsModel.h"
#import "DistrictEnergyModel.h"

@interface MetricsHistoryDataCenter()
@property (readwrite, nonnull) NSArray<MetricsDataEntry*>* metricsData;
@property (readwrite, nonnull) NSMutableDictionary<NSNumber*,NSNumber*>* maxValueDic;
@property (readwrite, nonnull) NSMutableDictionary<NSNumber*,NSNumber*>* minValueDic;
@end

@implementation MetricsHistoryDataCenter {
    id<MetricsHistoryDataCenterDelegate> myDelegate;
}

+ (nonnull MetricsHistoryDataCenter *)instance {
    static MetricsHistoryDataCenter *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        if (instance) {
            // init properties
            
            instance.maxValueDic = [NSMutableDictionary dictionary];
            instance.minValueDic = [NSMutableDictionary dictionary];
            
            NSMutableArray* tempArray = [NSMutableArray array];
            
            // stub for testing
//            for (int i=0; i<50; i++) {
//                srand48(arc4random()); // set random seed
//                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithFloat:i/50.0], [NSNumber numberWithInteger:people],
//                                     [NSNumber numberWithFloat:(50-i)/50.0], [NSNumber numberWithInteger:dwelling],
//                                     [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:active], nil];
//                NSString* path;
//                NSBundle *mainBundle = [NSBundle mainBundle];
//                // stub for testing
//                if (i%2) {
//                    path = [mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"];
//                } else {
//                    path = [mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"];
//                }
//                
//                MetricsDataEntry* entry = [[MetricsDataEntry alloc]initWithMetricsValues:dic previewImagePath:path];
//                [tempArray addObject:entry];
//            }
            instance.metricsData = [tempArray copy];
        }
    });
    return instance;
}

- (void)setDelegate:(nonnull id<MetricsHistoryDataCenterDelegate>)d {
    myDelegate = d;
}

- (NSInteger)getTotalNumberOfData {
    return self.metricsData.count;
}

- (MetricsDataEntry*)getMetricsDataAtTimeIndex:(NSInteger)index {
    return [self.metricsData objectAtIndex:index];
}

// TODO: not tested yet!
// TODO: need to update max and min
//- (void)addNewEntries:(NSArray<MetricsDataEntry*>*)entries {
//    NSMutableArray* tempArray = [self.metricsData mutableCopy];
//    [tempArray addObjectsFromArray:entries];
//    self.metricsData = [tempArray copy];
//    for (int i=0; i<entries.count; i++) {
//        [myDelegate newEntryAppendedInDataCenter];
//    }
//}

- (void)addNewEntry:(MetricsDataEntry*)entry {
    // update max and min values
    for (NSNumber* metricNameInNSNumber in entry.metricsValues) {
        NSNumber* newValue = [entry.metricsValues objectForKey:metricNameInNSNumber];
        
        // max
        if ([self.maxValueDic objectForKey:metricNameInNSNumber]) {
            // existing max value exist
            NSNumber* oldValue = [self.maxValueDic objectForKey:metricNameInNSNumber];
            if ([newValue doubleValue] > [oldValue doubleValue]) {
                // new max found. overwrite
                [self.maxValueDic setObject:newValue forKey:metricNameInNSNumber];
            }
        } else {
            // create new pair in the dictionary and copy value
            [self.maxValueDic setObject:newValue forKey:metricNameInNSNumber];
        }
        
        // min
        if ([self.minValueDic objectForKey:metricNameInNSNumber]) {
            // existing min value exist
            NSNumber* oldValue = [self.minValueDic objectForKey:metricNameInNSNumber];
            if ([newValue doubleValue] < [oldValue doubleValue]) {
                // new min found. overwrite
                [self.minValueDic setObject:newValue forKey:metricNameInNSNumber];
            }
        } else {
            // create new pair in the dictionary and copy value
            [self.minValueDic setObject:newValue forKey:metricNameInNSNumber];
        }
    }
    
    // add entry to model
    NSMutableArray* tempArray = [self.metricsData mutableCopy];
    [tempArray addObject:entry];
    self.metricsData = [tempArray copy];
    [myDelegate newEntryAppendedInDataCenter];
    NSLog(@"DataCenter: adding new entry");
}

- (void)addNewEntryWithScreenshot:(nonnull UIImage*)ss {
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [GlobalManager sharedInstance].modelBuildings.people,
                         [NSNumber numberWithInteger:building_people],
                         
                         [GlobalManager sharedInstance].modelDistrictEnergy.energyHouseholdIncome,
                         [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome],
                         
                         [GlobalManager sharedInstance].modelDensity.modelActiveTripsPercent,
                         [NSNumber numberWithInteger:density_modelActiveTripsPercent],
                         
                         [GlobalManager sharedInstance].modelBuildings.detachedPercent,
                         [NSNumber numberWithInteger:building_detachedPercent], nil];
    
    // save image to disk as png file
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* fileName = [NSString stringWithFormat:@"%lu.png", (unsigned long)self.metricsData.count];
    NSString* filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [UIImagePNGRepresentation(ss) writeToFile:filePath atomically:YES];
    
    // add new entry
    MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]initWithMetricsValues:dic previewImagePath:filePath];
    [self addNewEntry:newEntry];
}

- (void)addNewDummyEntry {
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:drand48()*1000.0], [NSNumber numberWithInteger:building_people],
                         [NSNumber numberWithFloat:drand48()*1000.0], [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome],
                         [NSNumber numberWithFloat:drand48()*1000.0], [NSNumber numberWithInteger:density_modelActiveTripsPercent],
                         [NSNumber numberWithFloat:drand48()*1000.0], [NSNumber numberWithInteger:building_detachedPercent], nil];
    
    NSString* filePath;
    NSBundle *mainBundle = [NSBundle mainBundle];
    int i = rand();
    if (i%2) {
        filePath = [mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"];
    } else {
        filePath = [mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"];
    }
    
    MetricsDataEntry* entry = [[MetricsDataEntry alloc]initWithMetricsValues:dic previewImagePath:filePath];
    [self addNewEntry:entry];
}

// TODO: not tested yet!
- (void)wipeAllDataFromDisk {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:basePath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", basePath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

@end
