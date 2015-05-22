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

- (void) initGestureRecgonizers
{
    UIPanGestureRecognizer* oneFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneFingerPan:)];
    oneFingerPanRecognizer.maximumNumberOfTouches = 1;
    oneFingerPanRecognizer.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:oneFingerPanRecognizer];
}

- (void) initUI
{
//    facingLabel = [[UILabel alloc]initWithFrame: CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 43, 50)];
//    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    [facingLabel.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
//    facingLabel.layer.position = center;
//    facingLabel.textColor = [UIColor whiteColor];
//    facingLabel.backgroundColor = [UIColor blueColor];
//    facingLabel.text = @"00.0°";
//    
//    UILabel* northLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
//    //northLabel.backgroundColor = [UIColor redColor];
//    northLabel.textColor = [UIColor whiteColor];
//    northLabel.text = @"N";
//    [facingLabel addSubview:northLabel];
//    
//    [self addSubview:facingLabel];
}

- (void) handleOneFingerPan: (UIPanGestureRecognizer*) uigr
{
    static CGPoint prevTranslation;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [uigr translationInView:self];
            CGPoint newTranslation = CGPointMake(translation.x - prevTranslation.x, translation.y - prevTranslation.y);
            //float newDistance = sqrtf(powf(newTranslation.x, 2) + powf(newTranslation.y, 2));
            //float angle = [self calcRotationAngleFromDistance:newDistance];
            
            //[dotBallDrawer rotateBallNotAnimatedBySurfaceDistance:newDistance AxisX:(newTranslation.y * -1) AxisY:newTranslation.x]; // swapped x and y and negate one of them to make it perpendicular to the translation
            
            prevTranslation = translation;
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            prevTranslation = CGPointZero; // don't forget to reset!
            
            // decay animation
//            CGPoint v = [uigr velocityInView:self];
//            v = CGPointMake(v.x / 30, v.y / 30); // divide by constant in order to translate distance per time unit to distance per frame.
            // play momentum animation
//            while (true) {
//
//            }
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark - getting and setting properties

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
