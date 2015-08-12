//
//  InfoLabel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-08-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "InfoLabel.h"

@implementation InfoLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 20, 20)];
    [UIColor.lightGrayColor setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(0, 0, 20, 20);
    {
        NSString* textContent = @"i";
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 15], NSForegroundColorAttributeName: UIColor.lightGrayColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }

}


@end
