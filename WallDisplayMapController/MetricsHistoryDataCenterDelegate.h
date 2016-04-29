//
//  MetricsHistoryDataCenterDelegate.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-25.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#ifndef MetricsHistoryDataCenterDelegate_h
#define MetricsHistoryDataCenterDelegate_h

#import <Foundation/Foundation.h>

@protocol MetricsHistoryDataCenterDelegate <NSObject>

@required

- (void)newEntryAppendedInDataCenter;

/**
 this is for alerts
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

- (void)removeAllEntries;

@end

#endif /* MetricsHistoryDataCenterDelegate_h */
