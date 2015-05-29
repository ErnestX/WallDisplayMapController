//
//  RequestSender.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-29.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EarthControlRequest.h"

typedef enum{
    tilt,
    lat,
    lon,
    range,
    heading
}LookParameter;

@interface RequestSender : NSObject

- (void)sendRequestToIncrease:(LookParameter) para ByValue:(NSString*) value;

@end
