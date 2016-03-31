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
#import "HistoryRenderRef.h"
#import "MetricNameTypeDef.h"
#import "MetricsHistoryDataCenter.h"

@interface HistoryBarController ()

@end

@implementation HistoryBarController
{
    UIViewController* containerController;
    NSMutableArray* savesArray;
}
static NSString* const reuseIdentifier = @"Cell";

- (instancetype) initWithContainerController: (UIViewController*) hcvc {
    HistoryBarLayout *flowLayout = [[HistoryBarLayout alloc]init];
    self = [super initWithCollectionViewLayout:flowLayout];
    NSAssert(self, @"init failed");
    
    containerController = hcvc;
    savesArray = [[NSMutableArray alloc]init];
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [HistoryRenderRef getHistoryBarOriginalHeight])];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    // setup history bar
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    
    HistoryBarView* historyBarView = [[HistoryBarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [HistoryRenderRef getHistoryBarOriginalHeight]) collectionViewLayout:layout myDelegate:self];
    
    self.collectionView = historyBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[HistoryBarCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // add plans into the history bar
    [self loadSaves];
}

- (void)loadSaves {
    [self.collectionView performBatchUpdates:^{
        
        // get save files and save them into saveArray
        NSMutableArray* indexPaths = [[NSMutableArray alloc]init];
        for (int i = 0; i < [[MetricsHistoryDataCenter sharedInstance] getTotalNumberOfData]; i++) {
            [savesArray insertObject:[[MetricsHistoryDataCenter sharedInstance] getMetricsDataAtTimeIndex:i] atIndex:i];
            [indexPaths insertObject:[NSIndexPath indexPathForItem:i inSection:0] atIndex:i];
        }
        
        // insert cells
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
    } completion:nil];
}

- (void)setHistoryBarHeight:(CGFloat)height withAnimationDuration:(CGFloat)d {
    // set bar height
    [UIView animateWithDuration:d animations:^(void){
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x,
                                               self.collectionView.frame.origin.y,
                                               self.collectionView.frame.size.width,
                                               height);
        [self.collectionView performBatchUpdates:nil completion:nil];
        [self.collectionView performBatchUpdates:nil completion:nil]; // I couldn't figure out why I need to call this twice for the animation to work correctly...
    }];
}

- (void)cellCenteredByIndex:(NSIndexPath*) index {
//    NSLog(@"cell centered: #%d", index.item);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return savesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryBarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSInteger thisIndex = indexPath.row;
    
    if (thisIndex > 0 && thisIndex < savesArray.count-1) {
        // have both prev cell and next cell
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex]
            prevMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex - 1]
              prevAbsHorizontalDistance:[HistoryRenderRef getCellDefaultWidth] // assume no selection by default for now. same for the two cases below
            nextMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex + 1]
              nextAbsHorizontalDistance:[HistoryRenderRef getCellDefaultWidth]];
    } else if (thisIndex > 0) {
        // prev cell only
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex]
            prevMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex - 1]
              prevAbsHorizontalDistance:[HistoryRenderRef getCellDefaultWidth]];
    } else if (thisIndex < savesArray.count-1) {
        // next cell only
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex]
            nextMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex + 1]
              nextAbsHorizontalDistance:[HistoryRenderRef getCellDefaultWidth]];
    } else {
        // only one cell
        [cell initForReuseWithTimeStamp:[NSDate date]
                                    tag:@"test tag"
                              flagOrNot:NO // TODO not testing flag yet
            thisMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex]];
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
