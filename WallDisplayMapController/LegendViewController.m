//
//  LegendViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "LegendViewController.h"
#import "LegendView.h"
#import "HistoryContainerViewController.h"
#import "GlobalLayoutRef.h"

// these two have nothing to do with the actual dimensions displayed, since they will be reset by the HistoryContainerView. However, they should be large enough so that the initalization can succeed
#define LEGEND_VIEW_INIT_WIDTH 100
#define LEGEND_VIEW_INIT_HEIGHT 200

@implementation LegendViewController {
    HistoryContainerViewController* containerController;
}

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init legend view
    LegendView* legendView = [[LegendView alloc]initWithFrame:CGRectMake(0.0, 0.0, LEGEND_VIEW_INIT_WIDTH, LEGEND_VIEW_INIT_HEIGHT)];
    
    legendView.delegate = self;
    self.view = legendView;
}

@end
