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
    NSMutableArray <UIImage*>* testImagesArray;
}

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    testImagesArray = [NSMutableArray array];
    NSBundle *mainBundle = [NSBundle mainBundle];
    for (int i=0; i<50; i++) {
        UIImage* currentImage;
        if (i%2) {
            currentImage = [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"]];
        } else {
            currentImage = [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"]];
        }
        [testImagesArray addObject:currentImage];
    }
    
    oldIndex = NAN; // if you init it to 0, the first preview won't show because it thought the index hasn't changed
    
    return self;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"MEMORY WARNING RECEIVED");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init preview view
    HistoryPreviewView* previewView = [[HistoryPreviewView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];
    self.view = previewView;
}

- (void)showPreviewAtIndex:(NSInteger)index {
    if (index != oldIndex) {
        [(HistoryPreviewView*)self.view showImage:[testImagesArray objectAtIndex:index]];
        oldIndex = index;
    }
}

@end
