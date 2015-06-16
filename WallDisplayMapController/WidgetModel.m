//
//  WidgetModel.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "WidgetModel.h"

@implementation WidgetModel

- (WidgetModel *)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.dictModel = dict;
    }
    return self;
}

@end
