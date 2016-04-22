//
//  MetricsConfigs.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-22.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "MetricsConfigs.h"

@implementation MetricsConfigs

+ (MetricsConfigs*)instance {
    static MetricsConfigs* instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ // ensures that the block we pass it is executed once for the lifetime of the application
        instance = [[self alloc] init];
        //init self if needed in the future
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

@end
