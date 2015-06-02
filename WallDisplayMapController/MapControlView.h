//
//  MapControl.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapWallDisplayProtocal.h"
#import "MethodIntervalCaller.h"

@interface MapControlView : UIView <UIGestureRecognizerDelegate>

/*
 @return NO and ignore the init parameters if target already exist
 */
- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController;

- (void) showInstructions;

- (void) showLoadingMessage;

@end
