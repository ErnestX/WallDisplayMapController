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
    // this may not be called at all!
    
    self = [super initWithFrame:frame];
    NSAssert(self, @"init failed");
    return self;
}

- (id)initForReuseWithMetricName:(MetricName)m myDelegate:(id<MetricPickerDelegate>)md {
    self.metricName = m;
    myDelegate = md;
    
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0];
    
    if (m == notAMetric) {
        self.textLabel.text = @"add new metric";
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.text = [[MetricsConfigs instance] getDisplayNameForMetric:self.metricName];
        self.textLabel.textColor = [[MetricsConfigs instance]getColorForMetric:self.metricName];
    }
    
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
        
        [pickerView selectRow:self.metricName inComponent:0 animated:NO]; // select the current one
        
        UIViewController* pickerController = [[UIViewController alloc]init];
        pickerController.view = pickerView;
        pickerController.modalPresentationStyle = UIModalPresentationPopover;
        pickerController.preferredContentSize = pickerView.bounds.size;
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [pickerController popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionRight;
        
        // in case we don't have a bar button as reference
        popController.sourceView = self;
        popController.sourceRect = CGRectMake(-5, 20, 0, 0); // magic number to make the pointer look right
        
        [myDelegate showPickerViewController:pickerController fromView:self];
        
        self.selected = NO;
        
    } else if (oldSelected && !selected) {
//        NSLog(@"unselected %@", [[MetricsConfigs instance]getDisplayNameForMetric:self.metricName]);
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (row == notAMetric) {
            return @"no metric";
        } else {
            return [[MetricsConfigs instance]getDisplayNameForMetric:row]; // this is based on the assumption that num of row is exactly the same as num of enum
        }
    } else {
        return nil;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return notAMetric+1; // notAMetric is the last of the enum, thus used as the counter here.
    } else {
        return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picked %@", [[MetricsConfigs instance]getDisplayNameForMetric:row]);
    [self initForReuseWithMetricName:row myDelegate:myDelegate];
//    [myDelegate refreshMetricsDisplayedAndSetMetricsConfig];
    [myDelegate setMetricsConfigArrayByReplacingMetricAtIndexOfCell:self withMetric:row];
}

@end
