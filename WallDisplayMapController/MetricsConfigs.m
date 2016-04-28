//
//  MetricsConfigs.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsConfigs.h"

@implementation MetricsConfigs

+ (MetricsConfigs*)instance {
    static MetricsConfigs* instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //init self if needed in the future
    });
    
    return instance;
}

- (UIImage*)getIconForMetric:(MetricName)m {
    // stub
    return nil;
}

- (UIColor*)getColorForMetric:(MetricName)m {
    UIColor* color;
    
    switch (m) {
        case density_densityMetric:
        case density_modelVKT:
        case density_CEEIKVT:
        case density_modelActiveTripsPercent:
        case density_modelTransitTripsPercent:
        case density_modelVehicleTripsPercent:
            color = [UIColor cyanColor];
            break;
            
//        case energy_mobilityPercent:
//        case energy_heatingAndHotWaterPercent:
//        case energy_lightsAndAppliancesPercent:
//
//        case energy_propaneIn:
//        case energy_heatingoilIn:
//        case energy_woodIn:
//        case energy_electricityIn:
//        case energy_dieselIn:
//        case energy_gasolineIn:
//            
//        case energy_propaneOut:
//        case energy_heatingoilOut:
//        case energy_woodOut:
//        case energy_electricityOut:
//        case energy_dieselOut:
//        case energy_gasolineOut:
            
        case building_people:
        case building_dwellings:
            color = [UIColor redColor];
            break;
            
        case building_detachedPercent:
        case building_attachedPercent:
        case building_stackedPercent:
            color = [UIColor greenColor];
            break;
            
        case building_rezPercent:
        case building_commPercent:
        case building_civicPercent:
        case building_indPercent:
            color = [UIColor redColor];
            break;
            
//        case building_far:
            
//        case  districtEnergy_far:
            
        case districtEnergy_heatingPercent:
        case districtEnergy_lightsPercent:
        case districtEnergy_mobilityPercent:
        case districtEnergy_emissionsPerCapita:
        case districtEnergy_energyHouseholdIncome:
            color = [UIColor purpleColor];
            break;

        default:
            color = [UIColor darkGrayColor];
    }
    
    return color;
}

@end
