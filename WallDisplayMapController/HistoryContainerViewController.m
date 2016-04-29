//
//  HistoryViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-27.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerViewController.h"
#import "HistoryContainerView.h"
#import "HistoryBarController.h"
#import "HistoryPreviewController.h"
#import "MetricsHistoryDataCenter.h"
#import "MetricsDataEntry.h"
#import "MetricsConfigs.h"

@interface HistoryContainerViewController ()

@end

@implementation HistoryContainerViewController
{
    HistoryBarController* historyBarController;
    HistoryPreviewController* historyPreviewController;
}

- (id)init {
    self = [super init];
    if (self) {
        [[MetricsHistoryDataCenter instance] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init containerView
    HistoryContainerView *historyContainerView = [[HistoryContainerView alloc] initWithFrame:self.view.bounds];
    self.view = historyContainerView;
    
    // create and init preview controller
    historyPreviewController = [[HistoryPreviewController alloc]initWithContainerController:self];
    NSAssert(historyPreviewController, @"init failed");
    
    [self addChildViewController:historyPreviewController];
    
    // give historyPreviewView to containerView to add it as subview and init the size
    [(HistoryContainerView*)self.view setUpPreivewView:(HistoryPreviewView*)historyPreviewController.view];
    
    // create and init historyBarController
    historyBarController = [[HistoryBarController alloc]initWithContainerController:self];
    NSAssert(historyBarController, @"init failed");
    
    [self addChildViewController:historyBarController];
    
    // give historyBarView to containerView to add it as subview and init the size
    [(HistoryContainerView*)self.view setUpHistoryBar:(HistoryBarView*)historyBarController.collectionView];
}

- (NSInteger)getTotalNumberOfData {
    return [[MetricsHistoryDataCenter instance] getTotalNumberOfData];
}

- (CGFloat)mapValue:(double)input inputMin:(double)input_start inputMax:(double)input_end outputMin:(double)output_start outputMax:(double)output_end {
    if (input_start == input_end) {
        return (output_start + output_end)/2.0;
    } else {
        double slope = 1.0 * (output_end - output_start) / (input_end - input_start);
        return output_start + slope * (input - input_start);
    }
}

- (NSDictionary*)getDataPointPosForDisplayedMetricsAtTimeIndex:(NSInteger)index {
    NSMutableDictionary<NSNumber*,NSNumber*>* dic = [NSMutableDictionary dictionary];
    
    for (NSNumber* metricName in [MetricsConfigs instance].metricsDisplayedInOrder) {
        NSNumber* rawValue = [[[MetricsHistoryDataCenter instance] getMetricsDataAtTimeIndex:index].metricsValues objectForKey:metricName];
        CGFloat displayPos = [self mapValue:[rawValue doubleValue]
                                   inputMin:[[[MetricsHistoryDataCenter instance].minValueDic objectForKey:metricName]doubleValue]
                                   inputMax:[[[MetricsHistoryDataCenter instance].maxValueDic objectForKey:metricName]doubleValue]
                                  outputMin:0.0
                                  outputMax:1.0];
        [dic setObject:[NSNumber numberWithFloat:displayPos] forKey:metricName];
    }
    
//    return [[MetricsHistoryDataCenter instance] getMetricsDataAtTimeIndex:index].metricsValues;
    return dic;
}

- (NSString*)getPreviewImagePathForIndex:(NSInteger)index {
    return [[MetricsHistoryDataCenter instance]getMetricsDataAtTimeIndex:index].previewImagePath;
}

- (void)showPreviewForIndex:(NSInteger)index {
    [historyPreviewController showPreviewAtIndex:index];
}

- (void)newEntryAppendedInDataCenter {
    [historyBarController appendNewEntryIfAvailable];
    if (historyPreviewController.currentIndex == [[MetricsHistoryDataCenter instance]getTotalNumberOfData] - 1) {
        // the entry added is exactly the one currenly displaying. Refresh preview.
        [historyPreviewController refreshCurrentPreview];
    }
}

@end
