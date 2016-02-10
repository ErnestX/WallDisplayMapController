//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"

#define HISTORY_BAR_HEIGHT 150

@implementation HistoryContainerView

UIView* historyBarView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    return self;
}

- (void) setUpHistoryBar: (UIView *) historyBar {
    historyBarView = historyBar;
    [self addSubview:historyBarView];
    
    // init the history bar
    historyBarView.frame = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      HISTORY_BAR_HEIGHT);
    
    // draw the selection pointer
    UIView* pointer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
    [self addSubview:pointer];
    pointer.backgroundColor = [UIColor redColor];
    pointer.center = CGPointMake(historyBarView.frame.size.width / 2, historyBarView.frame.size.height);
}

@end
