//
//  DeleteButton.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-30.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DeleteButton.h"

@implementation DeleteButton

-(void)drawRect:(CGRect)rect {
    //// Group
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 20, 20)];
        [UIColor.lightGrayColor setFill];
        [ovalPath fill];
        //// Group 2
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(12.62, 7.38)];
            [bezierPath addCurveToPoint: CGPointMake(6.87, 13.13) controlPoint1: CGPointMake(6.98, 13.02) controlPoint2: CGPointMake(6.87, 13.13)];
            bezierPath.lineCapStyle = kCGLineCapRound;
            bezierPath.lineJoinStyle = kCGLineJoinRound;
            [UIColor.grayColor setFill];
            [bezierPath fill];
            [UIColor.whiteColor setStroke];
            bezierPath.lineWidth = 1.5;
            [bezierPath stroke];
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(6.87, 7.38)];
            [bezier2Path addCurveToPoint: CGPointMake(12.62, 13.13) controlPoint1: CGPointMake(12.51, 13.02) controlPoint2: CGPointMake(12.62, 13.13)];
            bezier2Path.lineCapStyle = kCGLineCapRound;
            bezier2Path.lineJoinStyle = kCGLineJoinRound;
            [UIColor.whiteColor setStroke];
            bezier2Path.lineWidth = 1.5;
            [bezier2Path stroke];
        }
    }
}


@end
