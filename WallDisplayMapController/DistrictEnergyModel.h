//
//  DistrictEnergyModel.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "WidgetModel.h"

@interface DistrictEnergyModel : WidgetModel

@property NSNumber *districtThresholdFAR;
@property NSNumber *far;

// Household income percent
@property NSNumber *heatingPercent;
@property NSNumber *lightsPercent;
@property NSNumber *mobilityPercent;

@property NSNumber *energyHouseholdIncome;

- (DistrictEnergyModel *)initWithDictionary:(NSDictionary *)dict;

@end
