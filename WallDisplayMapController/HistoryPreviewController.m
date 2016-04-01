//
//  HistoryPreviewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryPreviewController.h"
#import "HistoryPreviewView.h"
#import "HistoryContainerViewController.h"

@implementation HistoryPreviewController {
    HistoryContainerViewController* containerController;
}

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init preview view
    HistoryPreviewView* previewView = [[HistoryPreviewView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];
    self.view = previewView;
}

@end
