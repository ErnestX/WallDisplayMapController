//
//  HistoryView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerView.h"

//#define CELL_WIDTH 100
#define HISTORY_BAR_HEIGHT 150

@implementation HistoryContainerView

UICollectionView* historyBarView;

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
    
    // init the history bar
    historyBarView.frame = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      HISTORY_BAR_HEIGHT);
//    ((UICollectionViewFlowLayout*)historyBarView.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    ((UICollectionViewFlowLayout*)historyBarView.collectionViewLayout).itemSize = CGSizeMake(CELL_WIDTH, historyBarView.frame.size.height);
//    float sideInset = historyBarView.frame.size.width/2 - CELL_WIDTH/2; // so that at the left/right edge, the middle of the first/last cell is at the center of the screen
//    ((UICollectionViewFlowLayout*)historyBarView.collectionViewLayout).sectionInset = UIEdgeInsetsMake(0, sideInset, 0, sideInset);
//    ((UICollectionViewFlowLayout*)historyBarView.collectionViewLayout).minimumInteritemSpacing = 0;
//    ((UICollectionViewFlowLayout*)historyBarView.collectionViewLayout).minimumLineSpacing = 0;
    
    // draw the selection pointer
    UIView* pointer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 20)];
    [self addSubview:pointer];
    pointer.backgroundColor = [UIColor redColor];
    pointer.center = CGPointMake(historyBarView.frame.size.width / 2, historyBarView.frame.size.height);
}

@end
