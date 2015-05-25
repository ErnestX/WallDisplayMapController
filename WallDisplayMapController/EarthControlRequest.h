//
//  EarthControlRequest.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-05-22.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"

// To use this class, create an object using init, then
// add the key-value pairs using the public methods
// use toString to get the NSString representation of
// the request

@interface EarthControlRequest : NSObject

- (NSString *) toString;
- (void) addKey:(NSString *)key withValue:(NSString *)value;

@end
