//
//  HistoryBarView.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryBarViewMyDelegate.h"

@interface HistoryBarView : UICollectionView <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout myDelegate:(nonnull id<HistoryBarViewMyDelegate>)hbc;

@end
