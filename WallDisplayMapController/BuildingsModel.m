//
//  BuildingsModel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "BuildingsModel.h"

@implementation BuildingsModel

- (void)updateModelWithDictionary:(NSDictionary *)dict {
    [super updateModelWithDictionary:dict];
    
    self.people = [NSNumber numberWithInt:(int)[dict[@"people"] doubleValue]];
    self.dwellings = [NSNumber numberWithInt:[dict[@"dwellings"] intValue]];
    
    self.detachedPercent = [NSNumber numberWithInteger:([dict[@"detached_percent"] doubleValue] * 100.0)];
    self.attachedPercent = [NSNumber numberWithInteger:([dict[@"attached_percent"] doubleValue] * 100.0)];
    self.stackedPercent = [NSNumber numberWithInteger:([dict[@"stacked_percent"] doubleValue] * 100.0)];
    
    self.rezPercent = [NSNumber numberWithInteger:([dict[@"rez_percent"] doubleValue] * 100.0)];
    self.commPercent = [NSNumber numberWithInteger:([dict[@"comm_percent"] doubleValue] * 100.0)];
    self.civicPercent = [NSNumber numberWithInteger:([dict[@"civic_percent"] doubleValue] * 100.0)];
    self.indPercent = [NSNumber numberWithInteger:([dict[@"ind_percent"] doubleValue] * 100.0)];
    
    self.far = [NSNumber numberWithInt:[dict[@"far"] intValue]];
}

@end
