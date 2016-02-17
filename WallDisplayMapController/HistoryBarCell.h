//
//  HistoryBarCell.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryBarCell : UICollectionViewCell

/*
 * notice for the metricsData, the position in the dictionary should range from 0 to 1
 */
- (void)initForReuseWithTimeStamp:(NSDate*) time tag:(NSString*)tag flagOrNot:(BOOL)flag metricNamePositionPairs:(NSDictionary*) metricData;

@end
