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
#define TAG_VIEW_HEIGHT 50
//#define TAG_VIEW_SIDE_MARGIN 2
#define TAG_VIEW_WIDTH 90

@implementation HistoryBarCell
{
    UIView* timeStampLabel;
    UIView* greyLineView;
    UIView* tagView;
    NSMutableArray <UIView*>* metricViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0; // the border is within the bound (inset)
    
    // add the grey line
    greyLineView = [UIView new];
    greyLineView.translatesAutoresizingMaskIntoConstraints = NO;
    greyLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:greyLineView];
    
    NSMutableArray <NSLayoutConstraint*>* greyLineConstraints = [[NSMutableArray alloc]init];
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0]];
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-1*TIMESTAMP_HEIGHT]]; //TODO refactor after drawing time lable first
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:GREY_LINE_THICKNESS]];
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0]];
    [NSLayoutConstraint activateConstraints:greyLineConstraints];
    
    // add the tag view
//    tagView = [[UIView alloc]initWithFrame:CGRectMake(TAG_VIEW_SIDE_MARGIN, self.contentView.frame.size.height - TIMESTAMP_HEIGHT - TAG_VIEW_HEIGHT, self.contentView.frame.size.width - TAG_VIEW_SIDE_MARGIN*2, TAG_VIEW_HEIGHT)];
    tagView = [UIView new];
    tagView.translatesAutoresizingMaskIntoConstraints = NO;
    tagView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:tagView];
    NSMutableArray <NSLayoutConstraint*>* tagViewConstraints = [[NSMutableArray alloc]init];
    [tagViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tagView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:TAG_VIEW_WIDTH]];
    [tagViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tagView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:TAG_VIEW_HEIGHT]];
    [tagViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tagView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0]];
    [tagViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tagView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:greyLineView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0]];
    [NSLayoutConstraint activateConstraints:tagViewConstraints];
    
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
