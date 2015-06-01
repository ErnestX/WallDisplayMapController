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
        NSURL *dragURL = [[NSBundle mainBundle] URLForResource:@"IMG_0011" withExtension:@"m4v"];
        AVPlayer* dragPlayer = [AVPlayer playerWithURL:dragURL];
        AVPlayerLayer* dragTutorialLayer = [AVPlayerLayer playerLayerWithPlayer:dragPlayer];
//        dragTutorialLayer.position = self.center;
        dragTutorialLayer.frame = self.frame;
        [self.layer addSublayer:dragTutorialLayer];
        [dragPlayer play];
    }
    return self;
}

- (void) setController: (TutorialViewController*) tvc
{
    controller = tvc;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [controller exitTutorial];
}

@end
