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

#import "HistoryFilePathConfigs.h"

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
            instance.metricsData = [NSArray array];
            
            // create screenshots folder if it doesn't exist
            NSString* absFolderPath = [HistoryFilePathConfigs getAbsPathToScreenshotFolder];
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:absFolderPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:absFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
            NSAssert(!error, @"error creating screenshots folder");
            
            // retrive backup data if exists
            NSString* filePath = [HistoryFilePathConfigs getAbsPathToMetricsDataCodedFile];
            NSArray<NSData*>* metricsDataCoded = [NSArray arrayWithContentsOfFile:filePath];
            if (metricsDataCoded) {
                // retrieve success; decode array
                for (int i=0; i<metricsDataCoded.count; i++) {
                    MetricsDataEntry* decodedEntry =[NSKeyedUnarchiver unarchiveObjectWithData:[metricsDataCoded objectAtIndex:i]];
                    if (decodedEntry) {
                        [instance addNewEntry:decodedEntry];
                    }
                }
            }
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

- (void)addNewEntry:(MetricsDataEntry*)entry {
    NSLog(@"DataCenter: adding new entry");
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
    
    [self backupMetricsData];
}

- (void)backupMetricsData {
    
    // step1: code each MetricsDataEntry into NSData and save them into an array
    NSMutableArray<NSData*>* metricsDataCoded = [NSMutableArray arrayWithCapacity:self.metricsData.count];
    for (int i=0; i<self.metricsData.count; i++) {
        NSData *codedEntry = [NSKeyedArchiver archivedDataWithRootObject:[self.metricsData objectAtIndex:i]];
        [metricsDataCoded addObject:codedEntry];
    }
    
    // step2: write the array of NSData to disk
    NSString* filePath = [HistoryFilePathConfigs getAbsPathToMetricsDataCodedFile];
    BOOL succ = [metricsDataCoded writeToFile:filePath atomically:YES];
    if (!succ) {
        NSLog(@"Data Center: backup metricsData failed");
    }
}

- (void)addNewEntryWithScreenshot:(nonnull UIImage*)ss {
    NSDictionary<NSNumber*, NSNumber*>* dic = [self getCurrentMetricsValues];
    if (dic) {
        // save image to disk as png file
        NSInteger newIndex = self.metricsData.count;
        NSString *absFilePath = [HistoryFilePathConfigs getAbsPathToScreenshotFileGivenIndex:newIndex];
        BOOL succ = [UIImagePNGRepresentation(ss) writeToFile:absFilePath atomically:YES];
        NSAssert(succ, @"Data Center: unable to write screenshot to disk");
        
        // add new entry
        MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]
                                      initWithMetricsValues:dic
                                      previewImageFileName:[HistoryFilePathConfigs getScreenshotFileNameGivenIndex:newIndex]
                                      timeStamp:[NSDate date] // I'm cheating here by using the time the message is received. The correct approach is to let the table send the time itself, but I'm out of time... Though, as shown in real tests with the table, the difference should be within 3 seconds, at least for three iPads.
                                      tag:@"stub tag"
                                      flag:NO];
        [self addNewEntry:newEntry];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"I can't add a new entry because I don't know the values of metrics yet. Add or remove some cases from the table and try saving again"
                                                            message:@"if the problem is not solved, contact Ernest for further support xiangspecial2012@gmail.com"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        NSLog(@"Data Center: Cannot add entry: metrics data not available");
    }
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

- (nonnull NSString*)getAbsPathToScreenshotFolder {
    return [HistoryFilePathConfigs getAbsPathToScreenshotFolder];
}

- (nullable NSDictionary<NSNumber*, NSNumber*>*) getCurrentMetricsValues {
    if ([GlobalManager sharedInstance].modelBuildings &&
        [GlobalManager sharedInstance].modelDistrictEnergy &&
        [GlobalManager sharedInstance].modelDensity) {
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             /* =========== building ===========*/
                             
                             [GlobalManager sharedInstance].modelBuildings.people,
                             [NSNumber numberWithInteger:building_people],
                             
                             [GlobalManager sharedInstance].modelBuildings.dwellings,
                             [NSNumber numberWithInteger:building_dwellings],
                             
                             [GlobalManager sharedInstance].modelBuildings.detachedPercent,
                             [NSNumber numberWithInteger:building_detachedPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.attachedPercent,
                             [NSNumber numberWithInteger:building_attachedPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.stackedPercent,
                             [NSNumber numberWithInteger:building_stackedPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.rezPercent,
                             [NSNumber numberWithInteger:building_rezPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.commPercent,
                             [NSNumber numberWithInteger:building_commPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.civicPercent,
                             [NSNumber numberWithInteger:building_civicPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.indPercent,
                             [NSNumber numberWithInteger:building_indPercent],
                             
                             [GlobalManager sharedInstance].modelBuildings.far,
                             [NSNumber numberWithInteger:building_far],
                             
                             /* =========== district energy ===========*/
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.far,
                             [NSNumber numberWithInteger:districtEnergy_far],
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.heatingPercent,
                             [NSNumber numberWithInteger:districtEnergy_heatingPercent],
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.lightsPercent,
                             [NSNumber numberWithInteger:districtEnergy_lightsPercent],
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.mobilityPercent,
                             [NSNumber numberWithInteger:districtEnergy_mobilityPercent],
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.emissionsPerCapita,
                             [NSNumber numberWithInteger:districtEnergy_emissionsPerCapita],
                             
                             [GlobalManager sharedInstance].modelDistrictEnergy.energyHouseholdIncome,
                             [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome],
                             
                             /* ============ energy =========== */
                             
                             [GlobalManager sharedInstance].modelEnergy.mobilityPercent,
                             [NSNumber numberWithInteger:energy_mobilityPercent],
                             
                             [GlobalManager sharedInstance].modelEnergy.heatingAndHotWaterPercent,
                             [NSNumber numberWithInteger:energy_heatingAndHotWaterPercent],
                             
                             [GlobalManager sharedInstance].modelEnergy.lightsAndAppliancesPercent,
                             [NSNumber numberWithInteger:energy_lightsAndAppliancesPercent],
                             
                             [GlobalManager sharedInstance].modelEnergy.propaneIn,
                             [NSNumber numberWithInteger:energy_propaneIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.heatingoilIn,
                             [NSNumber numberWithInteger:energy_heatingoilIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.woodIn,
                             [NSNumber numberWithInteger:energy_woodIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.electricityIn,
                             [NSNumber numberWithInteger:energy_electricityIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.dieselIn,
                             [NSNumber numberWithInteger:energy_dieselIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.gasolineIn,
                             [NSNumber numberWithInteger:energy_gasolineIn],
                             
                             [GlobalManager sharedInstance].modelEnergy.propaneOut,
                             [NSNumber numberWithInteger:energy_propaneOut],
                             
                             [GlobalManager sharedInstance].modelEnergy.heatingoilOut,
                             [NSNumber numberWithInteger:energy_heatingoilOut],
                             
                             [GlobalManager sharedInstance].modelEnergy.woodOut,
                             [NSNumber numberWithInteger:energy_woodOut],
                             
                             [GlobalManager sharedInstance].modelEnergy.electricityOut,
                             [NSNumber numberWithInteger:energy_electricityOut],
                             
                             [GlobalManager sharedInstance].modelEnergy.dieselOut,
                             [NSNumber numberWithInteger:energy_dieselOut],
                             
                             [GlobalManager sharedInstance].modelEnergy.gasolineOut,
                             [NSNumber numberWithInteger:energy_gasolineOut],
                             
                             /* ============== density ===============*/
                             
                             [GlobalManager sharedInstance].modelDensity.densityMetric,
                             [NSNumber numberWithInteger:density_densityMetric],
                             
                             [GlobalManager sharedInstance].modelDensity.modelVKT,
                             [NSNumber numberWithInteger:density_modelVKT],
                             
                             [GlobalManager sharedInstance].modelDensity.CEEIKVT,
                             [NSNumber numberWithInteger:density_CEEIKVT],
                             
                             [GlobalManager sharedInstance].modelDensity.modelActiveTripsPercent,
                             [NSNumber numberWithInteger:density_modelActiveTripsPercent],
                             
                             [GlobalManager sharedInstance].modelDensity.modelTransitTripsPercent,
                             [NSNumber numberWithInteger:density_modelTransitTripsPercent],
                             
                             [GlobalManager sharedInstance].modelDensity.modelVehicleTripsPercent,
                             [NSNumber numberWithInteger:density_modelVehicleTripsPercent],
                             
                             nil];
        
        return dic;
    } else {
        return nil;
    }
}

// this method is for testing only
- (void)addNewDummyEntry {
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         
                         /* =========== building ===========*/
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_people],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_dwellings],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_detachedPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_attachedPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_stackedPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_rezPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_commPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_civicPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_indPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:building_far],
                         
                         /* =========== district energy ===========*/
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_far],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_heatingPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_lightsPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_mobilityPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_emissionsPerCapita],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome],
                         
                         /* ============ energy =========== */
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_mobilityPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_heatingAndHotWaterPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_lightsAndAppliancesPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_propaneIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_heatingoilIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_woodIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_electricityIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_dieselIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_gasolineIn],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_propaneOut],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_heatingoilOut],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_woodOut],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_electricityOut],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_dieselOut],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:energy_gasolineOut],
                         
                         /* ============== density ===============*/
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_densityMetric],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_modelVKT],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_CEEIKVT],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_modelActiveTripsPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_modelTransitTripsPercent],
                         
                         [NSNumber numberWithFloat:drand48()*1000.0],
                         [NSNumber numberWithInteger:density_modelVehicleTripsPercent],
                         
                         nil];
    
    NSString* path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    int i = rand();
    if (i%2) {
        path = [mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"];
    } else {
        path = [mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"];
    }
    
    UIImage* screenshot = [UIImage imageWithContentsOfFile:path];
    NSAssert(screenshot, @"cannot create dummy screenshot UIImage");
    
    NSInteger newIndex = self.metricsData.count;
    
    NSString* absFilePath = [HistoryFilePathConfigs getAbsPathToScreenshotFileGivenIndex:newIndex];
    BOOL succ = [UIImagePNGRepresentation(screenshot) writeToFile:absFilePath atomically:YES];
    NSAssert(succ, @"Data Center: unable to write screenshot to disk");
    
    MetricsDataEntry* newEntry = [[MetricsDataEntry alloc]
                                  initWithMetricsValues:dic
                                  previewImageFileName:[HistoryFilePathConfigs getScreenshotFileNameGivenIndex:newIndex]
                                  timeStamp:[NSDate date]
                                  tag:@"stub tag"
                                  flag:NO];
    [self addNewEntry:newEntry];
}

@end
