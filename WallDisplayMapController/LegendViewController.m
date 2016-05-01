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
#import "MetricsConfigs.h"
#import "LegendViewCell.h"

// these two have nothing to do with the actual dimensions displayed, since they will be reset by the HistoryContainerView. However, they should be large enough so that the initalization can succeed
#define LEGEND_VIEW_INIT_WIDTH 100
#define LEGEND_VIEW_INIT_HEIGHT 200
#define MAX_NUMBER_OF_METRICS 5 // if number of metrics equals or exceeds this, no new metrics can be added, but the existing ones are still displayed technically (though the frame size would need to change to fit)

@implementation LegendViewController {
    HistoryContainerViewController* containerController;
}

static NSString* const reuseIdentifier = @"cell";

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // create and init legend view
    LegendView* legendView = [[LegendView alloc]initWithFrame:CGRectMake(0.0, 0.0, LEGEND_VIEW_INIT_WIDTH, LEGEND_VIEW_INIT_HEIGHT)];
    
    legendView.delegate = self;
    legendView.dataSource = self;
    
    self.view = legendView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(LegendView*)self.view registerClass:[LegendViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // re-use or create a cell
    LegendViewCell* cell = [(LegendView*)self.view dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    int index = [indexPath item];

    MetricName m;
    if (index >= [MetricsConfigs instance].metricsDisplayedInOrder.count) {
        // default to notAMetric
        m = notAMetric;
    } else {
        m = [[[MetricsConfigs instance].metricsDisplayedInOrder objectAtIndex:index] integerValue];
    }
    cell = [cell initForReuseWithMetricName:m myDelegate:self];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([MetricsConfigs instance].metricsDisplayedInOrder.count < MAX_NUMBER_OF_METRICS) {
            return [MetricsConfigs instance].metricsDisplayedInOrder.count + 1; // inclue "add new metric" cell
        } else {
            return [MetricsConfigs instance].metricsDisplayedInOrder.count;
        }
    } else {
        return 0;
    }
}

- (void)showPickerViewController:(UIViewController *)pvc fromView:(UIView *)v{
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)setMetricsConfigArrayByReplacingMetricAtIndexOfCell:(UITableViewCell*)cell withMetric:(MetricName)m {
//    NSInteger numOfCells = [self tableView:(LegendView*)self.view numberOfRowsInSection:0];
    NSIndexPath* indexPath = [(LegendView*)self.view indexPathForCell:cell];
    NSAssert(indexPath, @"cannot find cell");
    
    NSInteger index = indexPath.row;
    NSMutableArray<NSNumber*>* tempArr = [NSMutableArray arrayWithArray:[MetricsConfigs instance].metricsDisplayedInOrder];
    if (m != notAMetric) {
        if (index < tempArr.count) {
            // within range
            [tempArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:m]];
        } else {
            [tempArr addObject:[NSNumber numberWithInteger:m]];
        }
    } else {
        // not a metric
        if (index < tempArr.count) {
            // within range: remove entry
            [tempArr removeObjectAtIndex:index];
        }
    }
    
    BOOL succ = [[MetricsConfigs instance]setMetricsDisplayedInOrderWithArray:tempArr];
    NSAssert(succ, @"reset MetricsConfigs array fail");
}

@end
