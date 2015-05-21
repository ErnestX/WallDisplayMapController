//
//  MapControl.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapControl : UIView

/*
 the direction currently facing from 0 to 2pi
 0 and 2pi means north
 */
@property float facingDirection;

/*
 current pitch. Greater or equal to 0 and smaller or equal to 2/pi
 0 means viewing parallel to the ground, 2/pi means viewing directly from above
 */
@property float pitch;

/*
 current zoom factor. Greater than 0
 1 means the original size
 smaller than 1 means zooming out (less detail)
 greater than 1 means zooming in (more detail)
 */
@property float zoom;

/*
 current latitude from -90 to 90
 */
@property double lat;

/*
 current longtitude from -180 to 180
 */
@property double lon;

@end
