//
//  HistoryBarView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-01-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarView.h"
#define SCROLL_SPEED_TRACKING_INTERVAL 0.1
#define MIN_SCROLL_SPEED_BEFORE_SNAPING 50

@implementation HistoryBarView
CGPoint lastScrollOffset;
NSTimeInterval lastTrackedTime;
bool trackingSpeed;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.delegate = self;
    self.decelerationRate = 100;
    self.backgroundColor = [UIColor lightGrayColor];
    
    lastScrollOffset = CGPointZero;
    lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
    trackingSpeed = false;
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // move the scroll bar to the top
    self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, frame.size.height - 10, 0);\
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"Dragging ends");
    
    if (decelerate) {
        // initialize speed tracking vars
        lastScrollOffset = self.contentOffset;
        lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
        
        // start speed tracking
        trackingSpeed = true;
        
        [self trackSpeedAndSnap];
    } else {
        [self snapToClosestCell];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self trackSpeedAndSnap];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"end decelerating");
    [self snapToClosestCell];
}

/*
 * calc speed and decide whether the speed is low enough to snap
 * needs trackingSpeed = true to work
 * also needs initialization of lastTrackedTime and lastScrollOffset before being called and after the deceleration taking place
 */
- (void)trackSpeedAndSnap {
    if (trackingSpeed) {
        // measure speed
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval timeDiff = currentTime - lastTrackedTime;
        float distanceScrolled = self.contentOffset.x - lastScrollOffset.x; // positive: scrolled right; negiative: scrolled left
            
        if (timeDiff > 0.05 && distanceScrolled / timeDiff < MIN_SCROLL_SPEED_BEFORE_SNAPING) {
            // too slow: stop tracking
            trackingSpeed = false;
            // snap
            [self snapToClosestCell];
        }
        
        lastScrollOffset = self.contentOffset;
        lastTrackedTime = [NSDate timeIntervalSinceReferenceDate];
    }
}

- (void)snapToClosestCell {
    NSLog(@"snapToClosestCell");

    NSIndexPath* indexOfCenterCell = [self indexPathForItemAtPoint:CGPointMake(self.center.x + self.contentOffset.x,
                                                                               self.center.y + self.contentOffset.y)];
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexOfCenterCell];
    float realXPos = attributes.center.x - self.contentOffset.x;
    float distanceToScroll = realXPos - self.center.x;

//    NSLog(@"Section: %d, Row: %d", indexOfCenterCell.section, indexOfCenterCell.row);
//    NSLog(@"%f", attributes.center.x);

    CGPoint newContentOffset = CGPointMake(self.contentOffset.x + distanceToScroll, 0);
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self setContentOffset:newContentOffset];
    } completion:nil];
}

@end
