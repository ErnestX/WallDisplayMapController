//
//  DensityModel.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetModel.h"

@interface DensityModel : WidgetModel

@property NSNumber *activeDensityThreshold;
@property NSNumber *transitDensityThreshold;
@property NSNumber *densityMetric;
@property NSNumber *modelVKT;
@property NSNumber *CEEIKVT;
@property NSNumber *modelActiveTripsPercent;
@property NSNumber *modelTransitTripsPercent;
@property NSNumber *modelVehicleTripsPercent;

@end
