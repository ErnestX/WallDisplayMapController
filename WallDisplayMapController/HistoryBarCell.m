//
//  HistoryBarCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarCell.h"
#define GREY_LINE_THICKNESS 2
#define TIMESTAMP_HEIGHT 5
#define TAG_VIEW_HEIGHT 10
#define TAG_VIEW_SIDE_MARGIN 2

@implementation HistoryBarCell

UIView* timeStampLabel;
UIView* greyLineView;
UIView* tagView;
NSMutableArray <UIView*>* metricViews;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0; // the border is within the bound (inset)
    
    // add the grey line
    greyLineView = [[UIView alloc]initWithFrame:CGRectMake(self.center.x - GREY_LINE_THICKNESS/2, 0, GREY_LINE_THICKNESS, self.frame.size.height)];
    greyLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:greyLineView];
    
    // add the tag view
    tagView = [[UIView alloc]initWithFrame:CGRectMake(TAG_VIEW_SIDE_MARGIN, self.frame.size.height - TIMESTAMP_HEIGHT - TAG_VIEW_HEIGHT, self.frame.size.width - TAG_VIEW_SIDE_MARGIN*2, TAG_VIEW_HEIGHT)];
    tagView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:tagView];
    
    return self;
}

- (void)initForReuseWithTimeStamp:(NSDate*) time tag:(NSString*)tag flagOrNot:(BOOL)flag metricNamePositionPairs:(NSDictionary*) metricData {
    
    // add the timeStamp label
    
    // add the graph views, one for each metric, overlapping on top of each other
    
    // add the lines in each graph view
    
    // add the dots and icons in each graph view
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
