//
//  GlobalUtilities.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryFilePathConfigs.h"

@implementation HistoryFilePathConfigs

+ (nonnull NSString*)getAbsPathToDocFolder {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (nonnull NSString*)getAbsPathGivenPathRelativeToDocFolder:(NSString*)path {
    NSString* pathToDocs = [HistoryFilePathConfigs getAbsPathToDocFolder];
    return [pathToDocs stringByAppendingPathComponent:path];
}

+ (nonnull NSString*)getAbsPathToScreenshotFolder {
    return [HistoryFilePathConfigs getAbsPathGivenPathRelativeToDocFolder:@"/screenshots"];
}

+ (nonnull NSString*)getScreenshotFileNameGivenIndex:(NSInteger)index {
    NSAssert(index >= 0, @"index is negative");
    return [NSString stringWithFormat:@"%d.png", index];
}

+ (nonnull NSString*)getAbsPathToScreenshotFileGivenIndex:(NSInteger)index {
    NSAssert(index >= 0, @"index is negative");
    NSString* fileName = [HistoryFilePathConfigs getScreenshotFileNameGivenIndex:index];
    return [[HistoryFilePathConfigs getAbsPathToScreenshotFolder]
            stringByAppendingPathComponent:fileName];
}

+ (nonnull NSString*)getAbsPathToMetricsDataCodedFile {
    NSString* fileName = @"/metricsDataCoded.dat";
    NSString* filePath = [HistoryFilePathConfigs getAbsPathGivenPathRelativeToDocFolder:fileName];
    
    return filePath;
}

@end
