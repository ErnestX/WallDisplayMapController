//
//  BuildingsModel.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetModel.h"

@interface BuildingsModel : WidgetModel

@property NSNumber *people;
@property NSNumber *dwellings;

// Unit types
@property NSNumber *detachedPercent;    // Single Detached
@property NSNumber *attachedPercent;    // Rowhouse
@property NSNumber *stackedPercent;     // Apartment

// Percent of floor area
@property NSNumber *rezPercent;
@property NSNumber *commPercent;
@property NSNumber *civicPercent;
@property NSNumber *indPercent;

@property NSNumber *far;    // floor-area ratio

- (BuildingsModel *)initWithDictionary:(NSDictionary *)dict;


@end
