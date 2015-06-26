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

    self.view.backgroundColor = COLOR_BG_WHITE;
    self.navigationController.navigationBarHidden = YES;
    
    UIViewController *masterVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:0]).childViewControllers[0];
    CGFloat masterWidth = masterVC.view.frame.size.width;
    visibleWidth = self.view.bounds.size.width-masterWidth;
    gridSideLength = visibleWidth/ELEMENTS_PER_ROW;

    gridView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0, 10.0, visibleWidth-20.0, self.view.frame.size.height-20.0)];
    gridView.backgroundColor = [UIColor flatSandColor];
    gridView.tag = 100081;
    gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    gridView.contentSize = CGSizeMake(gridView.frame.size.width, gridView.frame.size.height);
    [self.view addSubview:gridView];
    
    lastX = 0;
    lastY = 0;
}

// TODO: Modify this method so its input is data only, not view
- (void)addElement:(UIView *)vElement {
    vElement.frame = CGRectMake(lastX*gridSideLength+5.0, lastY*gridSideLength+5.0, gridSideLength-10.0, gridSideLength-10.0);
    vElement.userInteractionEnabled = NO;
    [gridView addSubview: vElement];
    [self scrollToBottomAnimated: YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
