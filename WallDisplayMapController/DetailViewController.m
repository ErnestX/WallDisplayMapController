//
//  DetailViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "DetailViewController.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import "JDDroppableView.h"
#import <ChameleonFramework/Chameleon.h>
#import "PNChart.h"
#import "DroppableBarChart.h"
#import "DroppableCircleChart.h"
#import "WobbleAnimator.h"
#import "WallDisplayMapController-Swift.h"
#import "MetricCollectionViewCell.h"

const NSInteger ELEMENTS_PER_ROW = 3;

@interface DetailViewController ()<RAReorderableLayoutDataSource, RAReorderableLayoutDelegate>

@end

@implementation DetailViewController {
    CGFloat visibleWidth;
    CGFloat gridSideLength;
    UICollectionView *gridView;
    
    NSMutableArray *arrData;
    BOOL isEditing;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        arrData = [NSMutableArray arrayWithCapacity:20];
        isEditing = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = COLOR_BG_WHITE;
    [self configureNavigationBarAppearance];
    [self configureCollectionView];

}

- (void)viewWillAppear:(BOOL)animated {
    isEditing = NO;
    if (gridView && [arrData count] != 0) {
        UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target: self action: @selector(widgetStartEditing)];
        self.navigationItem.rightBarButtonItem = editBarButton;
        [gridView reloadData];

    }
}

- (void)configureCollectionView {
    // Set up CollectionView
    CGFloat gridSize = (visibleWidth-20.0)/3.0-7.0;
    RAReorderableLayout *aFlowLayout = [[RAReorderableLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake(gridSize, gridSize)];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(10.0, 10.0, visibleWidth-20.0, self.view.frame.size.height-64.0) collectionViewLayout:aFlowLayout];
    [gridView registerClass:[MetricCollectionViewCell class] forCellWithReuseIdentifier:@"testcell"];
    gridView.backgroundColor = ClearColor;
    gridView.tag = 100081;
    gridView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    gridView.dataSource = self;
    gridView.delegate = self;
    [self.view addSubview:gridView];
}

- (void)configureNavigationBarAppearance {
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
}

- (void)addElement:(DroppableChart *)vElement {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"chart_content"] = vElement.dictChart;
    data[@"chart_type"] = vElement.chartType;
    data[@"chart_category"] = vElement.chartCategory;
    [arrData addObject:data];
    
    [gridView reloadData];
    [self scrollToBottomAnimated:YES];

}

- (void)scrollToBottomAnimated:(BOOL)animated {
    [gridView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[arrData count]-1
                                                          inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom
                             animated:YES];
}

- (void)widgetStartEditing {
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target: self action: @selector(widgetEndEditing)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    isEditing = YES;
    [gridView reloadData];
}

- (void)widgetEndEditing {
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target: self action: @selector(widgetStartEditing)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    isEditing = NO;
    [gridView reloadData];
}

- (void)deleteElement:(id)sender {
    UIButton *btnDelete = (UIButton *)sender;
    NSIndexPath *indexPath = [gridView indexPathForItemAtPoint:[gridView convertPoint:btnDelete.center fromView:btnDelete.superview.superview]];
    [arrData removeObjectAtIndex:indexPath.item];
    [gridView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.item inSection:0]]];
    
}

#pragma RAReorderableLayout Datasource

- (UICollectionViewCell * __nonnull)collectionView:(UICollectionView * __nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * __nonnull)indexPath {
    
    MetricCollectionViewCell *cell = (MetricCollectionViewCell *)[collectionView  dequeueReusableCellWithReuseIdentifier:@"testcell" forIndexPath:indexPath];
    
    //update the cell's chart with the data in the array
    [cell updateWithData:[arrData objectAtIndex:indexPath.item]];
    if (isEditing) {
        [cell startAnimatingWithTarget:self];
    } else {
        [cell stopAnimating];
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView * __nonnull)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return [arrData count];
    else return  0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

#pragma RAReorderableLayout Delegate
- (BOOL)collectionView:(UICollectionView * __nonnull)collectionView allowMoveAtIndexPath:(NSIndexPath * __nonnull)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView * __nonnull)collectionView atIndexPath:(NSIndexPath * __nonnull)atIndexPath didMoveToIndexPath:(NSIndexPath * __nonnull)toIndexPath {
    
    NSDictionary *data = [arrData objectAtIndex:atIndexPath.item];
    [arrData removeObjectAtIndex:atIndexPath.item];
    [arrData insertObject:data atIndex:toIndexPath.item];
    [gridView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
