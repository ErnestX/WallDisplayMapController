//
//  HistoryBarCell.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryBarCell : UICollectionViewCell

/**
 @param thisMetricData the position in the dictionary should range from 0 to 1
 @param prevMetricData the position in the dictionary should range from 0 to 1
 @param nextMetricData the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary*)prevMetricData
            prevAbsHorizontalDistance:(CGFloat)pd
      nextMetricNamePositionPairs:(nonnull NSDictionary*)nextMetricData
            nextAbsHorizontalDistance:(CGFloat)nd;

/**
 @param thisMetricData the position in the dictionary should range from 0 to 1
 @param prevMetricData the position in the dictionary should range from 0 to 1
 @param nextMetricData the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary*)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd;

/**
 @param thisMetricData the position in the dictionary should range from 0 to 1
 @param prevMetricData the position in the dictionary should range from 0 to 1
 @param nextMetricData the position in the dictionary should range from 0 to 1 
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
      nextMetricNamePositionPairs:(nonnull NSDictionary*)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd;

/**
 @param thisMetricData the position in the dictionary should range from 0 to 1
 @param prevMetricData the position in the dictionary should range from 0 to 1
 @param nextMetricData the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData;

@end
