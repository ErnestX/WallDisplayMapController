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

+ (UIColor*)getColorForMetric:(MetricName)m {

//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    //TODO: hard-coded for debug purpose. Randomly assign in the future
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

+ (CGFloat)getHistoryBarOriginalHeight {
    return 160.0;
}

+ (CGFloat)getCellDefaultWidth {
    return 75.0;
}

@end
