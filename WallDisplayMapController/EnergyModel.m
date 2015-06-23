//
//  EnergyModel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "EnergyModel.h"

@implementation EnergyModel

- (void)updateModelWithDictionary:(NSDictionary *)dict {
    [super updateModelWithDictionary:dict];

    self.mobilityPercent = [NSNumber numberWithInt:(int)roundl([dict[@"mobility_percent"] doubleValue] * 100.0)];
    self.heatingAndHotWaterPercent = [NSNumber numberWithInt:(int)roundl([dict[@"heating_percent"] doubleValue] * 100.0)];
    self.lightsAndAppliancesPercent = [NSNumber numberWithInt:(int)roundl([dict[@"lights_percent"] doubleValue] * 100.0)];
    
    self.propaneIn = [NSNumber numberWithInt:(int)roundl([dict[@"propane_in"] doubleValue] * 100.0)];
    self.propaneOut = [NSNumber numberWithInt:(int)roundl([dict[@"propane_out"] doubleValue] * 100.0)];
    self.heatingoilIn = [NSNumber numberWithInt:(int)roundl([dict[@"heatingoil_in"] doubleValue] * 100.0)];
    self.heatingoilOut = [NSNumber numberWithInt:(int)roundl([dict[@"heatingoil_out"] doubleValue] * 100.0)];
    self.woodIn = [NSNumber numberWithInt:(int)roundl([dict[@"wood_in"] doubleValue] * 100.0)];
    self.woodOut = [NSNumber numberWithInt:(int)roundl([dict[@"wood_out"] doubleValue] * 100.0)];
    self.electricityIn = [NSNumber numberWithInt:(int)roundl([dict[@"electricity_in"] doubleValue] * 100.0)];
    self.electricityOut = [NSNumber numberWithInt:(int)roundl([dict[@"electricity_out"] doubleValue] * 100.0)];
    self.dieselIn = [NSNumber numberWithInt:(int)roundl([dict[@"diesel_in"] doubleValue] * 100.0)];
    self.dieselOut = [NSNumber numberWithInt:(int)roundl([dict[@"diesel_out"] doubleValue] * 100.0)];
    self.gasolineIn = [NSNumber numberWithInt:(int)roundl([dict[@"gasoline_in"] doubleValue] * 100.0)];
    self.gasolineOut = [NSNumber numberWithInt:(int)roundl([dict[@"gasoline_out"] doubleValue] * 100.0)];
    
}

@end
