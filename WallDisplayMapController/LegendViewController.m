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

#define LEGEND_VIEW_WIDTH 200
#define LEGEND_VIEW_HEIGHT 500
#define LEGEND_VIEW_TOP_MARGIN 3

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
    LegendView* legendView = [[LegendView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width,
                                                                         [[GlobalLayoutRef instance]getHistoryBarOriginalHeight],
                                                                         LEGEND_VIEW_WIDTH,
                                                                         LEGEND_VIEW_HEIGHT)];
    legendView.layer.anchorPoint = CGPointMake(1.0, 0.0); // set anchor point to top right
    legendView.delegate = self;
    self.view = legendView;
}

@end
