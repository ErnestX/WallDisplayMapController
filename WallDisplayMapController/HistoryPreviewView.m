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
        self.backgroundColor = [UIColor blackColor];
        
        
    }
    
    return self;
}

- (void)showImage:(UIImage *)image {
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:imageView];
    } else {
        imageView.image = image;
    }
}

@end
