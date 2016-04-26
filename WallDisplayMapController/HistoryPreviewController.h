//
//  HistoryPreviewController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryContainerViewController;

/*
 How the cache works: 
 
 An NSMutableArray named imagesCache, which stores an UIImage at each entry;
 The size of the array is not fixed, but always no larger than the total number of save entries in the data centre;
 The index of the array is the index of the save entry;
 Each entry of the array could be NSNull, indicating that the entry is not in the cahce;
 When the cache is too large for the memory, it will be cleared;
 When an entry is cleared, it is set to NSNull instead of being removed from the array.
 */
@interface HistoryPreviewController : UIViewController

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc;

- (void)showPreviewAtIndex:(NSInteger)index;

- (void)refreshCacheAtIndex:(NSInteger)index;

@end
