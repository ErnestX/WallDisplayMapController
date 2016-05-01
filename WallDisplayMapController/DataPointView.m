//
//  DataPointView.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-29.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "DataPointView.h"

#define LABEL_LEFT_MARGIN 3
#define LABEL_TOP_MARGIN 0.5
static CGFloat const FONT_SIZE_CONST = -3.0;

@interface DataPointView ()
@property (readwrite) MetricName metricName;
@end

@implementation DataPointView {
    UILabel* metricNameLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!metricNameLabel) {
            metricNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_LEFT_MARGIN, LABEL_TOP_MARGIN, self.bounds.size.width, self.bounds.size.height)];
            metricNameLabel.textColor = [UIColor whiteColor];
            metricNameLabel.adjustsFontSizeToFitWidth = NO;
            metricNameLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height + FONT_SIZE_CONST];
            [self addSubview:metricNameLabel];
        }
    }
    
    return self;
}

- (id)initWithMetricName:(MetricName)m {
    self = [super init];
    
    NSLog(@"%d", self.subviews.count);
    if (self) {
        self.metricName = m;
        self.backgroundColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
        self.layer.cornerRadius = self.bounds.size.width/2.0;
        
        metricNameLabel.text = [[[[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]substringToIndex:1]uppercaseString]; // get the first charactor
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layer.cornerRadius = self.bounds.size.width/2.0;
    metricNameLabel.frame = CGRectMake(LABEL_LEFT_MARGIN, LABEL_TOP_MARGIN, self.bounds.size.width, self.bounds.size.height);
    metricNameLabel.font = [UIFont fontWithName:@"Helvetica" size:self.bounds.size.height + FONT_SIZE_CONST];
}

@end
