//
//  HistoryBarFlowLayout.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarLayout.h"

#define CELL_WIDTH 100

@implementation HistoryBarLayout
{
    NSInteger cellCount;
    CGFloat sideInset;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    sideInset = self.collectionView.frame.size.width/2 - CELL_WIDTH/2; // so that at the left/right edge, the middle of the first/last cell is at the center of the screen
    cellCount = [self.collectionView numberOfItemsInSection:0];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(cellCount * CELL_WIDTH + sideInset*2, self.collectionView.frame.size.height);
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = CGRectMake(sideInset + CELL_WIDTH*(indexPath.item), 0.0, CELL_WIDTH, self.collectionView.frame.size.height);
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributesArr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributesArr;
}

@end
