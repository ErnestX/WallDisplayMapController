//
//  UIColor+Extend.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
