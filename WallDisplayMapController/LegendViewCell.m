//
//  LegendViewCell.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2016-04-30.
//  Copyright © 2016 Jialiang. All rights reserved.
//

#import "LegendViewCell.h"

@interface LegendViewCell ()
@property (readwrite) MetricName metricName;
@end

@implementation LegendViewCell {
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    return self;
}

- (id)initForReuseWithMetricName:(MetricName)m {
    self.metricName = m;
    
    self.textLabel.text = [[MetricsConfigs instance] getDisplayNameForMetric:self.metricName];
    self.textLabel.textColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
    
    return self;
}

- (id)initAsAddButton {
    self.metricName = notAMetric;
    self.textLabel.text = @"add new metric";
    self.textLabel.textColor = [UIColor darkTextColor];
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.metricName = notAMetric;
    self.textLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    BOOL oldSelected = self.selected; // to prevent the weird default behavior that this method is often called twice for a single tap
    [super setSelected:selected animated:animated];
    
    if (!oldSelected && selected) {
        NSLog(@"selected %@", [[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]);
        // TODO
    } else if (oldSelected && !selected) {
        NSLog(@"unselected %@", [[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]);
        // TODO
    }
}

@end
