//
//  HistoryViewController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryContainerViewController : UIViewController

- (NSDictionary*)getMetricsDataAtTimeIndex:(NSInteger)index;

- (NSInteger)getTotalNumberOfData;

/*
 Reads the image from disk. Very slow.
 */
- (UIImage*)getPreviewForIndex:(NSInteger)index;

- (void)showPreviewForIndex:(NSInteger)index;

@end
