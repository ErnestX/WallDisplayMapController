//
//  MetricView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetricView : UIView

/**
  @brief init with both left and right lines. Can be called multiple times to rewirte previous settings
  @param m the metric name must match the one in the dictionary
  @param p position must range from 0 to 1
  @warning does not call designated initializer
 */
- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd;

/**
  @brief init without the right line. Can be called multiple times to rewirte previous settings
  @param m the metric name must match the one in the dictionary
  @param p position must range from 0 to 1
  @warning does not call designated initializer
 */
- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c prevDataPointHeight:(CGFloat)ph absHorizontalDistance:(CGFloat)pd;

/**
 @brief init without the left line. Can be called multiple times to rewirte previous settings
 @param m the metric name must match the one in the dictionary
 @param p position must range from 0 to 1
 @warning does not call designated initializer
 */
- (id)initWithMetricName:(NSString *)m position:(float)p color:(UIColor *)c nextDataPointHeight:(CGFloat)nh absHorizontalDistance:(CGFloat)nd;

/**
 @brief init with neither of the left or right line. Can be called multiple times to rewirte previous settings
 @param m the metric name must match the one in the dictionary
 @param p position must range from 0 to 1
 @warning does not call designated initializer
 */
- (id)initWithMetricName:(NSString*)m position:(CGFloat)p color:(UIColor*)c;

- (void)hideLeftLine;

- (void)hideRightLine;

- (void)showLeftLineWithPrevDataPointHeight:(CGFloat)h absHorizontalDistance:(CGFloat)d;

- (void)showRightLineWithNextDataPointHeight:(CGFloat)h absHorizontalDistance:(CGFloat)d;

// use notification center to send the message to show icons system wise in order to avoid complex passing mechanism
- (void) showIcons;

@end
