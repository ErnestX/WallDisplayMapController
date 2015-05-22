//
//  MapControlProtocal.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapWallDisplayProtocal <NSObject>


/*
 @param facingDirection the direction currently facing from 0 to 2pi. 0 and 2pi means facing north
 @return YES if success, NO otherwise
 */
- (BOOL) setMapFacingDirection: (float) faceingDirection;

/*
 @param pitch current pitch from 0 to pi/2. 0 means viewing parallel to the ground, pi/2 means viewing directly from above perpendicular to the ground
 @return YES if success, NO otherwise
 */
- (BOOL) setMapPitch: (float) pitch;

/*
 @param zoomFactor current zoom factor. Greater than 0. 1 means the original size, smaller than 1 means zooming out (less detail), greater than 1 means zooming in (more detail)
 @return YES if success, NO otherwise
 */
- (BOOL) setMapZoom: (float) zoomFactor;

/*
 @param lat current latitude from -90 to 90
 @param lon current longtitude from -180 to 180
 @return YES if success, NO otherwise
 */
- (BOOL) setMapLat: (double) lat Lon:(double) lon;

@end
