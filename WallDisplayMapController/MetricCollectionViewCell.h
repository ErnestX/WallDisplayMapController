//
//  MetricCollectionViewCell.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-03.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetricCollectionViewCell : UICollectionViewCell

- (void)updateWithData:(NSDictionary *)dict;
- (void)startAnimatingWithTarget:(id)target;
- (void)stopAnimating;
- (void)changeBgColor:(UIColor *)color;

@end
