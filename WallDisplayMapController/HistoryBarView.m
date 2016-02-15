//
//  HistoryBarView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarView.h"
#import <pop/POP.h>

#define SPEED_TRACK_INTERVAL 0.05
#define MIN_SCROLL_SPEED_BEFORE_SNAPING 50


@implementation HistoryBarView
CGPoint lastScrollOffset;
NSTimeInterval lastTrackedTime;
bool readyToSnap;
POPBasicAnimation* snappingAnimaiton;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.delegate = self;
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.backgroundColor = [UIColor lightGrayColor];
    
    lastScrollOffset = CGPointZero;
    lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
    readyToSnap = false;
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // move the scroll bar to the top
    self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, frame.size.height - 6, 0);\
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"Dragging ends");
    
    if (decelerate) {
        // initialize speed tracking vars
        lastScrollOffset = self.contentOffset;
        lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
        
        // start speed tracking
        readyToSnap = true;
        
        [self trackSpeedAndSnap];
    } else {
        [self snapToClosestCell];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self trackSpeedAndSnap];
}

/*
 * calc speed and decide whether the speed is low enough to snap
 * needs trackingSpeed = true to work
 * also needs initialization of lastTrackedTime and lastScrollOffset before being called and after the deceleration taking place
 */
- (void)trackSpeedAndSnap {
    if (readyToSnap) {
        // measure speed
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval timeDiff = currentTime - lastTrackedTime;
        float distanceScrolled = self.contentOffset.x - lastScrollOffset.x; // positive: scrolled right; negiative: scrolled left
        float speed = distanceScrolled / timeDiff;
//        NSLog(@"timeDiff: %f, speed: %f", timeDiff, speed);
        
        if (timeDiff > SPEED_TRACK_INTERVAL) {
            // check speed every SPEED_TRACK_INTERVAL secs
            if (fabsf(speed) < MIN_SCROLL_SPEED_BEFORE_SNAPING) {
                // too slow: stop tracking
                readyToSnap = false;
                // snap
                NSLog(@"slow enough to snap");
                [self snapToClosestCell];
            }
            // reset only after each speed check
            lastScrollOffset = self.contentOffset;
            lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began");
    readyToSnap = false;
    [snappingAnimaiton pop_removeAllAnimations];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (readyToSnap) {
        [self snapToClosestCell];
    }
}

- (void)snapToClosestCell {
    NSLog(@"snapToClosestCell");

    NSIndexPath* indexOfCenterCell = [self indexPathForItemAtPoint:CGPointMake(self.center.x + self.contentOffset.x,
                                                                               self.center.y + self.contentOffset.y)];
    if (!indexOfCenterCell) {
        if (self.contentOffset.x < 0) {
            indexOfCenterCell = [NSIndexPath indexPathForItem:0 inSection:0];
        } else {
            indexOfCenterCell = [NSIndexPath indexPathForItem:[self numberOfItemsInSection:0]-1 inSection:0];
        }
    }
    
    [self snapToCellAtIndexPath:indexOfCenterCell];
}

- (void)snapToCellAtIndexPath:(NSIndexPath*) index {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:index];
    float realXPos = attributes.center.x - self.contentOffset.x;
    float distanceToScroll = realXPos - self.center.x;
    
    CGPoint newContentOffset = CGPointMake(self.contentOffset.x + distanceToScroll, 0);
    [self snapToOffset:newContentOffset];
}

- (void)snapToOffset:(CGPoint)offset {
    snappingAnimaiton = [POPBasicAnimation animationWithPropertyNamed:kPOPCollectionViewContentOffset];
    snappingAnimaiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    snappingAnimaiton.fromValue = [NSValue valueWithCGPoint:self.contentOffset];
    snappingAnimaiton.toValue = [NSValue valueWithCGPoint:offset];
    [self pop_addAnimation:snappingAnimaiton forKey:@"snap"];
}

@end
