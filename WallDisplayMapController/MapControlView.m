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
    __weak IBOutlet UILabel *latLonLabel;
    
    float facingDirection;
    float pitch;
    float zoomFactor;
    double lat;
    double lon;
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

- (void) setFacingDirection:(float)fd
{
    // TODO: update UI
    
    facingDirection = fd;
}

- (float) getFacingDirection
{
    return facingDirection;
}

- (void) setPitch:(float)p
{
    pitchLabel.text = [NSString stringWithFormat:@"Pitch %.02f°", p];
    pitch = p;
    
}

- (float) getPitch
{
    return pitch;
}

- (void) setZoomFactor:(float)zf
{
    zoomLabel.text = [NSString stringWithFormat:@"Zoom %.02fx", zf];
    zoomFactor = zf;
}

- (float) getZoomFactor
{
    return zoomFactor;
}

- (void) setLat:(double)la Lon:(double)lo
{
    latLonLabel.text = [NSString stringWithFormat:@"%.04f°, %.04f°", la, lo];
    lat = la;
    lon = lo;
}

- (double) getLat
{
    return lat;
}

- (double) getLon
{
    return lon;
}

@end
