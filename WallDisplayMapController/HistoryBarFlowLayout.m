//
//  HistoryBarFlowLayout.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-17.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarFlowLayout.h"

@implementation HistoryBarFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
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
    
}

@end
