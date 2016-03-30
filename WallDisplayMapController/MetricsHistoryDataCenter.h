//
//  MetricsDictionary.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetricNameTypeDef.h"

@interface MetricsHistoryDataCenter : NSObject

- (NSDictionary*)getMetricsDataAtTimeIndex:(NSInteger)index;

@end
