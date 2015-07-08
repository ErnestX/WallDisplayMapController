//
//  GlobalManager.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-07.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalManager : NSObject

@property UIViewController *targetVC;

+ (GlobalManager *)sharedInstance;
- (void)beginConsumingMetricsData;
- (NSArray *)getWidgetElementsByCategory:(NSString *)category;

@end
