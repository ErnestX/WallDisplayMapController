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

- (NSArray *)getWidgetElementsByCategory:(NSString *)category {
    return nil;
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
