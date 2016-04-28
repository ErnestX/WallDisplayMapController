//
//  MetricsConfigs.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsConfigs.h"

@interface MetricsConfigs ()
@property (readwrite) NSArray<NSNumber*>* metricsDisplayedInOrder; // stores the configuration that which metrics should be displayed and in what order
@end

@implementation MetricsConfigs

+ (MetricsConfigs*)instance {
    static MetricsConfigs* instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //init instance
        
        // stub
        instance.metricsDisplayedInOrder = [NSArray arrayWithObjects:[NSNumber numberWithInteger:density_modelActiveTripsPercent],
                                            [NSNumber numberWithInteger:building_people],
                                            [NSNumber numberWithInteger:building_detachedPercent],
                                            [NSNumber numberWithInteger:districtEnergy_energyHouseholdIncome], nil];
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

- (NSString*)getDisplayNameForMetric:(MetricName)m {
    NSString* name;
    
    switch (m) {
        case density_densityMetric: name = @"population density"; break;
//        case density_modelVKT:
//        case density_CEEIKVT:
        case density_modelActiveTripsPercent: name = @"active"; break;
        case density_modelTransitTripsPercent: name = @"transit"; break;
        case density_modelVehicleTripsPercent: name = @"vehicle"; break;
            
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
            
        case building_people: name = @"people"; break;
        case building_dwellings: name = @"dwellings"; break;
            
        case building_detachedPercent: name = @"detached"; break;
        case building_attachedPercent: name = @"rowhouse"; break;
        case building_stackedPercent: name = @"apartment"; break;
            
        case building_rezPercent: name = @"residential"; break;
        case building_commPercent: name = @"commercial"; break;
        case building_civicPercent: name = @"civic"; break;
        case building_indPercent: name = @"industrial"; break;
            
//        case building_far:
            
//        case  districtEnergy_far:
            
//        case districtEnergy_heatingPercent:
//        case districtEnergy_lightsPercent:
//        case districtEnergy_mobilityPercent:
        case districtEnergy_emissionsPerCapita: name = @"CO2 per capita"; break;
        case districtEnergy_energyHouseholdIncome: name = @"household annual energy cost"; break;
            
        default:
            name = @"untitled";
    }
    
    return name;
}

@end
