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
 only returns data for the metrics that's displayed according to MetricsConfigs
 the values in the dictionary all range from 0 to 1\
 */
- (nonnull NSDictionary*)getDataPointPosForDisplayedMetricsAtIndex:(NSInteger)index;
- (nonnull NSDate*)getTimeStampForIndex:(NSInteger)index;
- (nonnull NSString*)getTagForIndex:(NSInteger)index;
- (BOOL)getFlagForIndex:(NSInteger)index;

- (nonnull NSString*)getPreviewImagePathForIndex:(NSInteger)index;

- (void)showPreviewForIndex:(NSInteger)index;

@end
