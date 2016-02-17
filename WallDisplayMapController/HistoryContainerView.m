//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"

@implementation HistoryContainerView
{
    HistoryBarController* historyBarController;
    float historyBarOriginalHeight;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
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
    NSLog(@"test button pressed");
    [UIView animateWithDuration:0.5 animations:^(void){
        [historyBarController setHistoryBarHeight:500];
    }];
}

- (void)testButtonReleased:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void){
        [historyBarController setHistoryBarHeight:historyBarOriginalHeight];
    }];
}

- (void) setUpHistoryBar: (HistoryBarController *) hbc {
    historyBarController = hbc;
    [self addSubview:historyBarController.collectionView];
    
    // remeber the original height of the history bar
    historyBarOriginalHeight = historyBarController.collectionView.frame.size.height;
    
    // draw the selection pointer
    UIView* pointer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
    [self addSubview:pointer];
    pointer.backgroundColor = [UIColor redColor];
    pointer.center = CGPointMake(historyBarController.collectionView.frame.size.width / 2, historyBarOriginalHeight);
}

@end
