//
//  TutorialView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-31.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "TutorialView.h"
#import <AVFoundation/AVFoundation.h>

@implementation TutorialView {
    TutorialViewController* controller;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // init player layers
        [self initTutorialPlayerForResource:@"IMG_0011" withExtension:@"m4v" withFrame:CGRectMake(0, 0, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"IMG_0012" withExtension:@"m4v" withFrame:CGRectMake(CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"IMG_0012" withExtension:@"m4v" withFrame:CGRectMake(0, CGRectGetMidY(self.frame), CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"IMG_0011" withExtension:@"m4v" withFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    }
    return self;
}

- (void) setController: (TutorialViewController*) tvc
{
    controller = tvc;
}

- (void)initTutorialPlayerForResource: (NSString*)r withExtension:(NSString*)e withFrame:(CGRect)f
{
    NSURL *dragURL = [[NSBundle mainBundle] URLForResource:r withExtension:e];
    AVPlayer* dragPlayer = [AVPlayer playerWithURL:dragURL];
    AVPlayerLayer* dragTutorialLayer = [AVPlayerLayer playerLayerWithPlayer:dragPlayer];
    dragTutorialLayer.frame = f;
    dragTutorialLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:dragTutorialLayer];
    
    dragPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[dragPlayer currentItem]];
    
    dragPlayer.muted = YES;
    [dragPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification*)n
{
    AVPlayerItem *p = [n object];
    [p seekToTime:kCMTimeZero];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [controller exitTutorial];
}

@end
