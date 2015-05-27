//
//  EarthControlRequest.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-05-22.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "EarthControlRequest.h"

@interface EarthControlRequest()

@property NSMutableDictionary *dictBody;
@property NSMutableArray *arrKeyValuePairs;

@end

@implementation EarthControlRequest

- (instancetype)init {
    self = [super init];
    if (self){
        self.dictBody = [NSMutableDictionary dictionary];
        self.arrKeyValuePairs = [NSMutableArray arrayWithCapacity:10];
        
        [self.dictBody setValue:@"root" forKey:@"kvpairs"];
        [self.dictBody setValue:self.arrKeyValuePairs forKey:@"keyvaluepair"];
        
    }
    return self;
}

// add a key-value pair to the xml dictionary
- (void)addKey:(NSString *)key withValue:(NSString *)value {
    NSDictionary *dictKV = @{@"key" : key, @"value" : value};
    [self.arrKeyValuePairs addObject:dictKV];
}

// converts the XMLDictionary to an NSString object
- (NSString *)toString {
    NSString *strHead = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
    [self addKey:@"origin" withValue:@"ios"];
    [self addKey:@"command" withValue:@"look-at"];
    NSString *strXML = [NSString stringWithFormat:@"%@%@", strHead, self.dictBody.XMLString];
    return strXML;
}

@end
