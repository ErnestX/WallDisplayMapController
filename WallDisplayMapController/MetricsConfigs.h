//
//  MetricsConfigs.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MetricName) {
    
    /* =========== density =========== */
    
    // People per hectare and mode thresholds
//    density_activeDensityThreshold,
//    density_transitDensityThreshold,
    density_densityMetric,
    
    // Kilometers per person in a year
    density_modelVKT,
    density_CEEIKVT,
    
    // Percent of annual trips by travel modes
    density_modelActiveTripsPercent,
    density_modelTransitTripsPercent,
    density_modelVehicleTripsPercent,
    
    /* ============ energy ============ */
    
    // Percent share of MJ in Services
    energy_mobilityPercent,
    energy_heatingAndHotWaterPercent,
    energy_lightsAndAppliancesPercent,
    
    // Energy in
    energy_propaneIn,
    energy_heatingoilIn,
    energy_woodIn,
    energy_electricityIn,
    energy_dieselIn,
    energy_gasolineIn,
    
    // Waste out
    energy_propaneOut,
    energy_heatingoilOut,
    energy_woodOut,
    energy_electricityOut,
    energy_dieselOut,
    energy_gasolineOut,
    
    /* =========== building =========== */
    
    building_people,
    building_dwellings,
    
    // Unit types
    building_detachedPercent,    // Single Detached
    building_attachedPercent,    // Rowhouse
    building_stackedPercent,     // Apartment
    
    // Percent of floor area
    building_rezPercent,
    building_commPercent,
    building_civicPercent,
    building_indPercent,
    
    building_far,    // floor-area ratio
    
    /* ======= district energy ======= */
    
//    districtEnergy_districtThresholdFAR,
    districtEnergy_far,
    
    // Household income percent
    districtEnergy_heatingPercent,
    districtEnergy_lightsPercent,
    districtEnergy_mobilityPercent,
    
    districtEnergy_emissionsPerCapita,
    districtEnergy_energyHouseholdIncome
};

@interface MetricsConfigs : NSObject

/**
 this is a singleton class
 */
+ (MetricsConfigs*)instance;

- (UIImage*)getIconForMetric:(MetricName)m;
- (UIColor*)getColorForMetric:(MetricName)m;
- (NSString*)getDisplayNameForMetric:(MetricName)m;

@end
