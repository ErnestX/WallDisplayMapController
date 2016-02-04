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
}

@end
