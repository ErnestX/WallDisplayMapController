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
        // read image file from disk
        UIImage* currentImage = [UIImage imageWithContentsOfFile:[containerController getPreviewImagePathForIndex:i]];
        [imagesCache addObject:currentImage];
    }
    
    oldIndex = -1; // if you init it to 0, the first preview won't show because it thought the index hasn't changed
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

- (void)showPreviewAtIndex:(NSInteger)index {
    if (index != oldIndex) {
        // the index is new
        NSAssert(index >= 0 && index < [containerController getTotalNumberOfData], @"PreviewController: invalid index");
        
        [self fetchEntryIntoCacheIfNeeded:index];
        
        [(HistoryPreviewView*)self.view showImage:[imagesCache objectAtIndex:index]];
        oldIndex = index;
    }
}

- (void)fetchEntryIntoCacheIfNeeded:(NSInteger)index {
    if (index >= 0 && index < [containerController getTotalNumberOfData]) {
        // the index is valid
        NSLog(@"imagesCache.count = %lu", (unsigned long)imagesCache.count);
        if (imagesCache.count < index + 1) {
            // the cache is not large enough
            NSInteger numOfEntriesNeeded = index - imagesCache.count + 1;
            // fill the array with NSNull
            for (int i=0; i<numOfEntriesNeeded; i++) {
                [imagesCache addObject:(UIImage*)[NSNull null]];
            }
        }
        
        if ([[imagesCache objectAtIndex:index] isEqual:[NSNull null]]) {
            // the image requested is not in the cache.
            // Fetch image path from container controller, read the file from disk and add to the cache
            UIImage* currentImage = [UIImage imageWithContentsOfFile:[containerController getPreviewImagePathForIndex:index]];
            [imagesCache replaceObjectAtIndex:index withObject:currentImage];
        }
    }
}

- (void)refreshCacheAtIndex:(NSInteger)index {
    if (imagesCache.count >= index + 1 && ![[imagesCache objectAtIndex:index] isEqual:[NSNull null]]) {
        // the entry exists in the cache
        // Fetch image path from container controller, read the file from disk and add to the cache
        UIImage* currentImage = [UIImage imageWithContentsOfFile:[containerController getPreviewImagePathForIndex:index]];
        [imagesCache replaceObjectAtIndex:index withObject:currentImage];
    }
}

@end
