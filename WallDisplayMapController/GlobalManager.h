//
//  GlobalManager.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-07.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DensityModel;
@class BuildingsModel;
@class EnergyModel;
@class DistrictEnergyModel;

@interface GlobalManager : NSObject

@property UIViewController *targetVC;

@property (readonly, nonatomic, strong) DensityModel *modelDensity;
@property (readonly, nonatomic, strong) BuildingsModel *modelBuildings;
@property (readonly, nonatomic, strong) EnergyModel *modelEnergy;
@property (readonly, nonatomic, strong) DistrictEnergyModel *modelDistrictEnergy;

+ (GlobalManager *)sharedInstance;
- (void)beginConsumingMetricsData;
- (NSArray *)getWidgetElementsByCategory:(NSString *)category;
- (NSDictionary *)getWidgetElementByCategory:(NSString *)category andKey:(NSString *)key;
- (NSDictionary *)getPeopleAndDwellings;

- (BOOL)isWidgetAvailableForKey:(NSString *)key;
- (void)setWidgetForKey:(NSString *)key available:(BOOL)isAvailable;


@end
