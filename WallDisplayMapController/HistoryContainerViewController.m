//
//  HistoryViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerViewController.h"
#import "HistoryContainerView.h"
#import "HistoryBarController.h"
#import "HistoryPreviewController.h"
#import "MetricsHistoryDataCenter.h"

@interface HistoryContainerViewController ()

@end

@implementation HistoryContainerViewController
{
    HistoryBarController* historyBarController;
    HistoryPreviewController* historyPreviewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init containerView
    HistoryContainerView *historyContainerView = [[HistoryContainerView alloc] initWithFrame:self.view.bounds];
    self.view = historyContainerView;
    
    // create and init preview controller
    historyPreviewController = [[HistoryPreviewController alloc]initWithContainerController:self];
    NSAssert(historyPreviewController, @"init failed");
    
    [self addChildViewController:historyPreviewController];
    
    // give historyPreviewView to containerView to add it as subview and init the size
    [(HistoryContainerView*)self.view setUpPreivewView:(HistoryPreviewView*)historyPreviewController.view];
    
    // create and init historyBarController
    historyBarController = [[HistoryBarController alloc]initWithContainerController:self];
    NSAssert(historyBarController, @"init failed");
    
    [self addChildViewController:historyBarController];
    
    // give historyBarView to containerView to add it as subview and init the size
    [(HistoryContainerView*)self.view setUpHistoryBar:(HistoryBarView*)historyBarController.collectionView];
}

- (NSDictionary*)getMetricsDataAtTimeIndex:(NSInteger)index {
    return [[MetricsHistoryDataCenter instance] getMetricsDataAtTimeIndex:index];
}

- (NSInteger)getTotalNumberOfData {
    return [[MetricsHistoryDataCenter instance] getTotalNumberOfData];
}

- (UIImage*)getPreviewForIndex:(NSInteger)index {
    // stub
    NSBundle *mainBundle = [NSBundle mainBundle];
    if (index%2) {
        return [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"]];
    } else {
        return [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"]];
    }
}

- (void)showPreviewForIndex:(NSInteger)index {
    [historyPreviewController showPreviewAtIndex:index];
}

@end
