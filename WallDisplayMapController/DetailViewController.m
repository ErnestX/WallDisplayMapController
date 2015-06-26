//
//  DetailViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>

@interface DetailViewController ()

@end

@implementation DetailViewController {
    UIScrollView *gridView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_BG_WHITE;
    self.navigationController.navigationBarHidden = YES;
    
    UIViewController *masterVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:0]).childViewControllers[0];
    CGFloat masterWidth = masterVC.view.frame.size.width;
    
    gridView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 10.0, self.view.bounds.size.width-20.0-masterWidth, self.view.frame.size.height-20.0)];
    gridView.backgroundColor = [UIColor flatWatermelonColor];
    gridView.tag = 100081;
    gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    gridView.contentSize = CGSizeMake(gridView.frame.size.width, gridView.frame.size.height);
    [self.view addSubview:gridView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
