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
    id<MetricPickerDelegate> myDelegate;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    return self;
}

- (id)initForReuseWithMetricName:(MetricName)m myDelegate:(id<MetricPickerDelegate>)md {
    self.metricName = m;
    myDelegate = md;
    
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
        
        // show picker
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.frame = CGRectMake(0.0, 0.0, 100, 100);
        pickerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
        
        UIViewController* pickerController = [[UIViewController alloc]init];
        pickerController.view = pickerView;
        pickerController.modalPresentationStyle = UIModalPresentationPopover;
        
        
        
        [myDelegate showPickerViewController:pickerController fromView:self];
        
//        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"pick a metric"
//                                                                                 message:@"to delete, choose the last one: not a metric"
//                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        
    } else if (oldSelected && !selected) {
        NSLog(@"unselected %@", [[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]);
        // TODO
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[MetricsConfigs instance]getDisplayNameForMetric:row]; // this is based on the assumption that num of row is exactly the same as num of enum
    } else {
        return nil;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return notAMetric; // this is the last of the enum, thus used as the counter. Include notAMetric here so that we can select it to remove the cell
    } else {
        return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picked %@", [[MetricsConfigs instance]getDisplayNameForMetric:row]);
    // stub
}

@end
