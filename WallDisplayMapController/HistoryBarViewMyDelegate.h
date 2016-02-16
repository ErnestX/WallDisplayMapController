//
//  HistoryBarViewMyDelegate.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-15.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryBarViewMyDelegate <NSObject>

@required
- (void)cellCenteredByIndex:(NSIndexPath*) index;

@end
