//
//  HistoryBarGlobalManager.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryRenderRef.h"

@implementation HistoryRenderRef {
    NSDictionary* metricsIconDic;
    NSMutableDictionary* metricsColorDic;
}

+ (CGFloat)getHistoryBarOriginalHeight {
    return 160.0;
}

+ (CGFloat)getCellDefaultWidth {
    return 75.0;
}

@end
