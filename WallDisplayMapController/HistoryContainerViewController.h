//
//  HistoryViewController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricsHistoryDataCenterDelegate.h"

@interface HistoryContainerViewController : UIViewController <MetricsHistoryDataCenterDelegate>

- (NSInteger)getTotalNumberOfData;

/*
 contains only the metrics that is displayed according to MetricsConfigs
 the values in the dictionary all range from 0 to 1
 */
- (NSDictionary*)getMetricsDisplayPositionsAtTimeIndex:(NSInteger)index;
- (NSString*)getPreviewImagePathForIndex:(NSInteger)index;

- (void)showPreviewForIndex:(NSInteger)index;

@end
