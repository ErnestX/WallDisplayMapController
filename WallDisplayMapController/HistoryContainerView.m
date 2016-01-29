//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"
#import "HistoryBarView.h"

@implementation HistoryContainerView

HistoryBarView* historyBarView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    return self;
}

- (UICollectionView*) setUpAndReturnHistoryBar {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    historyBarView = [[HistoryBarView alloc]initWithFrame:CGRectMake(self.frame.origin.x,
                                                                     self.frame.origin.y,
                                                                     self.frame.size.width,
                                                                     100)
                                     collectionViewLayout:flowLayout];
    [self addSubview:historyBarView];
    return historyBarView;
}

@end
