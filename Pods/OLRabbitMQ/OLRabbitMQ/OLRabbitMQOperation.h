/******************************************************************************
 *
 *  2015 (C) Copyright Open-RnD Sp. z o.o.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "OLRabbitMQError.h"
#import "OLRabbitMQSocket.h"
#import "OLRabbitMQManager.h"

// Include header system
#include <string.h>
#include <stdio.h>
#include <stdint.h>

@class OLRabbitMQError;
@protocol OLRabbitMQOperationDelegate <NSObject>

- (void)amqpResponse:(NSData *)data routingKey:(NSString *)routingKey;

@end

@interface OLRabbitMQOperation : NSOperation

@property (atomic) OLRabbitMQSocket *socket;
@property (weak, atomic) id<OLRabbitMQOperationDelegate> delegate;
@property (atomic, readonly) BOOL running;

- (instancetype)initWithSocket:(OLRabbitMQSocket *)aSocket;

@end

