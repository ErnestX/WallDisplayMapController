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
#import "JDDroppableView.h"
#import <ChameleonFramework/Chameleon.h>
#import "PNChart.h"
#import "DroppableBarChart.h"
#import "DroppableCircleChart.h"

const NSInteger ELEMENTS_PER_ROW = 3;

@interface DetailViewController ()

@end

@implementation DetailViewController {
    CGFloat visibleWidth;
    CGFloat gridSideLength;
    
    int lastX;      // last x position
    int lastY;      // last y position
    
    UIScrollView *gridView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.view.backgroundColor = COLOR_BG_WHITE;
    self.navigationController.navigationBar.tintColor = COLOR_BG_WHITE;
    // Make navigation bar colored
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorFromHexString:@"#1ABC9C"];
    
    // Customize appearance of navigation bar title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 40.0)];
    lblTitle.text = @"City Plan Metrics";
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    lblTitle.textColor = COLOR_BG_WHITE;
    self.navigationItem.titleView = lblTitle;
    
    // Right navigation item
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target: self action: @selector(widgetStartEditing)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    
    UIViewController *masterVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:0]).childViewControllers[0];
    CGFloat masterWidth = masterVC.view.frame.size.width;
    visibleWidth = self.view.bounds.size.width-masterWidth;
    gridSideLength = visibleWidth/ELEMENTS_PER_ROW;

    gridView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 10.0, visibleWidth-20.0, self.view.frame.size.height-20.0)];
    gridView.tag = 100081;
    gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    gridView.contentSize = CGSizeMake(gridView.frame.size.width, gridView.frame.size.height);
    [self.view addSubview:gridView];
    
    lastX = 0;
    lastY = 0;
}

- (void)addElement:(UIView *)vElement {
    
    CGRect chartFrame = CGRectMake(lastX*gridSideLength+30.0, lastY*gridSideLength+30.0, gridSideLength-60.0, gridSideLength-60.0);
    vElement.frame = chartFrame;
    [gridView addSubview: vElement];
    
    // update last position
    if (((lastX+1) % ELEMENTS_PER_ROW) == 0) {
        lastX = 0;
        lastY++;
        gridView.contentSize = CGSizeMake(gridView.contentSize.width, (lastY+1)*gridSideLength);

    } else {
        lastX++;
    }
    
    [self scrollToBottomAnimated:YES];

}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    [gridView.layer removeAllAnimations];
    
    CGFloat bottomScrollPosition = gridView.contentSize.height;
    bottomScrollPosition -= gridView.frame.size.height;
    bottomScrollPosition += gridView.contentInset.top;
    bottomScrollPosition = MAX(-gridView.contentInset.top,bottomScrollPosition);
    CGPoint newOffset = CGPointMake(-gridView.contentInset.left, bottomScrollPosition);
    if (newOffset.y != gridView.contentOffset.y) {
        [gridView setContentOffset: newOffset animated: animated];
    }
}

- (void)widgetStartEditing {
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target: self action: @selector(widgetEndEditing)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    NSArray *widgets = gridView.subviews;
    if ([widgets count] != 0) {
        // TODO: Start wobbling and show delete button on top right corner of each widget
        
    }
    
}

- (void)widgetEndEditing {
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target: self action: @selector(widgetStartEditing)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    
    // TODO: Stop wobbling and remove the delete buttons
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
