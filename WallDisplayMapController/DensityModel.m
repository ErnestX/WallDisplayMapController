//
//  DensityModel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DensityModel.h"

@implementation DensityModel

- (void)updateModelWithDictionary:(NSDictionary *)dict {
    [super updateModelWithDictionary:dict];
    
//    self.activeDensityThreshold = TODO
//    self.transitDensityThreshold = TODO
    self.densityMetric = [NSNumber numberWithInteger: [dict[@"density_metric"] integerValue]];
    
    self.modelVKT = [NSNumber numberWithInteger: [dict[@"model_vkt"] integerValue]];
    self.CEEIKVT = [NSNumber numberWithInteger: [dict[@"CEEI_vkt"] integerValue]];
    
    self.modelActiveTripsPercent = [NSNumber numberWithInteger:([dict[@"model_active_trips_percent"] doubleValue] * 100.0)];
    self.modelTransitTripsPercent = [NSNumber numberWithInteger:([dict[@"model_transit_trips_percent"] doubleValue] * 100.0)];
    self.modelVehicleTripsPercent = [NSNumber numberWithInteger:([dict[@"model_vehicle_trips_percent"] doubleValue] * 100.0)];
}

@end
