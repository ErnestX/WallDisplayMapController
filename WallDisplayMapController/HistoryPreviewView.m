//
//  HistoryPreviewView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-01.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryPreviewView.h"

@implementation HistoryPreviewView {
    UIImageView* imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 5.0; // the border is within the bound (inset)
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:imageView];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

- (void)showImage:(UIImage *)image {
    imageView.image = image;
}

@end
