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
        imageView = [UIImageView new]; // set the frame later in showImage()
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        
        [scrollView addSubview:imageView];
        [self addSubview:scrollView];
        
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = 5.0; // the border is within the bound (inset)
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    scrollView.frame = [self.superview convertRect:frame toView:self]; //convert frame from superview's coord to self's coord
}

- (void)showImage:(nonnull UIImage *)image {
    NSAssert(![image isEqual:[NSNull null]], @"argument is NSNull");

    if (imageView.image == nil) {
        // if this is the first image displayed, set frame and center the image
        imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        scrollView.contentOffset = CGPointMake((imageView.bounds.size.width - scrollView.bounds.size.width)/2.0,
                                               (imageView.bounds.size.height - scrollView.bounds.size.height)/2.0);
    }
    
    imageView.image = image;
    
    scrollView.contentSize = imageView.frame.size;
    scrollView.minimumZoomScale = MIN(self.bounds.size.width / imageView.bounds.size.width,
                                      self.bounds.size.height / imageView.bounds.size.height); // make sure the image fit the window at min scale
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)removeImage {
    imageView.image = nil;
}

@end
