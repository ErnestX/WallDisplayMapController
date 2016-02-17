//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"

@implementation HistoryContainerView

UICollectionView* historyBarView;
float historyBarOriginalHeight;

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
//    [UIView animateWithDuration:0.5 animations:^(void){
        historyBarView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 500);
//    }];
}

- (void)testButtonReleased:(id)sender {
//    [UIView animateWithDuration:0.5 animations:^(void){
        historyBarView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 150);
//    }];
}

- (void) setUpHistoryBar: (UICollectionView *) historyBar {
    historyBarView = historyBar;
    [self addSubview:historyBarView];
    
    // remeber the original height of the history bar
    historyBarOriginalHeight = historyBar.frame.size.height;
    
//    // init the history bar
//    historyBarView.frame = CGRectMake(self.frame.origin.x,
//                                      self.frame.origin.y,
//                                      self.frame.size.width,
//                                      HISTORY_BAR_HEIGHT);
    
    // draw the selection pointer
    UIView* pointer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
    [self addSubview:pointer];
    pointer.backgroundColor = [UIColor redColor];
    pointer.center = CGPointMake(historyBarView.frame.size.width / 2, historyBarView.frame.size.height);
}

@end
