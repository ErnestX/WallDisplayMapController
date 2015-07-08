//
//  GlobalManager.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-07.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "GlobalManager.h"
#import "RabbitMQManager.h"
#import "XMLDictionary.h"
#import "DensityModel.h"
#import "EnergyModel.h"
#import "BuildingsModel.h"
#import "DistrictEnergyModel.h"

@interface GlobalManager()

@property (nonatomic, strong) DensityModel *modelDensity;
@property (nonatomic, strong) BuildingsModel *modelBuildings;
@property (nonatomic, strong) EnergyModel *modelEnergy;
@property (nonatomic, strong) DistrictEnergyModel *modelDistrictEnergy;


@end

@implementation GlobalManager

+ (GlobalManager *)sharedInstance {
    static GlobalManager *instance;
    static dispatch_once_t done;
    dispatch_once(&done,^{
        instance = [[GlobalManager alloc] init];
    });
    return instance;
}

- (NSDictionary *)getPeopleAndDwellings {
    return @{@"people" : self.modelBuildings? self.modelBuildings.people : @0,
             @"dwellings" : self.modelBuildings? self.modelBuildings.dwellings : @0};

}

- (NSArray *)getWidgetElementsByCategory:(NSString *)category {
    if ([category isEqualToString:@"Mobility"] && self.modelDensity) {
        
        NSDictionary *mob1 = @{@"ch_type" : CHART_TYPE_BAR,
                               @"ch_data" : @{@"model_vkt" : self.modelDensity.modelVKT, @"CEEI_vkt" : self.modelDensity.CEEIKVT}};
        NSDictionary *mob2 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : @{@"active_pct" : self.modelDensity.modelActiveTripsPercent}};
        NSDictionary *mob3 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : @{@"transit_pct" : self.modelDensity.modelTransitTripsPercent}};
        NSDictionary *mob4 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : @{@"vehicle_pct" : self.modelDensity.modelVehicleTripsPercent}};
        
        return @[mob1, mob2, mob3, mob4];
        
    } else if ([category isEqualToString:@"Land Use"] && self.modelBuildings) {
        
        // a;sdfkja
        NSDictionary *lu1 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : @{@"single" : self.modelBuildings.detachedPercent}};
        NSDictionary *lu2 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : @{@"rowhouse" : self.modelBuildings.attachedPercent}};
        NSDictionary *lu3 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : @{@"apart" : self.modelBuildings.stackedPercent}};
        return @[lu1, lu2, lu3];
        
    } else if ([category isEqualToString:@"Energy & Carbon"]) {
        
        return nil;
        
    } else if ([category isEqualToString:@"Economy"]) {
        
        return nil;
        
    } else if ([category isEqualToString:@"Equity"]) {
        
        return nil;
        
    } else if ([category isEqualToString:@"Well Being"]){
        
        return nil;

    } else return nil;
    
}

- (void)beginConsumingMetricsData {
    DEFINE_WEAK_SELF
    
    RabbitMQManager *rmqManager = [RabbitMQManager sharedInstance];
    [rmqManager beginConsumingWidgetsWithCallbackBlock:^(NSString *msg) {
        // parse xml into a dictionary
        NSDictionary *dictTemp = [NSDictionary dictionaryWithXMLString:[msg stringByReplacingOccurrencesOfString:@"d2p1:" withString:@""]];
        NSArray *attributes = dictTemp[@"ResultDict"][@"KeyValueOfstringstring"];
        
        NSMutableDictionary *dictModel = [NSMutableDictionary dictionary];
        [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *temp = obj;
            dictModel[temp[@"Key"]] = temp[@"Value"];
        }];
        
        
        NSString *urlBase = dictModel[@"_url_base"];
        // Map the dictModel to corresponding model objects
        if ([urlBase containsString:WIDGET_DENSITY]){
            if (!_modelDensity)
                _modelDensity = [[DensityModel alloc] init];
            [_modelDensity updateModelWithDictionary:dictModel];
            
            
            
        } else if ([urlBase containsString:WIDGET_BUILDINGS]) {
            if (!_modelBuildings)
                _modelBuildings = [[BuildingsModel alloc] init];
            [_modelBuildings updateModelWithDictionary:dictModel];
            
            
            
        } else if ([urlBase containsString:WIDGET_DISTRICTENERGY]) {
            if (!_modelDistrictEnergy)
                _modelDistrictEnergy = [[DistrictEnergyModel alloc] init];
            [_modelDistrictEnergy updateModelWithDictionary:dictModel];
            
            
            
        } else if ([urlBase containsString:WIDGET_ENERGY]) {
            if (!_modelEnergy)
                _modelEnergy = [[EnergyModel alloc] init];
            [_modelEnergy updateModelWithDictionary:dictModel];
            

            
        } else {
            // model received is unrecognized/undefined
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.targetVC) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Touch+"
                                         message:@"Sorry, the widget model data received is unrecognized."
                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];

                    [alert addAction:cancelAction];
                    [weakSelf.targetVC presentViewController:alert animated:YES completion:nil];
                }

            });
            
        }
        
        NSLog(@"message: %@", msg);
    }];
}

@end
