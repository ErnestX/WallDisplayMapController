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
@property (readwrite) NSArray<MetricsDataEntry*>* metricsData;
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
- (void)addNewEntries:(NSArray<MetricsDataEntry*>*)entries {
    NSMutableArray* tempArray = [self.metricsData mutableCopy];
    [tempArray addObjectsFromArray:entries];
    self.metricsData = [tempArray copy];
    for (int i=0; i<entries.count; i++) {
        [myDelegate newEntryAppendedInDataCenter];
    }
}

- (void)addNewEntry:(MetricsDataEntry*)entry {
    NSMutableArray* tempArray = [self.metricsData mutableCopy];
    [tempArray addObject:entry];
    self.metricsData = [tempArray copy];
    [myDelegate newEntryAppendedInDataCenter];
    NSLog(@"adding new entry");
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
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:building_people],
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome],
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:density_modelActiveTripsPercent],
                         [NSNumber numberWithFloat:drand48()], [NSNumber numberWithInteger:building_detachedPercent], nil];
    
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
