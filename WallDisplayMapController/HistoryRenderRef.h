//
//  HistoryBarGlobalManager.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetricNameTypeDef.h"

@interface HistoryRenderRef : NSObject

+ (UIImage*)getIconForMetric:(MetricName)m;
+ (UIColor*)getColorForMetric:(MetricName)m;
+ (CGFloat)getHistoryBarOriginalHeight;
+ (CGFloat)getCellDefaultWidth;

@end
