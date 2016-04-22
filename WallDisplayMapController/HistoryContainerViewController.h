//
//  HistoryViewController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryContainerViewController : UIViewController

- (NSInteger)getTotalNumberOfData;

- (NSDictionary*)getMetricsValueAtTimeIndex:(NSInteger)index;
- (NSString*)getPreviewImagePathForIndex:(NSInteger)index;

- (void)showPreviewForIndex:(NSInteger)index;

@end
