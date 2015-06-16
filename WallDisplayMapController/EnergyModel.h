//
//  EnergyModel.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetModel.h"

@interface EnergyModel : WidgetModel

// Percent share of MJ in Services
@property NSNumber *mobilityPercent;
@property NSNumber *heatingAndHotWaterPercent;
@property NSNumber *lightsAndAppliancesPercent;

// Energy in
@property NSNumber *propaneIn;
@property NSNumber *heatingoilIn;
@property NSNumber *woodIn;
@property NSNumber *electricityIn;
@property NSNumber *dieselIn;
@property NSNumber *gasolineIn;

// Waste out
@property NSNumber *propaneOut;
@property NSNumber *heatingoilOut;
@property NSNumber *woodOut;
@property NSNumber *electricityOut;
@property NSNumber *dieselOut;
@property NSNumber *gasolineOut;

- (EnergyModel *)initWithDictionary:(NSDictionary *)dict;

@end
