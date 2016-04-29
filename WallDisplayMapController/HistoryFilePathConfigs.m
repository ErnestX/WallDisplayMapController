//
//  GlobalUtilities.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryFilePathConfigs.h"

@implementation HistoryFilePathConfigs

+ (NSString*)getAbsFilePathToDocFolder {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString*)getAbsFilePathGivenPathRelativeToDocFolder:(NSString*)path {
    NSString* pathToDocs = [HistoryFilePathConfigs getAbsFilePathToDocFolder];
    return [pathToDocs stringByAppendingPathComponent:path];
}

+ (NSString*)getAbsFilePathToScreenshotFolder {
    return [HistoryFilePathConfigs getAbsFilePathGivenPathRelativeToDocFolder:@"/screenshots"];
}

+ (NSString*)getScreenshotFileNameGivenIndex:(NSInteger)index {
    NSAssert(index >= 0, @"index is negative");
    return [NSString stringWithFormat:@"%d.png", index];
}

+ (NSString*)getAbsFilePathToScreenshotGivenIndex:(NSInteger)index {
    NSAssert(index >= 0, @"index is negative");
    NSString* fileName = [HistoryFilePathConfigs getScreenshotFileNameGivenIndex:index];
    return [[HistoryFilePathConfigs getAbsFilePathToScreenshotFolder]
            stringByAppendingPathComponent:fileName];
}

@end
