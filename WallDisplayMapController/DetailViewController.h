//
//  DetailViewController.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

- (void)addElement:(UIView *)vElement;
- (CGPoint)getCenterOfLastEmptyPosition;

@end
