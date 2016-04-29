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
 @brief use this method to init if the cell is in the middle of two cells
 @param thisMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 @param prevMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 @param nextMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
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
 @brief use this method to init if the cell is the first cell from the right
 @param thisMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 @param prevMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary*)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd;

/**
 @brief use this method to init if the cell is the first cell from the left
 @param thisMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 @param nextMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
      nextMetricNamePositionPairs:(nonnull NSDictionary*)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd;

/**
 @brief use this method to init if the cell is the only cell in the graph
 @param thisMetricData only the metrics displayed are needed; the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData;

@end
