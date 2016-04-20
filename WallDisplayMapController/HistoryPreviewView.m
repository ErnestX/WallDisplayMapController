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
    UIScrollView* scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [UIImageView new]; // set the frame in showImage()
        imageView.backgroundColor = [UIColor blackColor];
        
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:imageView];
        [self addSubview:scrollView];
        
//        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        imageView.layer.borderWidth = 5.0; // the border is within the bound (inset)
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    scrollView.frame = [self.superview convertRect:frame toView:self]; //convert frame from superview's coord to self's coord
}

- (void)showImage:(UIImage *)image {
    imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    if (imageView.image == nil) {
        // if this is the first image displayed, center it
        scrollView.contentOffset = CGPointMake((imageView.bounds.size.width - scrollView.bounds.size.width)/2.0,
                                               (imageView.bounds.size.height - scrollView.bounds.size.height)/2.0);
    }
    imageView.image = image;
    scrollView.contentSize = imageView.frame.size;
}

@end
