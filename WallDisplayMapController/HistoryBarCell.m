//
//  HistoryBarCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-02-03.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "HistoryBarCell.h"
#import "MetricView.h"
#import "MetricsConfigs.h"
#import "MetricValueLabelView.h"
#import "GlobalLayoutRef.h"

#define TIME_LABEL_BUTTON_MARGIN 2
#define GREY_LINE_THICKNESS 2
#define TAG_VIEW_WIDTH 63

@implementation HistoryBarCell
{
    UILabel* timeStampLabel;
    UIView* greyLineView;
    UIView* tagView;
    NSMutableArray <MetricView*>* metricViews;
    NSMutableArray <MetricValueLabelView*>* valueLabels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    
    metricViews = [[NSMutableArray alloc]init];
    valueLabels = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
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
                                                                constant:[[GlobalLayoutRef instance]getTagViewHeight]]];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showMetricValueLabels)
                                                name:[[GlobalLayoutRef instance]getNotificationMessageForExpandingHistoryBar]
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(hideMetricValueLabels)
                                                name:[[GlobalLayoutRef instance]getNotificationMessageForContractingHistoryBar]
                                              object:nil];
    
    return self;
}

- (void)initForReuseWithTimeStamp:(NSDate *)time
                              tag:(NSString *)tag
                        flagOrNot:(BOOL)flag
         thisMetricNameValuePairs:(nonnull NSDictionary*)thisMetricRawData
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary *)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd
      nextMetricNamePositionPairs:(nonnull NSDictionary *)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
           thisMetricNameValuePairs:thisMetricRawData
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
         thisMetricNameValuePairs:(nonnull NSDictionary*)thisMetricRawData
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      prevMetricNamePositionPairs:(nonnull NSDictionary *)prevMetricData
        prevAbsHorizontalDistance:(CGFloat)pd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
           thisMetricNameValuePairs:thisMetricRawData
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
         thisMetricNameValuePairs:(nonnull NSDictionary*)thisMetricRawData
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData
      nextMetricNamePositionPairs:(NSDictionary *)nextMetricData
        nextAbsHorizontalDistance:(CGFloat)nd {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
           thisMetricNameValuePairs:thisMetricRawData
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
         thisMetricNameValuePairs:(nonnull NSDictionary*)thisMetricRawData
      thisMetricNamePositionPairs:(NSDictionary *)thisMetricData {
    
    [self initForReuseWithTimeStamp:time
                                tag:tag
                          flagOrNot:flag
           thisMetricNameValuePairs:thisMetricRawData
        thisMetricNamePositionPairs:thisMetricData
                      prevCellExist:NO
        prevMetricNamePositionPairs:nil
          prevAbsHorizontalDistance:NAN
                      nextCellExist:NO
        nextMetricNamePositionPairs:nil
          nextAbsHorizontalDistance:NAN];
    
}

- (void)setUpAutoLayoutForMetricView:(MetricView*)mv atIndex:(NSInteger)index givenTotalMetricViewCount:(NSInteger)count {
    
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
                                                                 multiplier:(1.0/count) * (index+1)
                                                                   constant:-1 * (timeStampLabel.frame.size.height
                                                                                  + [[GlobalLayoutRef instance]getTagViewHeight]
                                                                                  + TIME_LABEL_BUTTON_MARGIN)
                                      * (1.0/count) * (index+1)]];
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
                                                                   constant:[[GlobalLayoutRef instance] getHistoryBarOriginalHeight]
                                      - 1 * (timeStampLabel.frame.size.height
                                             + [[GlobalLayoutRef instance]getTagViewHeight]
                                             + TIME_LABEL_BUTTON_MARGIN)]];
    
    [mv deactivateOldConstraintsAndActivateNewOnes:metricViewConstraints];
}

- (void)initForReuseWithTimeStamp:(nonnull NSDate*)time
                              tag:(nonnull NSString*)tag
                        flagOrNot:(BOOL)flag
         thisMetricNameValuePairs:(nonnull NSDictionary*)thisMetricRawData
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
    timeStampLabel.font = [timeStampLabel.font fontWithSize:[[GlobalLayoutRef instance]getTimeStampFontSize]];
    [timeStampLabel sizeToFit];
    
    
    // TODO set the tag
    
    
    BOOL needToResetValueLabels = NO;
    
    // add the metric views, one for each metric, overlapping on top of each other
    
    // first make sure the number of metric views is correct
    if (metricViews.count != [MetricsConfigs instance].metricsDisplayedInOrder.count) {
        // Step1: get the count correct
        if (metricViews.count > [MetricsConfigs instance].metricsDisplayedInOrder.count) {
            // remove excessive metric views
            NSInteger iterations = metricViews.count - [MetricsConfigs instance].metricsDisplayedInOrder.count;
            for (int i = 0; i < iterations; i++) {
                [[metricViews lastObject]removeFromSuperview];
                [metricViews removeLastObject];
            }
        } else if (metricViews.count < [MetricsConfigs instance].metricsDisplayedInOrder.count) {
            // add more metric views
            NSInteger iterations = [MetricsConfigs instance].metricsDisplayedInOrder.count - metricViews.count;
            for (int i = 0; i < iterations; i++) {
                MetricView* newMetricView = [MetricView new];
                [self addSubview:newMetricView];
                [metricViews addObject:newMetricView];
            }
        }
        
        NSAssert(metricViews.count == [MetricsConfigs instance].metricsDisplayedInOrder.count, @"the num of metric views is still incorrect!");
        
        // Step2: reset auto layout for all metric views
        for (int i = 0; i < metricViews.count; i++) {
            MetricView* mv = [metricViews objectAtIndex:i];
            [self setUpAutoLayoutForMetricView:mv atIndex:i givenTotalMetricViewCount:metricViews.count];
        }
        
        // Step3: reverse z position order. the first added metric is usually the more important ones, so put them over the latter ones
        for (int i = metricViews.count-1; i >= 0; i--) {
            [self bringSubviewToFront:[metricViews objectAtIndex:i]];
        }
        
        // Step4: set need to re-set up value labels
        needToResetValueLabels = YES;
    }
    
    // now that the metric views are setup, init them with the right data
    for (int i=0; i<[MetricsConfigs instance].metricsDisplayedInOrder.count; i++) {
        
        NSNumber* metricNameInNSNum = [[MetricsConfigs instance].metricsDisplayedInOrder objectAtIndex:i];
        MetricName metricName = [metricNameInNSNum integerValue];
        NSNumber* displayPos = [thisMetricData objectForKey:metricNameInNSNum];

        // validate value
        NSAssert(displayPos, @"displayPos for a metric needed to display is not present in the dictionary passed from the container controller");
        NSAssert([displayPos isKindOfClass:[NSNumber class]], @"value is not a NSNumber");
        CGFloat floatV = [(NSNumber*)displayPos floatValue];
        NSAssert(floatV >= 0.0 && floatV <= 1.0, @"value smaller than 0 or greater than 1");
        
        MetricView* mv;
        
        mv = [metricViews objectAtIndex:i];
        NSAssert(mv, @"mv is nil");
        mv = [mv initWithMetricName:(MetricName)metricName
                           rawValue:[[thisMetricRawData objectForKey:metricNameInNSNum]floatValue]
                           position:floatV];
        
        // set up lines of applies
        if (pe && ne) {
            [mv addLeftLineWithPrevDataPointHeight:[[prevMetricData objectForKey:metricNameInNSNum]floatValue]
                              absHorizontalDistance:pd];
            [mv addRightLineWithNextDataPointHeight:[[nextMetricData objectForKey:metricNameInNSNum]floatValue]
                               absHorizontalDistance:nd];
        } else if (pe) {
            [mv addLeftLineWithPrevDataPointHeight:[[prevMetricData objectForKey:metricNameInNSNum]floatValue]
                              absHorizontalDistance:pd];
            [mv removeRightLine];
        } else if (ne) {
            [mv addRightLineWithNextDataPointHeight:[[nextMetricData objectForKey:metricNameInNSNum]floatValue]
                               absHorizontalDistance:nd];
            [mv removeLeftLine];
        } else {
            [mv removeLeftLine];
            [mv removeRightLine];
        }
    }
    
    // finally reset value labels if necessary
    if (needToResetValueLabels) {
        [self resetMetricValueLabels];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)resetMetricValueLabels { // call this whenever the metric view changes
    for (int i=0; i<valueLabels.count; i++) {
        [[valueLabels objectAtIndex:i]removeFromSuperview];
    }
    
    valueLabels = [[NSMutableArray alloc]init];
    
    for (int i=0; i<metricViews.count; i++) {
        MetricView* mv = [metricViews objectAtIndex:i];
        NSAssert(mv.metricValueLabelView, @"metric value label view is nil");
        MetricValueLabelView* mvlv = mv.metricValueLabelView; // need to make sure mv is already initialized
        [self addSubview:mvlv];
        
        // set auto layout
        mvlv.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray <NSLayoutConstraint*>* valueLabelConstraints = [[NSMutableArray alloc]init];
        [valueLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:mvlv
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:mv.dataPointView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:8.0]];
        [valueLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:mvlv
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:mv.dataPointView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:-7.0]];
        [valueLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:mvlv
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:25.0]];
        [valueLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:mvlv
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:12.0]];
        [NSLayoutConstraint activateConstraints:valueLabelConstraints];
        
        [valueLabels addObject:mvlv];
        
        // hide by default
        mvlv.alpha = 0.0;
    }
}

- (void)showMetricValueLabels {
    [UIView animateWithDuration:0.2 animations:^{
        for (int i=0; i<valueLabels.count; i++) {
            [valueLabels objectAtIndex:i].alpha = 1.0;
        }
    }];
}

- (void)hideMetricValueLabels {
    [UIView animateWithDuration:0.2 animations:^{
        for (int i=0; i<valueLabels.count; i++) {
            [valueLabels objectAtIndex:i].alpha = 0.0;
        }
    }];
}

@end
