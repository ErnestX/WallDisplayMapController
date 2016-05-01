//
//  LegendViewController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricPickerDelegate.h"

@class HistoryContainerViewController;

@interface LegendViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MetricPickerDelegate>

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc;

@end
