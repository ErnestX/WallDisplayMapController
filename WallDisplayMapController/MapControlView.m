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
    UILabel *facingLabel;
    
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
    [self setFacingDirection:0];
    [self setPitch:2.5];
    [self setZoomFactor:1.0];
    [self setLat:50.0 Lon:50.0];
    
    // init gesture recognizers
    [self initGestureRecgonizers];
    
    // init UI
    [self initUI];
}

#pragma mark - Gesture Recognition

- (void) initGestureRecgonizers
{
    UIPanGestureRecognizer* oneFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneFingerPan:)];
    oneFingerPanRecognizer.maximumNumberOfTouches = 1;
    oneFingerPanRecognizer.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:oneFingerPanRecognizer];
}

- (void) handleOneFingerPan: (UIPanGestureRecognizer*) uigr
{
    static CGPoint prevTranslation;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [uigr translationInView:self];  // the new accumlated translation
            CGPoint newTranslation = CGPointMake(translation.x - prevTranslation.x, translation.y - prevTranslation.y); // the new net translation to report
            
            [self moveByLat:[self screenXTranslationToLat:newTranslation.x] Lon:[self screenYTranslationToLon:newTranslation.y]];
            
            prevTranslation = translation; // update accumulated translation
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            prevTranslation = CGPointZero; // don't forget to reset!
            break;
        }
        default:
            break;
    }
}

- (double) screenXTranslationToLat:(float) transX
{
    return (double)transX * 0.000001;
}

- (double) screenYTranslationToLon:(float) transY
{
    return (double)transY * 0.000001;
}

#pragma mark - User Interface

- (void) initUI
{
    
}

#pragma mark - Getters and Setters

- (void) increaseFacingDirectionBy:(float)angle
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

- (void) increasePitchBy:(float)angle
{
    
}

- (void) setPitch:(float)p
{
    pitch = p;
}

- (float) getPitch
{
    return pitch;
}

- (void) increaseZoomFactorBy:(float)factor
{
    
}

- (void) setZoomFactor:(float)zf
{
    zoomFactor = zf;
}

- (float) getZoomFactor
{
    return zoomFactor;
}

- (void) moveByLat:(double)la Lon:(double)lo
{
    double newLat = lat + la;
    double newLon = lon + lo;
    
    // check validity
    if (newLat < -90) {
        newLat = -90;
    } else if (newLat > 90){
        newLat = 90;
    }
    
    if (newLon < -180) {
        newLon = -180;
    } else if (newLon > 180) {
        newLon = 180;
    }
    
    // set new value on map
    BOOL flag = [target setMapLat:newLat Lon:newLon];
    
    // if success, update iVar
    if (flag) {
        lat = newLat;
        lon = newLon;
    }
}

- (void) setLat:(double)la Lon:(double)lo
{
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
