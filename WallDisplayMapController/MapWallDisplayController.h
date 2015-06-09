//
//  MapWallDisplayController.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapWallDisplayProtocal.h"
#import <amqp.h>
#import <amqp_framing.h>
#import "amqp_tcp_socket.h"
#import "EarthControlRequest.h"
#import "MethodIntervalCaller.h"

@interface MapWallDisplayController : NSObject <MapWallDisplayProtocal>

+ (MapWallDisplayController *)sharedInstance;
- (void) openRMQConnection;
- (void) closeRMQConnection;

@end
