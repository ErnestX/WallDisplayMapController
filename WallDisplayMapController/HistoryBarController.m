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
    savesArray = [NSMutableArray array];
    
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
    // stub
    [self.collectionView performBatchUpdates:^{
        for (int i = 0; i < 50; i++) {
            [savesArray insertObject:@"arrayFiller" atIndex:0];
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
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
    srand48(arc4random());
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:drand48()], @"metric1",
                         [NSNumber numberWithFloat:drand48()], @"metric2",
                         [NSNumber numberWithFloat:drand48()], @"metric3", nil]; // stub
    
    [cell initForReuseWithTimeStamp:[NSDate date] tag:@"tag" flagOrNot:NO metricNamePositionPairs:dic];
    
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
