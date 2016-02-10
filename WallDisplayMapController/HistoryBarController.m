//
//  HistoryBarController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryContainerViewController.h"
#import "HistoryBarController.h"
#import "HistoryBarView.h"
#import "HistoryBarCell.h"

#define CELL_WIDTH 100

@interface HistoryBarController ()

@end

@implementation HistoryBarController

static NSString* const reuseIdentifier = @"Cell";

HistoryContainerViewController* containerController;

NSMutableArray* savesArray;


- (instancetype) initWithContainerController: (HistoryContainerViewController*) hcvc {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self = [super initWithCollectionViewLayout:flowLayout];
    
    containerController = hcvc;
    savesArray = [NSMutableArray array];
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // setup history bar
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(CELL_WIDTH, self.collectionView.frame.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 500, 0, 500); // stub: let the left and right inset be 500
    
    
    HistoryBarView* historyBarView = [[HistoryBarView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    self.collectionView = historyBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[HistoryBarCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // add plans into the history bar
    [self loadSaves];
}

- (HistoryBarView*) getHistoryBar {
    return self.collectionView;
}

- (void)loadSaves {
    
    // stub
    [self.collectionView performBatchUpdates:^{
        for (int i = 0; i < 50; i++) {
            [savesArray insertObject:@"hello" atIndex:0];
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
    } completion:nil];
    
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
