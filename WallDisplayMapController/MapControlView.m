//
//  MapControl.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapControlView.h"

@implementation MapControlView {
    id <MapWallDisplayProtocal> target;
    __weak IBOutlet UILabel *zoomLabel;
    __weak IBOutlet UILabel *pitchLabel;
    __weak IBOutlet UILabel *labLonLabel;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController
{
    if (target == nil) {
        target = mapWallDisplayController;
        return YES;
    } else {
        return NO;
    }
}

- (void) customInit
{
    // init iVar
    
    // init UI
    [self initUI];
}

- (void) initUI
{
    
}

- (void) setFacingDirection:(float)facingDirection
{
    
}

- (float) getFacingDirection
{
    return 0;
}

- (void) setPitch:(float)pitch
{
    
}

- (float) getPitch
{
    return M_PI / 2;
}

- (void) setZoomFactor:(float)zoomFactor
{
    
}

- (float) getZoomFactor:(float)zoomFactor
{
    return 1.0;
}

- (void) setLat:(double)lat Lon:(double)lon
{
    
}

- (double) getLat
{
    return 0.0;
}

- (double) getLon
{
    return 0.0;
}

@end
