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
    float facingDirection;
    float pitch;
    float zoomFactor;
    double lat;
    double lon;
    
    MethodIntervalCaller* intervalCaller;
    
    UIPanGestureRecognizer* twoOrMoreFingerPanRecognizer;
    UIRotationGestureRecognizer* rotationRecognizer;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController AndInitializeWithFacingDirection: (float) fd Pitch: (float) p ZoomFactor:(float) zf Latitude: (double)la Longitude: (double)lo
{
    if (target == nil) {
        target = mapWallDisplayController;
        
        [self setFacingDirection:fd];
        [self setPitch:p];
        [self setZoomFactor:zf];
        [self setLat:la Lon:lo];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController WithCallBackIntervalInSec:(float) sec
{
    if (target == nil) {
        target = mapWallDisplayController;
        intervalCaller = [[MethodIntervalCaller alloc]initWithInterval:sec];
        return YES;
    } else {
        return NO;
    }
}

- (void) customInit
{
    // init iVars
    
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
    [self addGestureRecognizer:oneFingerPanRecognizer];
    
    twoOrMoreFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoOrMoreFingerPan:)];
    twoOrMoreFingerPanRecognizer.minimumNumberOfTouches = 2;
    twoOrMoreFingerPanRecognizer.delegate = self;
    [self addGestureRecognizer:twoOrMoreFingerPanRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationRecognizer.delegate = self;
    [self addGestureRecognizer:rotationRecognizer];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchRecognizer.delegate = self;
    [self addGestureRecognizer:pinchRecognizer];
}

- (void) handleOneFingerPan: (UIPanGestureRecognizer*) uigr
{
    static CGPoint prevTranslation;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            prevTranslation = CGPointZero; // don't forget to init!
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [uigr translationInView:self];  // the new accumlated translation
            CGPoint newTranslation = CGPointMake(translation.x - prevTranslation.x, translation.y - prevTranslation.y); // the new net translation to report
            
            __weak typeof(self) weakSelf = self;
            [intervalCaller addToCaller:^(void){
                [weakSelf moveByLat:[weakSelf convertScreenTranslationToLat:newTranslation.x] Lon:[weakSelf convertScreenTranslationToLon:newTranslation.y]];
            }];
            
            prevTranslation = translation; // update accumulated translation
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
}

- (void) handleTwoOrMoreFingerPan: (UIPanGestureRecognizer*) uigr
{
    static CGPoint prevTranslation;
    static BOOL isInPitchMode;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            prevTranslation = CGPointZero;
            isInPitchMode = NO;
            
            // determine if only two fingers
            if (uigr.numberOfTouches == 2) {
                // if YES, determine if the two fingers are horizontal
                CGPoint touchNumOneLoc = [uigr locationOfTouch:0 inView:self];
                CGPoint touchNumTwoLoc = [uigr locationOfTouch:1 inView:self];
                
                if (fabsf(touchNumOneLoc.y - touchNumTwoLoc.y) < 100.0) {
                    // if YES, pitch mode
                    isInPitchMode = YES;
                }
            }
            // else, move mode. Don't change isInPitchMode.
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [uigr translationInView:self];  // the new accumlated translation
            CGPoint newTranslation = CGPointMake(translation.x - prevTranslation.x, translation.y - prevTranslation.y); // the new net translation to report
            
            if (!isInPitchMode) {
                
                __weak typeof(self) weakSelf = self;
                [intervalCaller addToCaller:^(void){
                    [weakSelf moveByLat:[weakSelf convertScreenTranslationToLat:newTranslation.x] Lon:[weakSelf convertScreenTranslationToLon:newTranslation.y]];
                }];
                
            } else {
                
                __weak typeof(self) weakSelf = self;
                [intervalCaller addToCaller:^(void){
                    [weakSelf increasePitchBy:[weakSelf convertScreenTranslationToPitch:newTranslation.y]];
                }];
            }
            
            prevTranslation = translation; // update accumulated translation
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
}

- (void) handleRotation: (UIRotationGestureRecognizer*) uigr
{
    static CGFloat prevRotation;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            prevRotation = 0.0;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat rotation = [uigr rotation];
            CGFloat newRotation = rotation - prevRotation;
            
            __weak typeof(self) weakSelf = self;
            [intervalCaller addToCaller:^(void){
                [weakSelf increaseFacingDirectionBy:[weakSelf convertScreenRotationToFacingDirection:newRotation]];
            }];
            
            prevRotation = rotation;
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
}

- (void) handlePinch: (UIPinchGestureRecognizer*) uigr
{
    static CGFloat prevScale;
    
    switch (uigr.state) {
        case UIGestureRecognizerStateBegan: {
            prevScale = 1.0;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat scale = [uigr scale];
            CGFloat newScale = scale / prevScale;
            
            __weak typeof(self) weakSelf = self;
            [intervalCaller addToCaller:^(void){
                [weakSelf increaseZoomFactorBy:[weakSelf convertScreenScaleToZoomFactor:newScale]];
            }];
            
            prevScale = scale;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            break;
        }
        default:
            break;
    }
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //return YES;
    return NO;
}

- (float) convertScreenScaleToZoomFactor:(float) s
{
    return s;
}

- (float) convertScreenRotationToFacingDirection:(float) r
{
    return r;
}

- (float) convertScreenTranslationToPitch:(float) t
{
    // move from top of the screen to the button goes from M_PI/2 to 0
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    return t/screenHeight*(M_PI/2);
}

- (double) convertScreenTranslationToLat:(float) t
{
    return ((double)t) * 0.00001;
}

- (double) convertScreenTranslationToLon:(float) t
{
    return ((double)t) * 0.00001;
}

#pragma mark - User Interface

- (void) initUI
{
    
}

#pragma mark - Getters and Setters

- (void) increaseFacingDirectionBy:(float)angle
{
    [target increaseMapFacingDirectionBy:angle];
    
    CGFloat newFacingDirection = facingDirection + angle;
    
    // check validity
    if (newFacingDirection < 0) {
        newFacingDirection = M_PI * 2 + fmod(newFacingDirection, (M_PI * 2.0));
    } else if (newFacingDirection > M_PI * 2) {
        newFacingDirection = fmod(newFacingDirection, (M_PI * 2.0));
    }
    
    // set the value on map and update iVar if necessary
    if (facingDirection != newFacingDirection) {
        //BOOL flag = [target setMapFacingDirection:newFacingDirection];
        //if (flag) {
            facingDirection = newFacingDirection;
        //}
    }
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
    [target increaseMapPitchBy:angle];
    
    float newPitch = pitch + angle;
    
    // check validity
    if (newPitch < 0) {
        newPitch = 0;
    } else if (newPitch > M_PI/2) {
        newPitch = M_PI/2;
    }
    
    // set the value on map and update iVar if necessary
    if (pitch != newPitch) {
        //BOOL flag = [target setMapPitch:newPitch];
        //if (flag) {
            pitch = newPitch;
        //}
    }
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
    [target increaseMapZoomBy:factor];
    
    float newZoomFactor = zoomFactor * factor;
    
    // check validity
    if (newZoomFactor < 0) {
        newZoomFactor = 0;
    }
    
    // set the value on map and update iVar if necessary
    if (zoomFactor != newZoomFactor) {
        //BOOL flag = [target setMapZoom:newZoomFactor];
        //if (flag) {
            zoomFactor = newZoomFactor;
        //}
    }
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
    [target increaseMapLatBy:la LonBy:lo];
    
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
    
    // set new value on map and update iVars if necessary
    if (lat != newLat || lon != newLon) {
        //BOOL flag = [target setMapLat:newLat Lon:newLon];
        //if (flag) {
            lat = newLat;
            lon = newLon;
        //}
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
