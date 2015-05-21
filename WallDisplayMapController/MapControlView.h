//
//  MapControl.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapWallDisplayProtocal.h"

@interface MapControlView : UIView

/*
 please refer to MapWallDisplayProtocal.h for documentations of the properties
 */

@property float facingDirection;

@property float pitch;

@property float zoomFactor;

@property double lat;
@property double lon;

/*
 @return NO if target already exist
 */
- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController;

@end
