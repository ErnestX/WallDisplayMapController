//
//  GlobalUtilities.h
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryFilePathConfigs : NSObject

+ (nonnull NSString*)getAbsPathToDocFolder;
+ (nonnull NSString*)getAbsPathGivenPathRelativeToDocFolder:(nonnull NSString*)path;
+ (nonnull NSString*)getAbsPathToScreenshotFolder;
+ (nonnull NSString*)getScreenshotFileNameGivenIndex:(NSInteger)index;
+ (nonnull NSString*)getAbsPathToScreenshotFileGivenIndex:(NSInteger)index;
+ (nonnull NSString*)getAbsPathToMetricsDataCodedFile;

@end
