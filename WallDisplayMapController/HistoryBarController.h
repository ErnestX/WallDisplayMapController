//
//  HistoryBarController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryBarView.h"
#import "HistoryContainerViewController.h"
#import "HistoryBarViewMyDelegate.h"

@interface HistoryBarController : UICollectionViewController <HistoryBarViewMyDelegate>

/*
 * custom initializer
 */
- (instancetype) initWithContainerController: (HistoryContainerViewController*) hcvc;

/*
 * set up and init the history bar (except for size), set it as the collection view, and return it.
 */
- (HistoryBarView*) getHistoryBar;

//- (float)getCellWidth;

@end
