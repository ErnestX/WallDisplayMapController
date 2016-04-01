//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"
#import "HistoryRenderRef.h"
#import "HistoryBarView.h"
#import "HistoryPreviewView.h"

@implementation HistoryContainerView
{
    HistoryBarView* historyBarView;
    HistoryPreviewView* historyPreviewView;
    UIView* pointerView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIButton* testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"test" forState:UIControlStateNormal];
    testButton.frame = CGRectMake(500, 500, 50, 50);
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [testButton addTarget:self action:@selector(testButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [testButton addTarget:self action:@selector(testButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:testButton];
    
    return self;
}

- (void)testButtonPressed:(id)sender {
    [self expandGraph];
}

- (void)testButtonReleased:(id)sender {
    [self collapseGraph];
}

- (void)expandGraph {
    [UIView animateWithDuration:0.35 animations:^(void){
        [historyBarView setHeight:450];
        pointerView.center = CGPointMake(historyBarView.frame.size.width / 2, 450);
    }];
}

- (void)collapseGraph {
    [UIView animateWithDuration:0.35 animations:^(void){
        [historyBarView setHeight:[[HistoryRenderRef instance]getHistoryBarOriginalHeight]];
        pointerView.center = CGPointMake(historyBarView.frame.size.width / 2, [[HistoryRenderRef instance]getHistoryBarOriginalHeight]);
    }];
}

- (void) setUpHistoryBar:(nonnull HistoryBarView *) hbv {
    historyBarView = hbv;
    [self addSubview:historyBarView];
    
    // set history bar height without animation
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [historyBarView setHeight:[[HistoryRenderRef instance]getHistoryBarOriginalHeight]];
    [CATransaction commit];
    
    // draw the selection pointer
    pointerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
    [self addSubview:pointerView];
    pointerView.backgroundColor = [UIColor redColor];
    pointerView.center = CGPointMake(historyBarView.frame.size.width / 2, [[HistoryRenderRef instance]getHistoryBarOriginalHeight]);
}

- (void)setUpPreivewView: (nonnull HistoryPreviewView*) hpv {
    historyPreviewView = hpv;
    [self addSubview:historyPreviewView];
    
    historyPreviewView.frame = [UIScreen mainScreen].bounds;
    [self sendSubviewToBack:historyPreviewView];
}

@end
