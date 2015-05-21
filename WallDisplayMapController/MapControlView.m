//
//  MapControl.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapControlView.h"

@implementation MapControlView {
    id <MapWallDisplayProtocal> target;
}

- (BOOL) setTarget: (id <MapWallDisplayProtocal>) mapWallDisplayController
{
    if (target == nil) {
        target = mapWallDisplayController;
        return YES;
    } else {
        return NO;
    }
}

@end
