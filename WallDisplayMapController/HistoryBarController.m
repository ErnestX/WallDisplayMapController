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
#import "HistoryBarGlobalManager.h"

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
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [HistoryBarGlobalManager getHistoryBarOriginalHeight])];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    // setup history bar
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    
    HistoryBarView* historyBarView = [[HistoryBarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [HistoryBarGlobalManager getHistoryBarOriginalHeight]) collectionViewLayout:layout myDelegate:self];
    
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
        
        // get save files and save them into saveArray (stub)
        srand48(arc4random()); // set random seed
        NSMutableArray* indexPaths = [[NSMutableArray alloc]init];
        for (int i = 0; i < 50; i++) {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:i/50.0], @"metric1",
                                 [NSNumber numberWithFloat:i/60.0], @"metric2",
                                 [NSNumber numberWithFloat:drand48()], @"metric3", nil]; // stub
            [savesArray insertObject:dic atIndex:i];
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
    [cell initForReuseWithTimeStamp:[NSDate date]
                                tag:@"tag"
                          flagOrNot:NO
        thisMetricNamePositionPairs:[savesArray objectAtIndex:thisIndex]
        prevMetricNamePositionPairs:(thisIndex-1 < 0 ? nil : [savesArray objectAtIndex: thisIndex - 1])
        nextMetricNamePositionPairs:(thisIndex+1 > savesArray.count-1 ? nil : [savesArray objectAtIndex: thisIndex + 1])];
    
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
