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

@interface HistoryPreviewController()
@property (readwrite) NSInteger currentIndex;
@end

@implementation HistoryPreviewController {
    HistoryContainerViewController* containerController;
    NSMutableArray <UIImage*>* imagesCache;
}

- (instancetype)initWithContainerController:(HistoryContainerViewController*)hcvc {
    self = [super init];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    
    // load all available preview images into cache
    imagesCache = [NSMutableArray array];
    for (int i=0; i<[containerController getTotalNumberOfData]; i++) {
        // read image file from disk
        UIImage* currentImage = [UIImage imageWithContentsOfFile:[containerController getPreviewImagePathForIndex:i]];
        [imagesCache addObject:currentImage];
    }
    
    self.currentIndex = 0;
    return self;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"MEMORY WARNING RECEIVED");
    //clear cache
    for (int i = 0; i<imagesCache.count; i++) {
        [imagesCache replaceObjectAtIndex:i withObject:(UIImage*)[NSNull null]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create and init preview view
    HistoryPreviewView* previewView = [[HistoryPreviewView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];
    self.view = previewView;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
    if ([containerController getTotalNumberOfData]>0) {
        [self refreshCurrentPreview];
    }
}

- (void)showPreviewAtIndex:(NSInteger)index {
    [self showPreviewAtIndex:index forceRefetchImageFromCache:NO];
}

- (void)showPreviewAtIndex:(NSInteger)index forceRefetchImageFromCache:(BOOL)frifc {
    NSAssert(index >= 0 && index < [containerController getTotalNumberOfData], @"PreviewController: invalid index");
    
    BOOL condition;
    if (frifc) {
        condition = YES;
    } else {
        condition = (index != self.currentIndex); // the index is new
    }
    
    if (condition) {
        [self fetchEntryIntoCache:index overwriteExistingEntry:NO];
        
        [(HistoryPreviewView*)self.view showImage:[imagesCache objectAtIndex:index]];
        
        self.currentIndex = index;
    }
}

/*
 may be much slower if use the overwrite option
 */
- (void)fetchEntryIntoCache:(NSInteger)index overwriteExistingEntry:(BOOL)oee {
    if (index >= 0 && index < [containerController getTotalNumberOfData]) {
        // the index is valid
        if (imagesCache.count < index + 1) {
            // the cache is not large enough
            NSInteger numOfEntriesNeeded = index - imagesCache.count + 1;
            // fill the array with NSNull
            for (int i=0; i<numOfEntriesNeeded; i++) {
                [imagesCache addObject:(UIImage*)[NSNull null]];
            }
        }
        
        BOOL condition;
        if (oee) {
            condition = YES;
        } else {
            condition = [[imagesCache objectAtIndex:index] isEqual:[NSNull null]]; // the image requested is not in the cache.
        }
        
        if (condition) {
            // Fetch image path from container controller, read the file from disk and add to the cache
            UIImage* currentImage = [UIImage imageWithContentsOfFile:[containerController getPreviewImagePathForIndex:index]];
            [imagesCache replaceObjectAtIndex:index withObject:currentImage];
        }
    }
}

- (void)refreshCurrentPreview {
    NSLog(@"refreshing index %d", self.currentIndex);
    [self fetchEntryIntoCache:self.currentIndex overwriteExistingEntry:YES];
    [self showPreviewAtIndex:self.currentIndex forceRefetchImageFromCache:YES];
}

@end
