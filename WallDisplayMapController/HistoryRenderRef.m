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

+ (HistoryRenderRef *)instance {
    static HistoryRenderRef *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //TODO init self
    });
    
    return instance;
}

- (UIImage*)getIconForMetric:(MetricName)m {
    // stub
    return nil;
}

- (UIColor*)getColorForMetric:(MetricName)m {

//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    //TODO: hard-coded for debug purpose. Maybe randomly assign in the future
    UIColor* color;
    
    switch (m) {
        case people:
            color = [UIColor blueColor];
            break;
        case dwelling:
            color = [UIColor redColor];
            break;
        case active:
            color = [UIColor greenColor];
            break;
        case populationDensity:
            color = [UIColor orangeColor];
            break;
    }
    
    return color;
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
