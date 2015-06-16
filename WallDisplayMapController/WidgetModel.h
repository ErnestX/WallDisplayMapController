//
//  WidgetModel.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-12.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetModel : NSObject

@property NSDictionary *dictModel;

- (WidgetModel *)initWithDictionary:(NSDictionary *)dict;

@end
