//
//  RabbitMQManager.h
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-19.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RabbitMQManager : NSObject

+ (RabbitMQManager *)sharedInstance;
- (void)openRMQConnection;
- (void)closeRMQConnection;

- (void)beginConsumingWidgetsWithCallbackBlock:(void (^)(NSString *message))callbackBlock;
- (void)publishEarthControlWithBody:(NSString *)body;

- (NSString *)getIPAddress;
- (void)setIPAddress:(NSString *)ip;
- (BOOL)connected;

@end
