//
//  HintView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-08-05.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "HintView.h"
#import "Masonry.h"

@implementation HintView {
    UIView *box;
    UILabel *lblText;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        box = [[UIView alloc] initWithFrame:frame];
        
        CAShapeLayer *_border = [CAShapeLayer layer];
        _border.strokeColor = [UIColor lightGrayColor].CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = @[@4, @2];
        [self.layer addSublayer:_border];
        
        CGFloat borderInset = 30.0f;
        CGRect borderRect = CGRectMake(borderInset, borderInset, frame.size.width-borderInset*4, frame.size.height-borderInset*4);
        _border.path = [UIBezierPath bezierPathWithRect:borderRect].CGPath;
        _border.frame = borderRect;
        
        lblText = [[UILabel alloc] init];
        lblText.text = @"Please drag an indicator to this canvas.";
        lblText.textAlignment = NSTextAlignmentCenter;
        lblText.textColor = [UIColor lightGrayColor];
        lblText.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:25.0f];
        lblText.numberOfLines = 0;
        lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblText];
        
        [lblText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
    }
    return self;
}
@end
