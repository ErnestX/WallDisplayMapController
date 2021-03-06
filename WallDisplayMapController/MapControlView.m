//
//  MapControl.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapControlView.h"
#import <ChameleonFramework/Chameleon.h>
#import "UIColor+Extend.h"

@implementation MapControlView {
    id <MapWallDisplayProtocal> target;
    
    UIPanGestureRecognizer* twoOrMoreFingerPanRecognizer;
    UIRotationGestureRecognizer* rotationRecognizer;
    
    UILabel* instructionLabel;
    UILabel* connectingLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
        self.backgroundColor = [UIColor colorFromHexString:@"#34495e"];
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
    // init gesture recognizers
    [self initGestureRecgonizers];
    
    // init UI
//    [self initAndShowInstructions];
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
            
                [self moveByLat:[self convertScreenTranslationToLat:newTranslation.x] Lon:[self convertScreenTranslationToLon:newTranslation.y]];
            
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
                
                if (fabs(touchNumOneLoc.y - touchNumTwoLoc.y) < 100.0) {
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
                [self moveByLat:[self convertScreenTranslationToLat:newTranslation.x] Lon:[self convertScreenTranslationToLon:newTranslation.y]];
                
            } else {
                [self increasePitchBy:[self convertScreenTranslationToPitch:newTranslation.y]];
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
            
            [self increaseFacingDirectionBy:[self convertScreenRotationToFacingDirection:newRotation]];
            
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
            
            [self increaseZoomFactorBy:[self convertScreenScaleToZoomFactor:newScale]];
            
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
    return YES;
}

- (float) convertScreenScaleToZoomFactor:(float) s
{
    return s;
}

- (float) convertScreenRotationToFacingDirection:(float) r
{
    return r*5; // hack: should modify sensitivity on table instead
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

- (void) initAndShowInstructions
{
    instructionLabel = [[UILabel alloc]init];
    instructionLabel.textColor = [UIColor lightGrayColor];
    instructionLabel.numberOfLines = 0;
    instructionLabel.text = @"drag to move\ntwo-finger rotate to turn\ntwo-finger vertical pan to pitch\npinch to zoom";
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    [instructionLabel sizeToFit];
    instructionLabel.center = CGPointMake(self.center.x, self.center.y - 150);
    [self addSubview:instructionLabel];
    [self sendSubviewToBack:instructionLabel];
    
    [self hideConnectingMessageAndShowInstructions];
}

- (void) hideConnectingMessageAndShowInstructions
{
    [CATransaction begin];
    if (connectingLabel != nil) {
        [connectingLabel removeFromSuperview];
    }

    instructionLabel.hidden = NO;
    [CATransaction commit];
}

- (void) hideConnectingMessage
{
    NSLog(@"hiding label");
    [CATransaction begin];
    if (connectingLabel != nil) {
        [connectingLabel removeFromSuperview];
    }
    [CATransaction commit];
}

- (void) showConnectingMessage
{
    NSLog(@"showing label");
    [CATransaction begin];
    if (connectingLabel != nil) {
        [connectingLabel removeFromSuperview];
    }
    
    if (instructionLabel != nil) {
        instructionLabel.hidden = YES;
    }

    connectingLabel = [[UILabel alloc]init];
    connectingLabel.textColor = [UIColor whiteColor];
    connectingLabel.text = @"connecting";
    connectingLabel.textAlignment = NSTextAlignmentCenter;
    [connectingLabel sizeToFit];
    connectingLabel.center = CGPointMake(self.center.x, self.center.y - 150);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center  = CGPointMake(connectingLabel.frame.size.width/2, connectingLabel.frame.size.height/2 + 40);
    [connectingLabel addSubview:spinner];
    [spinner startAnimating];
    
    [self addSubview:connectingLabel];
    [self sendSubviewToBack:connectingLabel];
    [CATransaction commit];
}

#pragma mark - Getters and Setters

- (void) increaseFacingDirectionBy:(float)angle
{
    [target increaseMapFacingDirectionBy:angle];
}

- (void) increasePitchBy:(float)angle
{
    [target increaseMapPitchBy:angle];
}

- (void) increaseZoomFactorBy:(float)factor
{
    [target increaseMapZoomBy:factor];
}

- (void) moveByLat:(double)la Lon:(double)lo
{
    [target increaseMapLatBy:la LonBy:lo];
}

@end
