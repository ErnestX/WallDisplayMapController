//
//  ChooseElementViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-24.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "ChooseElementViewController.h"
#import "DetailViewController.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import "UnavailableView.h"
#import "JDDroppableView.h"

#define WIDGET_ELEMENT_HEIGHT 200.0

@interface ChooseElementViewController () <JDDroppableViewDelegate>

@end

@implementation ChooseElementViewController {
    
    UIScrollView *scrollView;
    UIView *dropTarget;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = COLOR_BG_WHITE;
    self.view.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.0, 40.0)];
    lblTitle.text = self.title;
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    lblTitle.textColor = COLOR_BG_WHITE;
    self.navigationItem.titleView = lblTitle;
    
    UIViewController *targetVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:1]).childViewControllers[0];
    [[targetVC.view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subview = obj;
        if (subview.tag == 100081){
            dropTarget = subview;
            *stop = YES;
        }
    }];
    
    if (!self.arrData) {
        // No data, widget elements unavailable
        [self showDataUnavailable];
        
    } else {
        // Display widget elements in table cells with the data we have
        [self showTableWithSelectableElements];
        
    }
    
}

- (void)showTableWithSelectableElements {
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.canCancelContentTouches = NO;
    scrollView.contentSize = CGSizeMake(100.0, (self.arrData.count+8)*WIDGET_ELEMENT_HEIGHT);
    [self.view addSubview: scrollView];
    
    // Layout widget elements
    for (int i=0; i<[self.arrData count]+8; i++) {
        JDDroppableView * dropview = [[JDDroppableView alloc] initWithDropTarget: dropTarget];
        dropview.backgroundColor = [UIColor orangeColor];
        dropview.layer.cornerRadius = 3.0;
        dropview.frame = CGRectMake(5.0, i*WIDGET_ELEMENT_HEIGHT, scrollView.frame.size.width*0.25-10.0, WIDGET_ELEMENT_HEIGHT-10.0);
        dropview.delegate = self;
        dropview.tag = i;
        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:dropview.frame];
        bottomView.layer.cornerRadius = 3.0;
        bottomView.backgroundColor = [UIColor orangeColor];
        bottomView.alpha = 0.5;
        bottomView.tag = i;
        
        [scrollView addSubview:bottomView];
        [scrollView addSubview: dropview];
    
    }

}

- (void)showDataUnavailable {
    UnavailableView *vUnav = [[UnavailableView alloc] initWithInfoText:@"Sorry, the requested information is currently unavailable."];
    [self.view addSubview:vUnav];
    
    DEFINE_WEAK_SELF
    [vUnav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.and.bottom.equalTo(weakSelf.view);
        
    }];
    
    [vUnav show];
}

#pragma mark JDDroppableViewDelegate

- (void)droppableView:(JDDroppableView *)view enteredTarget:(UIView *)target {
    
}

- (void)droppableView:(JDDroppableView *)view leftTarget:(UIView *)target {


}

- (void)droppableViewBeganDragging:(JDDroppableView *)view {

}

- (void)droppableViewDidMove:(JDDroppableView *)view {
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];

}

- (void)droppableViewEndedDragging:(JDDroppableView *)view onTarget:(UIView *)target {
    if (target) {
        [view removeFromSuperview];
        DetailViewController *targetVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:1]).childViewControllers[0];
        
        [targetVC addElement:view];
    }
    
}

- (BOOL)shouldAnimateDroppableViewBack:(JDDroppableView *)view wasDroppedOnTarget:(UIView *)target {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
