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
#import "GlobalManager.h"
#import "DroppableNumberView.h"
#import "DroppableSingleBarView.h"

@interface ChooseElementViewController () <JDDroppableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation ChooseElementViewController {
    CGFloat widgetElementSideLength;
    
    UnavailableView *vUnavailable;
    UIScrollView *scrollView;
    UIView *dropTarget;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(widgetDataUpdated) name:WIDGET_DATA_UPDATED object:nil];
        self.arrData = [NSMutableArray arrayWithCapacity:5];
        vUnavailable = [[UnavailableView alloc] initWithInfoText:@"Sorry, the requested information is currently unavailable."];
        scrollView = [[UIScrollView alloc] init];


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = COLOR_BG_WHITE;
    self.view.backgroundColor = COLOR_BG_GREY;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.0, 40.0)];
    lblTitle.text = self.title;
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    lblTitle.textColor = COLOR_BG_WHITE;
    self.navigationItem.titleView = lblTitle;
    
    UIViewController *targetVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:1]).childViewControllers[0];
    dropTarget = [targetVC.view viewWithTag:100081];
    
    [self.arrData addObjectsFromArray:[[GlobalManager sharedInstance] getWidgetElementsByCategory:self.category]];
    
    DEFINE_WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf reloadData];
    });
    
}

- (void)showTableWithSelectableElements {
    
    widgetElementSideLength = self.view.frame.size.width;// * MASTER_VC_WIDTH_FRACTION;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = COLOR_BG_GREY;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.canCancelContentTouches = NO;
    scrollView.contentSize = CGSizeMake(100.0, (self.arrData.count)*widgetElementSideLength);
    [self.view addSubview: scrollView];
    
    // Layout widget elements
    for (int i=0; i<[self.arrData count]; i++) {
        NSDictionary *dict = self.arrData[i];
        NSString *chartType = dict[@"ch_type"];
        NSDictionary *data = dict[@"ch_data"];
        NSString *key = data[@"ch_key"];
        BOOL isAvailable = [[GlobalManager sharedInstance] isWidgetAvailableForKey:key];
        CGRect chartFrame = CGRectMake(1.0, i*widgetElementSideLength+0.5, widgetElementSideLength-2.0, widgetElementSideLength-1.0);
        
        NSArray *filteredKeys = [[data allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return !([(NSString *)evaluatedObject isEqualToString:@"ch_key"] ||
                     [(NSString *)evaluatedObject isEqualToString:@"detail_info"]);
        }]] ;
        NSArray *filteredValues = [[data allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return !([evaluatedObject isKindOfClass:[NSString class]] ||
                     [evaluatedObject isKindOfClass:[NSDictionary class]]);
        }]];
        
        if ([chartType isEqualToString:CHART_TYPE_BAR]) {
            // build one single bar chart
            DroppableBarChart *bottomView = [[DroppableBarChart alloc] initWithFrame:chartFrame];
            bottomView.alpha = 0.5;
            bottomView.userInteractionEnabled = NO;
            [scrollView addSubview:bottomView];
            

            [bottomView updateBarChartWithValues: filteredValues labels:filteredKeys type:self.category];

            if (isAvailable) {
                DroppableBarChart *dropview = [[DroppableBarChart alloc] initWithFrame:chartFrame
                                                                                target:dropTarget
                                                                              delegate:self];
                [scrollView addSubview: dropview];
                [dropview updateBarChartWithValues: filteredValues labels:filteredKeys type:self.category];
                
                
                dropview.dictChart = data;
                dropview.chartType = chartType;
                dropview.chartCategory = self.category;
            }
            
        
        } else if ([chartType isEqualToString:CHART_TYPE_CIRCLE]) {
            // build circle chart
            DroppableCircleChart *bottomView = [[DroppableCircleChart alloc] initWithFrame:chartFrame];
            bottomView.userInteractionEnabled = NO;
            bottomView.alpha = 0.5;
            [bottomView updateCircleChartWithCurrent:filteredValues[0] type:self.category icon:filteredKeys[0]];
            [scrollView addSubview:bottomView];
            
            if (isAvailable) {
                DroppableCircleChart * dropview = [[DroppableCircleChart alloc] initWithFrame:chartFrame];
                [dropview addDropTarget:dropTarget];
                dropview.delegate = self;
                
                
                [scrollView addSubview: dropview];
                
                [dropview updateCircleChartWithCurrent:filteredValues[0] type:self.category icon:filteredKeys[0]];
                
                
                dropview.dictChart = data;
                dropview.chartType = chartType;
                dropview.chartCategory = self.category;
            }
            
        } else if ([chartType isEqualToString:CHART_TYPE_PIE]) {
            // not now
            
        } else if ([chartType isEqualToString:CHART_TYPE_NUMBER]) {
            // build number view
            
            DroppableNumberView *bottomView = [[DroppableNumberView alloc] initWithFrame:chartFrame];
            bottomView.alpha = 0.5;
            bottomView.userInteractionEnabled = NO;
            [scrollView addSubview:bottomView];
            
            
            [bottomView  updateWithMainMeasure:data[@"main"] subMeasure:data[@"sub"] description:data[@"desc"] type:self.category];
            
            if (isAvailable) {
                DroppableNumberView *dropview = [[DroppableNumberView alloc] initWithFrame:chartFrame
                                                                                target:dropTarget
                                                                              delegate:self];
                [scrollView addSubview: dropview];
                [dropview  updateWithMainMeasure:data[@"main"] subMeasure:data[@"sub"] description:data[@"desc"] type:self.category];
                
                dropview.dictChart = data;
                dropview.chartType = chartType;
                dropview.chartCategory = self.category;
            }
            
        } else if ([chartType isEqualToString:CHART_TYPE_SINGLE_BAR]) {
            
            DroppableSingleBarView *bottomView = [[DroppableSingleBarView alloc] initWithFrame:chartFrame];
            bottomView.userInteractionEnabled = NO;
            bottomView.alpha = 0.5;
            [bottomView updateWithArrayThresholds:data[@"thresholds"] current:data[@"current"] title:data[@"title"] type:self.category];
            [scrollView addSubview:bottomView];
            
            if (isAvailable) {
                DroppableSingleBarView * dropview = [[DroppableSingleBarView alloc] initWithFrame:chartFrame];
                [dropview addDropTarget:dropTarget];
                dropview.delegate = self;
                
                [scrollView addSubview: dropview];
                [dropview updateWithArrayThresholds:data[@"thresholds"] current:data[@"current"] title:data[@"title"] type:self.category];
                
                dropview.dictChart = data;
                dropview.chartType = chartType;
                dropview.chartCategory = self.category;
            }

        } else {
            // temporary code

        }
    
    }

}

- (void)showDataUnavailable {
    [self.view addSubview:vUnavailable];
    
    DEFINE_WEAK_SELF
    [vUnavailable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.and.bottom.equalTo(weakSelf.view);
        
    }];
    
    [vUnavailable show];
}

- (void)reloadData {
    if (!self.arrData || self.arrData.count == 0) {
        // No data, widget elements unavailable
        [self showDataUnavailable];
        
    } else {
        // Display widget elements in table cells with the data we have
        [self showTableWithSelectableElements];
        
    }
}

- (void)widgetDataUpdated {
    
    DEFINE_WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *newData = [[GlobalManager sharedInstance] getWidgetElementsByCategory:self.category];
        if (!newData || newData.count == 0) {
            return ;
        } else {
            [weakSelf.arrData removeAllObjects];
            [weakSelf.arrData addObjectsFromArray:newData];
            [vUnavailable removeFromSuperview];
            [[scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf reloadData];
        }

    });
    
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
        
        DetailViewController *targetVC = ((UIViewController *)[self.splitViewController.viewControllers objectAtIndex:1]).childViewControllers[0];
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             view.center = [targetVC getCenterOfLastEmptyPosition];
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             DroppableChart *newView = (DroppableChart *)view;
                             [targetVC addElement:newView];
                             
                             [[GlobalManager sharedInstance] setWidgetForKey:newView.dictChart[@"ch_key"] available:NO];

                         }];
    }
    
}

- (BOOL)shouldAnimateDroppableViewBack:(JDDroppableView *)view wasDroppedOnTarget:(UIView *)target {
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
