//
//  DistrictEnergyModel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DistrictEnergyModel.h"

@implementation DistrictEnergyModel

- (void)updateModelWithDictionary:(NSDictionary *)dict {
    if (dict[@"district_threshold_FAR"]) {
        self.districtThresholdFAR = [NSNumber numberWithDouble:[dict[@"district_threshold_FAR"] doubleValue]];
    } else {
        self.districtThresholdFAR = @1.1;
    }
    self.far = [NSNumber numberWithFloat:roundToTwo([dict[@"FAR"] floatValue])];
    
    self.heatingPercent = [NSNumber numberWithInt:(int)roundl([dict[@"heating_percent"] doubleValue] * 100.0)];
    self.lightsPercent = [NSNumber numberWithInt:(int)roundl([dict[@"lights_percent"] doubleValue] * 100.0)];
    self.mobilityPercent = [NSNumber numberWithInt:(int)roundl([dict[@"mobility_percent"] doubleValue] * 100.0)];
    
    self.energyHouseholdIncome = [NSNumber numberWithInt:(int)roundl([dict[@"energy_household_income"] doubleValue])];
    self.emissionsPerCapita = [NSNumber numberWithFloat:roundToTwo([dict[@"emissions_capita"] floatValue])];
    
    [super updateModelWithDictionary:dict];
}

float roundToTwo(float num)
{
    return round(10 * num) / 10;
}

@end
