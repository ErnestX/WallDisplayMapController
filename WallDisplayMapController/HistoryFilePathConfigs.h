//
//  GlobalUtilities.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryFilePathConfigs : NSObject

+ (NSString*)getAbsFilePathToDocFolder;
+ (NSString*)getAbsFilePathGivenPathRelativeToDocFolder:(NSString*)path;
+ (NSString*)getAbsFilePathToScreenshotFolder;
+ (NSString*)getScreenshotFileNameGivenIndex:(NSInteger)index;
+ (NSString*)getAbsFilePathToScreenshotGivenIndex:(NSInteger)index;

@end
