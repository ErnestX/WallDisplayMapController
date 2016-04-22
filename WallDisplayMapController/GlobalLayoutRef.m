//
//  HistoryBarGlobalManager.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "GlobalLayoutRef.h"

@implementation GlobalLayoutRef {
    NSDictionary* metricsIconDic;
    NSMutableDictionary* metricsColorDic;
}

+ (GlobalLayoutRef *)instance {
    static GlobalLayoutRef *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //init self if needed in the future
    });
    
    return instance;
}

- (CGFloat)getHistoryBarOriginalHeight {
    return 160.0;
}

- (CGFloat)getHistoryBarExpandedHeight {
    return (160 - 40) * 3 + 40;
}

- (CGFloat)getCellDefaultWidth {
    return 65.0;
}

@end
