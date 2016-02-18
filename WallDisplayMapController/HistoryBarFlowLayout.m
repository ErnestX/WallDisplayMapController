//
//  HistoryBarFlowLayout.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarFlowLayout.h"

#define CELL_WIDTH 100

@implementation HistoryBarFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
        float sideInset = [UIScreen mainScreen].bounds.size.width/2 - CELL_WIDTH/2; // so that at the left/right edge, the middle of the first/last cell is at the center of the screen
        self.sectionInset = UIEdgeInsetsMake(0, sideInset, 0, sideInset);

    }
    
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in attributesArr) {
        [self applyLayoutAttributes:attributes];
    }
    
    return attributesArr;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyLayoutAttributes:attributes];
    return attributes;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes*)attributes {
    if (attributes.representedElementKind == nil) {
        // this is a cell, not a header or decoration view
        CGFloat xPos = self.sectionInset.left + attributes.indexPath.item * CELL_WIDTH;
        attributes.frame = CGRectMake(xPos, 0.0, CELL_WIDTH, [self collectionView].frame.size.height);
        // align with pixels
        attributes.frame = CGRectIntegral(attributes.frame);
    }
}

@end
