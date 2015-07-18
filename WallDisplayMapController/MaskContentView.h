//
//  MaskContentView.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskContentView : UIView

@property NSInteger itemIndex;

- (instancetype)initWithFrame:(CGRect)frame target:(UIViewController *)targetVC;
- (void)showContent:(NSDictionary *)data;


@end
