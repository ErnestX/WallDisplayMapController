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
    MapControlViewController* controller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init label
        UILabel *lblPlaceholder = [[UILabel alloc] initWithFrame:self.frame];
        lblPlaceholder.text = @"loading...";
        lblPlaceholder.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblPlaceholder];
        
        // init player layers
        [self initTutorialPlayerForResource:@"dragGestureMovie" withExtension:@"mp4" withFrame:CGRectMake(0, 0, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"rotateGestureMovie" withExtension:@"mp4" withFrame:CGRectMake(CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"tiltGestureMovie" withExtension:@"mp4" withFrame:CGRectMake(0, CGRectGetMidY(self.frame), CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self initTutorialPlayerForResource:@"zoomGestureMovie" withExtension:@"mp4" withFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        
        
    }
    return self;
}

- (void) setController: (MapControlViewController*) tvc
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
