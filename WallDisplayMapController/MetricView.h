//
//  MetricView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetricView : UIView

/*
 * the metric name must match the one in the dictionary
 */
- (id)initWithMetricName:(NSString*)m position:(float)p color:(UIColor*)c;

- (void)showLeftLine:(BOOL)b;

- (void)showRightLine:(BOOL)b;

- (void)setLeftLineAngle:(CGFloat)a;

- (void)setrightLineAngle:(CGFloat)a;

- (void) showIcons;

@end
