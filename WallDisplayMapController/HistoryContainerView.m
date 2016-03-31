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
    [historyBarController setHistoryBarHeight:450 withAnimationDuration:0.35];
}

- (void)testButtonReleased:(id)sender {
   [historyBarController restoreHistoryBarOriginalHeightWithAnimationDuration:0.35];
}

- (void)setUpHistoryBar: (HistoryBarController *) hbc {
    historyBarController = hbc;
    [self addSubview:historyBarController.collectionView];
    
    // draw the selection pointer
    UIView* pointer = [UIView new];
    [self addSubview:pointer];
    pointer.backgroundColor = [UIColor redColor];
    pointer.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray <NSLayoutConstraint*>* pointerViewConstraints = [[NSMutableArray alloc]init];
    [pointerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:pointer
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:5.0]];
    [pointerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:pointer
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:20.0]];
    [pointerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:pointer
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:historyBarController.collectionView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
    [pointerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:pointer
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:historyBarController.collectionView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0.0]];
    [NSLayoutConstraint activateConstraints:pointerViewConstraints];
}



@end
