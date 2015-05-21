//
//  MapWallDisplayController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapWallDisplayController.h"

@implementation MapWallDisplayController

- (BOOL) setMapFacingDirection:(float)faceingDirection
{
    NSLog(@"setMapFacingDireciton %f", faceingDirection);
    return NO; //stub
}

- (BOOL) setMapPitch:(float)pitch
{
    NSLog(@"setMapPitch %f", pitch);
    return NO; //stub
}

- (BOOL) setMapZoom:(float)zoomFactor
{
    NSLog(@"setMapZoom %f", zoomFactor);
    return NO; //stub
}

- (BOOL) setMapLat:(double)lat Lon:(double)lon
{
    NSLog(@"setMapLat %f, Lon %f", lat, lon);
    return NO; //stub
}

@end
