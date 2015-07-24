//
//  NSOperationQueue+Timeout.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-24.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (Timeout)

- (NSOperation *)addOperationWithBlock:(void (^)(NSOperation *operation))block timeout:(CGFloat)timeout timeoutBlock:(void (^)(void))timeoutBlock;

@end
