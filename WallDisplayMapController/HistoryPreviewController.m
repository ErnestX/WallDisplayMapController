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
    NSInteger oldIndex;
    NSMutableArray <UIImage*>* imagesCache;
}

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    // load all available preview images into cache
    imagesCache = [NSMutableArray array];
    for (int i=0; i<[containerController getTotalNumberOfData]; i++) {
        UIImage* currentImage = [containerController getPreviewForIndex:i];
        [imagesCache addObject:currentImage];
    }
    
    oldIndex = NAN; // if you init it to 0, the first preview won't show because it thought the index hasn't changed
    
    return self;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"MEMORY WARNING RECEIVED");
    //TODO: clear cache
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init preview view
    HistoryPreviewView* previewView = [[HistoryPreviewView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];
    self.view = previewView;
}

- (void)showPreviewAtIndex:(NSInteger)index {
    if (index != oldIndex && index >= 0 && index < [containerController getTotalNumberOfData]) {
        //TODO: if image is not in cache, fetch it from container controller
        [(HistoryPreviewView*)self.view showImage:[imagesCache objectAtIndex:index]];
        oldIndex = index;
    }
}

@end
