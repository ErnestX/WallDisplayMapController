//
//  HistoryBarCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarCell.h"
#import "MetricView.h"
#import "MetricNameTypeDef.h"
#import "HistoryRenderRef.h"

#define TIME_LABEL_FONT_SIZE 10
#define TIME_LABEL_BUTTON_MARGIN 2
#define GREY_LINE_THICKNESS 2
#define TAG_VIEW_HEIGHT 30
#define TAG_VIEW_WIDTH 70

@implementation HistoryBarCell
{
    UILabel* timeStampLabel;
    UIView* greyLineView;
    UIView* tagView;
    NSMutableArray <MetricView*>* metricViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    
    metricViews = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor whiteColor];
    
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

- (void)initForReuseWithTimeStamp:(NSDate *)time
                              tag:(NSString *)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary *)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd
      nextMetricNamePositionPairs:(nonnull NSDictionary *)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
        thisMetricNamePositionPairs:thisMetricData
                      prevCellExist:YES
        prevMetricNamePositionPairs:prevMetricData
          prevAbsHorizontalDistance:pd
                      nextCellExist:YES
        nextMetricNamePositionPairs:nextMetricData
          nextAbsHorizontalDistance:nd];
    
}

- (void)initForReuseWithTimeStamp:(NSDate *)time
                              tag:(NSString *)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary *)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
        thisMetricNamePositionPairs:thisMetricData
                      prevCellExist:YES
        prevMetricNamePositionPairs:prevMetricData
          prevAbsHorizontalDistance:pd
                      nextCellExist:NO
        nextMetricNamePositionPairs:nil
          nextAbsHorizontalDistance:NAN];
    
}

- (void)initForReuseWithTimeStamp:(NSDate *)time
                              tag:(NSString *)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      nextMetricNamePositionPairs:(NSDictionary *)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
        thisMetricNamePositionPairs:thisMetricData
                      prevCellExist:NO
        prevMetricNamePositionPairs:nil
          prevAbsHorizontalDistance:NAN
                      nextCellExist:YES
        nextMetricNamePositionPairs:nextMetricData
          nextAbsHorizontalDistance:nd];
    
}

- (void)initForReuseWithTimeStamp:(NSDate *)time
                              tag:(NSString *)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
        thisMetricNamePositionPairs:thisMetricData
                      prevCellExist:NO
        prevMetricNamePositionPairs:nil
          prevAbsHorizontalDistance:NAN
                      nextCellExist:NO
        nextMetricNamePositionPairs:nil
          nextAbsHorizontalDistance:NAN];
    
}

- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
      thisMetricNamePositionPairs:(nonnull NSDictionary*)thisMetricData
                    prevCellExist:(BOOL)pe
      prevMetricNamePositionPairs:(nullable NSDictionary*)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd
                    nextCellExist:(BOOL)ne
      nextMetricNamePositionPairs:(nullable NSDictionary*)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd {
    
    // set the timeStamp label
    NSDateFormatter* formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSAssert(timeStampLabel,@"timeStampLabel is nil");
    timeStampLabel.text = [formatter stringFromDate:time];
    timeStampLabel.font = [timeStampLabel.font fontWithSize:TIME_LABEL_FONT_SIZE];
    [timeStampLabel sizeToFit];
    
    
    // TODO set the tag
    
    // remove excessive metric views
    if (metricViews.count > thisMetricData.count) {
        for (int i = 0; i < metricViews.count - thisMetricData.count; i++) {
            [[metricViews lastObject]removeFromSuperview];
            [metricViews removeLastObject];
        }
    }
    
    // add the metric views, one for each metric, overlapping on top of each other
    int i = 0;
    for (NSNumber* key in thisMetricData) {
        
        MetricName metricName = [key integerValue];
        id value = [thisMetricData objectForKey:key];

        // validate value
        NSAssert([value isKindOfClass:[NSNumber class]], @"value is not a NSNumber");
        CGFloat floatV = [(NSNumber*)value floatValue];
        NSAssert(floatV >= 0.0 && floatV <= 1.0, @"value smaller than 0 or greater than 1");
        
        MetricView* mv;
        
        // alloc metric view if needed
        if (i < metricViews.count) {
            // have enough metricViews so far
            mv = [metricViews objectAtIndex:i];
            NSAssert(mv, @"mv is nil");
            mv = [mv initWithMetricName:(MetricName)metricName position:floatV];
        } else {
            NSLog(@"alloc new metric view");
            // alloc new
            mv = [[MetricView new]initWithMetricName:(MetricName)metricName position:floatV];
            [self addSubview:mv];
            
            // set auto layout
            mv.translatesAutoresizingMaskIntoConstraints = NO;
            NSMutableArray <NSLayoutConstraint*>* metricViewConstraints = [[NSMutableArray alloc]init];
            
            // set auto layout: align center X
            [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                           constant:0.0]];
            
            /* set auto layout: evenly distribute the bottoms of metric views along height of the cell:
             the height of the cell is divided into the same number of chunks evenly.
             Then, the second to the last dividing points are assigned as the bottom of the metric views.
             This creates the problem that the tops of all the metric views except the last one goes above the cell,
             while the top of the last metric view aligns perfectly with that of the cell.
             This problem is solved by using the next constraint on top of this one.
             */
            [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:(1.0/thisMetricData.count) * (i+1)
                                                                           constant:-1 * (timeStampLabel.frame.size.height
                                                                                          + TAG_VIEW_HEIGHT
                                                                                          + TIME_LABEL_BUTTON_MARGIN)
                                              * (1.0/thisMetricData.count) * (i+1)]];
            [metricViewConstraints lastObject].priority = UILayoutPriorityDefaultHigh; // make this constraint of lower priority than default so that it doesn't get in the way of the next constraint
            
            // set auto layout: the top cannot be above that of the cell. This constraint acts on top of the previous one (of higher priority)
            [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0.0]];
            
            // set auto layout: width equal to that of the cell
            [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:1.0
                                                                           constant:0.0]];
            // set auto layout: height equal to that of the cell
            [metricViewConstraints addObject:[NSLayoutConstraint constraintWithItem:mv
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:[[HistoryRenderRef sharedInstance] getHistoryBarOriginalHeight]
                                              - 1 * (timeStampLabel.frame.size.height
                                                     + TAG_VIEW_HEIGHT
                                                     + TIME_LABEL_BUTTON_MARGIN)]];
            [NSLayoutConstraint activateConstraints:metricViewConstraints];
            
            // add the MetricView to the array
            [metricViews addObject:mv];
        }
        
        // set up lines of applies
        if (pe && ne) {
            [mv addLeftLineWithPrevDataPointHeight:[[prevMetricData objectForKey:key]floatValue]
                              absHorizontalDistance:pd];
            [mv addRightLineWithNextDataPointHeight:[[nextMetricData objectForKey:key]floatValue]
                               absHorizontalDistance:nd];
        } else if (pe) {
            [mv addLeftLineWithPrevDataPointHeight:[[prevMetricData objectForKey:key]floatValue]
                              absHorizontalDistance:pd];
            [mv removeRightLine];
        } else if (ne) {
            [mv addRightLineWithNextDataPointHeight:[[nextMetricData objectForKey:key]floatValue]
                               absHorizontalDistance:nd];
            [mv removeLeftLine];
        } else {
            [mv removeLeftLine];
            [mv removeRightLine];
        }
        
        i++;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
