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

@property (nonatomic, strong) NSMutableDictionary *dictWidgetStatus;

@end

@implementation GlobalManager

+ (GlobalManager *)sharedInstance {
    static GlobalManager *instance;
    static dispatch_once_t done;
    dispatch_once(&done,^{
        instance = [[GlobalManager alloc] init];
        instance.dictWidgetStatus = [NSMutableDictionary dictionaryWithCapacity:25.0];
    });
    return instance;
}

- (NSDictionary *)getPeopleAndDwellings {
    return @{@"people" : self.modelBuildings? self.modelBuildings.people : @0,
             @"dwellings" : self.modelBuildings? self.modelBuildings.dwellings : @0};

}

- (NSArray *)getWidgetElementsByCategory:(NSString *)category {
    if ([category isEqualToString:@"Mobility"] && self.modelDensity) {
        
        NSMutableDictionary *mob0 = [NSMutableDictionary dictionaryWithDictionary: @{@"ch_type" : CHART_TYPE_BAR,
                                                                                     @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"model_vkt" : self.modelDensity.modelVKT,                        @"CEEI_vkt" : self.modelDensity.CEEIKVT}]}];
        
        NSMutableDictionary *mob1 = [NSMutableDictionary dictionaryWithDictionary:@{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"active_pct" : self.modelDensity.modelActiveTripsPercent}]}];
        
        NSMutableDictionary *mob2 = [NSMutableDictionary dictionaryWithDictionary:@{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"transit_pct" : self.modelDensity.modelTransitTripsPercent}]}];
        
        NSMutableDictionary *mob3 = [NSMutableDictionary dictionaryWithDictionary:@{@"ch_type" : CHART_TYPE_CIRCLE,
                               @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"vehicle_pct" : self.modelDensity.modelVehicleTripsPercent}]}];
        
        DEFINE_WEAK_SELF
        NSMutableArray *temp = [NSMutableArray arrayWithArray:@[mob0, mob1, mob2, mob3]];
        [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *mobi = (NSMutableDictionary *)obj;
            NSString *key = [NSString stringWithFormat:@"mob%d", (int)idx];
            mobi[@"ch_data"][@"ch_key"] = key;
            if (!weakSelf.dictWidgetStatus[key]) {
                weakSelf.dictWidgetStatus[key] = [NSNumber numberWithBool:YES];
            }
        }];
        
        return temp;
        
    } else if ([category isEqualToString:@"Land Use"] && self.modelBuildings) {
        
        NSDictionary *lu0 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"single" : self.modelBuildings.detachedPercent}]};
        NSDictionary *lu1 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"rowhouse" : self.modelBuildings.attachedPercent}]};
        NSDictionary *lu2 = @{@"ch_type" : CHART_TYPE_CIRCLE,
                              @"ch_data" : [NSMutableDictionary dictionaryWithDictionary: @{@"apart" : self.modelBuildings.stackedPercent}]};
        
        DEFINE_WEAK_SELF
        NSMutableArray *temp = [NSMutableArray arrayWithArray:@[lu0, lu1, lu2]];
        [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *lui = (NSMutableDictionary *)obj;
            NSString *key = [NSString stringWithFormat:@"lu%d", (int)idx];
            lui[@"ch_data"][@"ch_key"] = key;
            if (!weakSelf.dictWidgetStatus[key]) {
                weakSelf.dictWidgetStatus[key] = [NSNumber numberWithBool:YES];
            }
        }];
        
        return temp;
        
    } else if ([category isEqualToString:@"Energy & Carbon"]) {
        
        return @[];
        
    } else if ([category isEqualToString:@"Economy"]) {
        
        return @[];
        
    } else if ([category isEqualToString:@"Equity"]) {
        
        return @[];
        
    } else if ([category isEqualToString:@"Well Being"]){
        
        return @[];

    } else return @[];
    
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
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:WIDGET_DATA_UPDATED object:nil]];
        NSLog(@"message: %@", msg);
    }];
}

- (BOOL)isWidgetAvailableForKey:(NSString *)key {
    NSNumber *isAvailable = self.dictWidgetStatus[key];
    return [isAvailable boolValue];
}

- (void)setWidgetForKey:(NSString *)key available:(BOOL)isAvailable {
    self.dictWidgetStatus[key] = [NSNumber numberWithBool:isAvailable];
}

@end