//
//  HistoryBarController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarController.h"
#import "HistoryBarCell.h"
#import "HistoryBarLayout.h"
#import "GlobalLayoutRef.h"
#import "MetricsConfigs.h"
#import "HistoryBarView.h"
#import "HistoryContainerViewController.h"

#define HISTORY_BAR_INIT_HEIGHT 50.0 // this have nothing to do with the actual height displayed, since it will be reset by the HistoryContainerView. However, this value should be large enough so that the initalization (especially auto-layout) can succeed

@interface HistoryBarController ()

@end

@implementation HistoryBarController
{
    HistoryContainerViewController* containerController;
    NSInteger totalNumberOfCells;
}
static NSString* const reuseIdentifier = @"Cell";

- (instancetype) initWithContainerController: (HistoryContainerViewController*) hcvc {
    HistoryBarLayout *flowLayout = [[HistoryBarLayout alloc]init];
    self = [super initWithCollectionViewLayout:flowLayout];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;

    totalNumberOfCells = 0;
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HISTORY_BAR_INIT_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    // setup history bar (height is set by HistoryContainerView later)
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    
    HistoryBarView* historyBarView = [[HistoryBarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HISTORY_BAR_INIT_HEIGHT) collectionViewLayout:layout myDelegate:self];
    
    self.collectionView = historyBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[HistoryBarCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // add all existing plans into the history bar
    [self.collectionView performBatchUpdates:^{
        
        // get save files and save them into saveArray
        NSMutableArray* indexPaths = [[NSMutableArray alloc]init];
        for (int i = 0; i < [containerController getTotalNumberOfData]; i++) {
            totalNumberOfCells++;
            [indexPaths insertObject:[NSIndexPath indexPathForItem:i inSection:0] atIndex:i];
        }
        
        // insert cells
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
    } completion:nil];
}

- (void)cellCenteredByIndex:(NSIndexPath*) index {
    if (index) { // index would be nil if no cell applies
        //    NSLog(@"cell centered: #%d", index.item);
        [containerController showPreviewForIndex:index.item];
    }
}

- (void)appendNewEntryIfAvailable {
    if([containerController getTotalNumberOfData] > totalNumberOfCells) {
        NSInteger newIndex = totalNumberOfCells;
        
        [self.collectionView performBatchUpdates:^{
            NSMutableArray* indexPaths = [[NSMutableArray alloc]init];
            totalNumberOfCells++;
            [indexPaths addObject:[NSIndexPath indexPathForItem:newIndex inSection:0]];
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL b){
            if (newIndex > 0) {
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:newIndex-1 inSection:0]]];
            }
        }];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return totalNumberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryBarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSInteger thisIndex = indexPath.item;
    
    if (thisIndex > 0 && thisIndex < totalNumberOfCells-1) {
        // have both prev cell and next cell
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex]
            prevMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex - 1]
              prevAbsHorizontalDistance:[[GlobalLayoutRef instance] getCellDefaultWidth] // assume no selection by default for now. same for the two cases below
            nextMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex + 1]
              nextAbsHorizontalDistance:[[GlobalLayoutRef instance] getCellDefaultWidth]];
    } else if (thisIndex > 0) {
        // prev cell only
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex]
            prevMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex - 1]
              prevAbsHorizontalDistance:[[GlobalLayoutRef instance] getCellDefaultWidth]];
        } else if (thisIndex < totalNumberOfCells-1) {
        // next cell only
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex]
            nextMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex + 1]
              nextAbsHorizontalDistance:[[GlobalLayoutRef instance] getCellDefaultWidth]];
    } else {
        // only one cell
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[containerController getMetricsDisplayPositionsAtTimeIndex:thisIndex]];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
