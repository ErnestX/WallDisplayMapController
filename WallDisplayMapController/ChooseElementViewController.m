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
#import "DroppableCircleChart.h"
#import "DroppableBarChart.h"

@interface ChooseElementViewController () <JDDroppableViewDelegate>

@property NSString *test;

@end

@implementation ChooseElementViewController {
    CGFloat widgetElementSideLength;
    
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
    
    widgetElementSideLength = self.view.frame.size.width * MASTER_VC_WIDTH_FRACTION;
    scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.canCancelContentTouches = NO;
    scrollView.contentSize = CGSizeMake(100.0, (self.arrData.count+8)*widgetElementSideLength);
    [self.view addSubview: scrollView];
    
    
    // Layout widget elements
    for (int i=0; i<[self.arrData count]+8; i++) {
        CGRect chartFrame = CGRectMake(5.0, i*widgetElementSideLength+5.0, widgetElementSideLength-10.0, widgetElementSideLength-10.0);
        DroppableBarChart *dropview = [[DroppableBarChart alloc] initWithFrame:chartFrame
                                                                         target:dropTarget
                                                                       delegate:self];
        DroppableBarChart *bottomView = [[DroppableBarChart alloc] initWithFrame:chartFrame];
        bottomView.alpha = 0.5;
        bottomView.userInteractionEnabled = NO;
        [scrollView addSubview:bottomView];
        [scrollView addSubview: dropview];
        [dropview updateBarChartWithValues:@[@1234, @2345] type:@"Mobility"];
        [bottomView updateBarChartWithValues:@[@1234, @2345] type:@"Mobility"];
        
//        [dropview updateBarChartWithValues:@[@1234, @2345, @34, @124, @2, @690] type:@"Mobility"];
//        [bottomView updateBarChartWithValues:@[@1234, @2345, @34, @124, @2, @690] type:@"Mobility"];
        
//        DroppableCircleChart * dropview = [[DroppableCircleChart alloc] initWithFrame:CGRectMake(5.0, i*widgetElementSideLength+5.0, widgetElementSideLength-10.0, widgetElementSideLength-10.0)];
//        [dropview addDropTarget:dropTarget];
//        dropview.delegate = self;
//        dropview.tag = i;
//        
//        
//        DroppableCircleChart *bottomView = [[DroppableCircleChart alloc] initWithFrame:CGRectMake(5.0, i*widgetElementSideLength+5.0, widgetElementSideLength-10.0, widgetElementSideLength-10.0)];
//        bottomView.userInteractionEnabled = NO;
//        bottomView.alpha = 0.5;
//        bottomView.tag = i;
//        
//        [scrollView addSubview:bottomView];
//        [scrollView addSubview: dropview];
//        
//        [dropview updateCircleChartWithCurrent:@66 type:@"Mobility" icon:nil];
//        [bottomView updateCircleChartWithCurrent:@66 type:@"Mobility" icon:nil];
    
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
