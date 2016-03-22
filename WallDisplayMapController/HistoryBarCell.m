//
//  HistoryBarCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarCell.h"
#import "MetricView.h"

#define TIME_LABEL_FONT_SIZE 10
#define TIME_LABEL_BUTTON_MARGIN 3
#define GREY_LINE_THICKNESS 2
#define TIMESTAMP_HEIGHT 5
#define TAG_VIEW_HEIGHT 30
#define TAG_VIEW_WIDTH 68

@implementation HistoryBarCell
{
    UILabel* timeStampLabel;
    UIView* greyLineView;
    UIView* tagView;
    NSMutableArray <UIView*>* metricViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    
    metricViews = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 1.0; // the border is within the bound (inset)
    
    // add the time stamp label
    timeStampLabel = [UILabel new];
    NSAssert(timeStampLabel, @"init failed");
    [self.contentView addSubview:timeStampLabel];
    
    timeStampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray <NSLayoutConstraint*>* timeStampConstraints = [[NSMutableArray alloc]init];
    [timeStampConstraints addObject:[NSLayoutConstraint constraintWithItem:timeStampLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-1*TIME_LABEL_BUTTON_MARGIN]];
    [timeStampConstraints addObject:[NSLayoutConstraint constraintWithItem:timeStampLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [NSLayoutConstraint activateConstraints:timeStampConstraints];
    
    
    // add the grey line
    greyLineView = [UIView new];
    NSAssert(greyLineView, @"init failed");
    greyLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:greyLineView];
    greyLineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray <NSLayoutConstraint*>* greyLineConstraints = [[NSMutableArray alloc]init];
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [greyLineConstraints addObject:[NSLayoutConstraint constraintWithItem:greyLineView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:timeStampLabel
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0.0]];
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
                                                                 constant:0.0]];
    [NSLayoutConstraint activateConstraints:greyLineConstraints];
    
    
    // add the tag view
    tagView = [UIView new];
    NSAssert(tagView, @"init failed");
    tagView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:tagView];
    tagView.translatesAutoresizingMaskIntoConstraints = NO;
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
                                                                constant:0.0]];
    [tagViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tagView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:greyLineView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0.0]];
    [NSLayoutConstraint activateConstraints:tagViewConstraints];
    
    
    return self;
}

- (void)initForReuseWithTimeStamp:(nonnull NSDate*) time tag:(nonnull NSString*)tag flagOrNot:(BOOL)flag metricNamePositionPairs:(nonnull NSDictionary*) metricData {
    
    // set the timeStamp label
    NSDateFormatter* formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSAssert(timeStampLabel,@"timeStampLabel is nil");
    timeStampLabel.text = [formatter stringFromDate:time];
    timeStampLabel.font = [timeStampLabel.font fontWithSize:TIME_LABEL_FONT_SIZE];
    [timeStampLabel sizeToFit];
    
    // add the metric views, one for each metric, overlapping on top of each other
    for (NSString* key in metricData) {
        id value = [metricData objectForKey:key];
        
        // validate key and value
        NSAssert([key isKindOfClass:[NSString class]], @"key is not a string"); // TODO: check if name is valid
        NSAssert([value isKindOfClass:[NSNumber class]], @"value is not a NSNumber");
        
        CGFloat floatV = [(NSNumber*)value floatValue];
        NSAssert(floatV >= 0.0 && floatV <= 1.0, @"value smaller than 0 or greater than 1");
        
        // create a new MetricView, init with key and value
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        MetricView* mv = [[MetricView new]initWithMetricName:key position:floatV color:color]; // TODO not testing lines yet
        [self addSubview:mv];
        
        // set auto layout with percentage in height for the expanding view
        mv.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray <NSLayoutConstraint*>* metricViewConstraints = [[NSMutableArray alloc]init];
        [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.0]];
        [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterY // TODO
                                                                     multiplier:1.0 // TODO
                                                                       constant:0.0]]; // TODO
        
        [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0]];
        [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeHeight
                                                                     multiplier:1.0
                                                                       constant:0.0]];
        [NSLayoutConstraint activateConstraints:metricViewConstraints];
        
        // add the MetricView to the array
        [metricViews addObject:mv];
    }
    
//    // enumerate the MetricView array and add them one by one as subview
//    for (int i=0; i<[metricViews count]; i++) {
//        [self addSubview:[metricViews objectAtIndex:i]];
//    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // remove the graphs
}

@end
