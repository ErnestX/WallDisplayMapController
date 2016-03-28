//
//  GraphLineView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-28.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphLineView : UIView
@property CGFloat connectedToDataPointWithHeight;
@property CGFloat absHorizontalDistance;

- (id)initWithColor:(UIColor*)color connectedToDataPointWithHeight:(CGFloat)h absHorizontalDistance:(CGFloat)d anchorPointOnRight:(BOOL)onRight;

@end
