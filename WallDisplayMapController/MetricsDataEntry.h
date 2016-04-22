//
//  MetricDataEntry.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricsDataEntry : NSObject

@property NSDictionary<NSNumber*, NSNumber*>* metricsValues;
@property UIImage* previewImage;

@end
