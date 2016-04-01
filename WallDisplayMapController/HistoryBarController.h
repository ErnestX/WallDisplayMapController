//
//  HistoryBarController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryBarViewMyDelegate.h"
@class HistoryContainerViewController;

@interface HistoryBarController : UICollectionViewController <HistoryBarViewMyDelegate>

/**
  calls designated initializer
 */
- (instancetype) initWithContainerController: (HistoryContainerViewController*) hcvc;

@end
