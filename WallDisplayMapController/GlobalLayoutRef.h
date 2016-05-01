//
//  HistoryBarGlobalManager.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalLayoutRef : NSObject

/**
 this is a singleton class
 */
+ (GlobalLayoutRef *)instance;

- (CGFloat)getHistoryBarOriginalHeight;
- (CGFloat)getHistoryBarExpandedHeight;
- (CGFloat)getCellDefaultWidth;
- (CGFloat)getTagViewHeight;
- (CGFloat)getTimeStampFontSize;

- (NSString*)getNotificationMessageForExpandingHistoryBar;
- (NSString*)getNotificationMessageForContractingHistoryBar;

@end
