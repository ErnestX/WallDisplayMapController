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
        instance.metricsDisplayedInOrder = [[NSUserDefaults standardUserDefaults] objectForKey:@"MetricsConfigsArr"];
        if (!instance.metricsDisplayedInOrder) {
            // can't find stored data
            instance.metricsDisplayedInOrder = [NSArray arrayWithObjects:[NSNumber numberWithInteger:building_people], nil];
        }
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
            
        case energy_mobilityPercent:
        case energy_heatingAndHotWaterPercent:
        case energy_lightsAndAppliancesPercent:

        case energy_propaneIn:
        case energy_heatingoilIn:
        case energy_woodIn:
        case energy_electricityIn:
        case energy_dieselIn:
        case energy_gasolineIn:
            color = [UIColor orangeColor];
            break;
            
        case energy_propaneOut:
        case energy_heatingoilOut:
        case energy_woodOut:
        case energy_electricityOut:
        case energy_dieselOut:
        case energy_gasolineOut:
            color = [UIColor brownColor];
            break;
            
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
        case building_far:
            color = [UIColor redColor];
            break;
            
        case  districtEnergy_far:
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
        case density_modelVKT: name = @"model VKT"; break;
        case density_CEEIKVT: name = @"CEEIKVT"; break;
        case density_modelActiveTripsPercent: name = @"active"; break;
        case density_modelTransitTripsPercent: name = @"transit"; break;
        case density_modelVehicleTripsPercent: name = @"vehicle"; break;
            
        case energy_mobilityPercent: name = @"mobility%(energy)"; break;
        case energy_heatingAndHotWaterPercent: name = @"heating & hot water %"; break;
        case energy_lightsAndAppliancesPercent: name = @"lights & appliances %"; break;

        case energy_propaneIn: name = @"propane in"; break;
        case energy_heatingoilIn: name = @"heating oil in"; break;
        case energy_woodIn: name = @"wood in"; break;
        case energy_electricityIn: name = @"electric in"; break;
        case energy_dieselIn: name = @"diesel in"; break;
        case energy_gasolineIn: name = @"gasoline in"; break;

        case energy_propaneOut: name = @"propane out"; break;
        case energy_heatingoilOut: name = @"heating out"; break;
        case energy_woodOut: name = @"wood out"; break;
        case energy_electricityOut: name = @"electricity out"; break;
        case energy_dieselOut: name = @"diesel out"; break;
        case energy_gasolineOut: name = @"gasoline out"; break;
            
        case building_people: name = @"people"; break;
        case building_dwellings: name = @"dwellings"; break;
            
        case building_detachedPercent: name = @"detached"; break;
        case building_attachedPercent: name = @"rowhouse"; break;
        case building_stackedPercent: name = @"apartment"; break;
            
        case building_rezPercent: name = @"residential"; break;
        case building_commPercent: name = @"commercial"; break;
        case building_civicPercent: name = @"civic"; break;
        case building_indPercent: name = @"industrial"; break;
            
        case building_far: name = @"floor/area(building)"; break;
            
        case  districtEnergy_far: name = @"floor/area(disEnergy)"; break;
            
        case districtEnergy_heatingPercent: name = @"heating%"; break;
        case districtEnergy_lightsPercent: name = @"lighting%"; break;
        case districtEnergy_mobilityPercent: name = @"mobility%"; break;
        case districtEnergy_emissionsPerCapita: name = @"CO2 per capita"; break;
        case districtEnergy_energyHouseholdIncome: name = @"household annual energy cost"; break;
            
        case notAMetric: name = @"not a metric"; break;
    }
    
    return name;
}

- (BOOL)setMetricsDisplayedInOrderWithArray:(NSArray<NSNumber*>*)arr {
    for (int i=0; i<arr.count; i++) {
        MetricName m = [[arr objectAtIndex:i] integerValue];
        if (m >= notAMetric) {
            return NO;
        }
    }
    self.metricsDisplayedInOrder = arr;
    
    // tell everyone that the config changed
    [[NSNotificationCenter defaultCenter]postNotificationName:@"metricsDisplayedInOrder modified" object:self];
    
    // save data to defaults
    [[NSUserDefaults standardUserDefaults] setObject:self.metricsDisplayedInOrder forKey:@"MetricsConfigsArr"];
    
    return YES;
}

@end
