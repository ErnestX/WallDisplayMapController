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
#import "GlobalManager.h"
#import "HintView.h"
#import "MaskContentView.h"

const NSInteger ELEMENTS_PER_ROW = 4;

@interface DetailViewController ()<RAReorderableLayoutDataSource, RAReorderableLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DetailViewController {
    CGFloat visibleWidth;
    CGFloat gridSideLength;
    UICollectionView *gridView;
    DroppableBarChart *fixedBars;
    
    NSMutableArray *arrData;
    
    HintView *vHint;
    
    BOOL isEditing;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        arrData = [NSMutableArray arrayWithCapacity:20];
        isEditing = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(widgetDataUpdated) name:WIDGET_DATA_UPDATED object:nil];
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
    NSDictionary *dictPD = [[GlobalManager sharedInstance] getPeopleAndDwellings];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"chart_content"] = dictPD;
    
    NSArray *filteredKeys = [[dictPD allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !([(NSString *)evaluatedObject isEqualToString:@"ch_key"] ||
                 [(NSString *)evaluatedObject isEqualToString:@"detail_info"]);
    }]] ;
    NSArray *filteredValues = [[dictPD allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !([evaluatedObject isKindOfClass:[NSString class]] ||
                 [evaluatedObject isKindOfClass:[NSDictionary class]]);
    }]];
    
    
    UIView *topContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, visibleWidth, gridSideLength)];
    topContainer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [self.view addSubview:topContainer];
    
    UILabel *lblFixed = [[UILabel alloc] init];
    lblFixed.textAlignment = NSTextAlignmentRight;
    lblFixed.textColor = [UIColor lightGrayColor];
    lblFixed.numberOfLines = 0;
    lblFixed.lineBreakMode = NSLineBreakByWordWrapping;
    lblFixed.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    lblFixed.text = @"This area is intended to be non-customizable. You can hide it by pressing the up button.";
    [topContainer addSubview:lblFixed];
    [lblFixed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(topContainer).with.offset(-65.0f);
        make.baseline.equalTo(topContainer).with.offset(-10.0f);
        make.width.lessThanOrEqualTo(@350.0);
    }];
    
    UIButton *btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHide setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    [btnHide setBackgroundImage:[UIImage imageNamed:@"up_pressed.png"] forState:UIControlStateHighlighted];
    [btnHide addTarget:self action:@selector(hideTopBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topContainer addSubview:btnHide];
    
    [btnHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lblFixed.mas_trailing).with.offset(15.0f);
        make.width.height.equalTo(@22.0f);
        make.centerY.equalTo(lblFixed);
    }];
    
    fixedBars = [[DroppableBarChart alloc] initWithFrame:CGRectMake(10, 10, gridSideLength-20, gridSideLength-20)];
    fixedBars.isDraggable = NO;
    for (UIGestureRecognizer *recognizer in fixedBars.gestureRecognizers) {
        [fixedBars removeGestureRecognizer:recognizer];
    }
    [self.view addSubview:fixedBars];
    [fixedBars updateBarChartWithValues: filteredValues labels:filteredKeys type:@"Land Use"];
    
    // Set up CollectionView
    RAReorderableLayout *aFlowLayout = [[RAReorderableLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake(gridSideLength, gridSideLength)];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    aFlowLayout.minimumInteritemSpacing = 0.0;
    aFlowLayout.minimumLineSpacing = 0.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, gridSideLength, visibleWidth, 1.0f)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, gridSideLength + 1.0f, visibleWidth, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-44.0-(gridSideLength+1.0)) collectionViewLayout:aFlowLayout];
    [gridView registerClass:[MetricCollectionViewCell class] forCellWithReuseIdentifier:@"testcell"];
    gridView.backgroundColor = ClearColor;
    gridView.tag = 100081;
    gridView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    gridView.dataSource = self;
    gridView.delegate = self;
    [self.view addSubview:gridView];

    vHint = [[HintView alloc] initWithFrame:CGRectMake(0, gridSideLength + 1.0f, visibleWidth, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-44.0-(gridSideLength+1.0))];
    [self.view addSubview:vHint];
}

- (void)configureNavigationBarAppearance {
    self.navigationController.navigationBar.tintColor = COLOR_BG_WHITE;
    // Make navigation bar colored
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorFromHexString:@"#1ABC9C"];
    
    // Customize appearance of navigation bar title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 40.0)];
    lblTitle.text = @"City Plan Indicators";
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
    

    if (arrData.count == 1) {
        [vHint removeFromSuperview];
        [gridView reloadData];
        return;
    }
    
    [gridView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:arrData.count - 1 inSection:0]]];
    [self scrollToBottomAnimated:YES];

}

- (CGPoint)getCenterOfLastEmptyPosition {
    CGFloat x = 0;
    CGFloat y = 0;
    
    NSInteger column = arrData.count % ELEMENTS_PER_ROW + 1;
    x = column * gridSideLength + gridSideLength/2;
    
    NSInteger row = arrData.count / ELEMENTS_PER_ROW + 1;
    y = row * gridSideLength - gridSideLength/2;
    
    CGPoint pointInSuperview = [self.view.superview convertPoint:CGPointMake(x, y) fromView:self.view];

    return pointInSuperview;
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
    
    NSDictionary *temp = [arrData objectAtIndex:indexPath.item];
    NSString *key = temp[@"chart_content"][@"ch_key"];
    [[GlobalManager sharedInstance] setWidgetForKey:key available:YES];
    
    [arrData removeObjectAtIndex:indexPath.item];
    [gridView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.item inSection:0]]];
    
    if (arrData.count == 0) {
        [self.view addSubview:vHint];
        [self widgetEndEditing];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WIDGET_DATA_UPDATED object:nil];

    
}

- (void)widgetDataUpdated {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [[GlobalManager sharedInstance] getPeopleAndDwellings];

        NSArray *filteredKeys = [[data allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return !([(NSString *)evaluatedObject isEqualToString:@"ch_key"] ||
                     [(NSString *)evaluatedObject isEqualToString:@"detail_info"]);
        }]] ;
        NSArray *filteredValues = [[data allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return !([evaluatedObject isKindOfClass:[NSString class]] ||
                     [evaluatedObject isKindOfClass:[NSDictionary class]]);
        }]];
        
        [fixedBars updateBarChartWithValues:filteredValues labels:filteredKeys type:@"Land Use"];
        
        
        [arrData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            obj[@"chart_content"] = [[GlobalManager sharedInstance] getWidgetElementByCategory:obj[@"chart_category"] andKey:obj[@"chart_content"][@"ch_key"]][@"ch_data"];
            
        }];
        
        [gridView reloadData];
        

    });

}

- (void)hideTopBarButtonPressed:(UIButton *)btn{
    
}

- (void)showTopBarButtonPressed:(UIButton *)btn {
    
}

- (void)deselectCellWithIndex:(NSInteger)index {
    [gridView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES];
}

#pragma mark RAReorderableLayout Datasource

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

#pragma mark RAReorderableLayout Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isEditing) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        MaskContentView *maskView = [[MaskContentView alloc] initWithFrame:window.bounds target:self];
        maskView.itemIndex = indexPath.item;
        
        [window addSubview:maskView];
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
                             [maskView showContent:[arrData objectAtIndex:indexPath.item]];
                         }
                         completion:^(BOOL finished) {
                             maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
                         }];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }

    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView * __nonnull)collectionView reorderingItemAlphaInSection:(NSInteger)section {
    return 0.3;
}

- (void)collectionView:(UICollectionView * __nonnull)collectionView atIndexPath:(NSIndexPath * __nonnull)atIndexPath didMoveToIndexPath:(NSIndexPath * __nonnull)toIndexPath {
    
    NSDictionary *data = [arrData objectAtIndex:atIndexPath.item];
    [arrData removeObjectAtIndex:atIndexPath.item];
    [arrData insertObject:data atIndex:toIndexPath.item];
    [gridView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
