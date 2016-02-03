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

@interface HistoryContainerViewController ()

@end

@implementation HistoryContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init containerView
    HistoryContainerView *historyContainerView = [[HistoryContainerView alloc] initWithFrame:self.view.bounds];
    self.view = historyContainerView;
    
    // create and init historyBarController
    HistoryBarController *historyBarController = [[HistoryBarController alloc]init]; // init is overwritted
    [self addChildViewController:historyBarController];
    
    // ask historyBarController to create, set up, and return historyBarView
    UICollectionView* historyBarView = [historyBarController setUpAndReturnHistoryBar];
    
    // give historyBarView to containerView to add it as subview and init the size
    [historyContainerView setUpHistoryBar:historyBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
