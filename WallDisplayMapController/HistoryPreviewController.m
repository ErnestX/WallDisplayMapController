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

- (void)showPreviewAtIndex:(NSInteger)index {
    if (index != oldIndex) {
        NSLog(@"showing image");
        NSBundle *mainBundle = [NSBundle mainBundle];
        UIImage* currentImage;
        if (index %2) {
            currentImage = [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot2" ofType:@".jpg"]];
        } else {
            currentImage = [UIImage imageWithContentsOfFile:[mainBundle pathForResource:@"testScreenShot1" ofType:@".jpg"]];
        }
        
        [(HistoryPreviewView*)self.view showImage:currentImage];
        
        oldIndex = index;
    }
}

@end
