//
//  MetricPickerDelegate.h
//  
//
//  Created by Jialiang Xiang on 2016-04-30.
//
//

#import <Foundation/Foundation.h>

@protocol MetricPickerDelegate <NSObject>

@required
- (void)showPickerViewController:(UIViewController*)pvc fromView:(UIView*)v;

@end
