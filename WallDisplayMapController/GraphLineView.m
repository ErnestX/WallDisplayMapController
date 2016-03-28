//
//  GraphLineView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-03-28.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "GraphLineView.h"

@implementation GraphLineView

- (id)initWithColor:(UIColor*)color connectedToDataPointWithHeight:(CGFloat)h absHorizontalDistance:(CGFloat)d anchorPointOnRight:(BOOL)onRight{
    self = [super init];
    if (self) {
        self.connectedToDataPointWithHeight = h;
        self.absHorizontalDistance = d;
        
        if (onRight) {
            self.layer.anchorPoint = CGPointMake(1.0, 0.5); // rotates relative to the center of the right edge
        } else {
            self.layer.anchorPoint = CGPointMake(0.0, 0.5); // rotates relative to the center of the left edge
        }
        
        self.backgroundColor = color; // TODO gradient
        
        self.layer.allowsEdgeAntialiasing = YES;
    }
    return self;
}

@end
