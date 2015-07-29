//
//  ThresholdChangeRequest.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-27.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThresholdChangeRequest : NSObject

- (NSString *) toString;
- (void) addKey:(NSString *)key withValue:(NSString *)value;

@end
