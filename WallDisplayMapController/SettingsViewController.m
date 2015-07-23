//
//  SettingsViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "SettingsViewController.h"
#import "Masonry.h"
#import "RabbitMQManager.h"s
#import "UIColor+Extend.h"

@interface SettingsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tfIP;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BG_WHITE;
    
    self.tfIP = [[UITextField alloc] init];
    self.tfIP.placeholder = @"IP Address of TouchTable:";
    self.tfIP.keyboardType = UIKeyboardTypePhonePad;
    self.tfIP.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    self.tfIP.textColor = [UIColor darkTextColor];
    self.tfIP.textAlignment = NSTextAlignmentCenter;
    self.tfIP.delegate = self;
    [self.view addSubview:self.tfIP];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor darkTextColor];
    [self.view addSubview:line];
    
    self.btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    self.btnSubmit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    [self.btnSubmit setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.btnSubmit addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    DEFINE_WEAK_SELF
    [self.tfIP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view).with.offset(-200.0f);
        make.width.equalTo(@400.0);
        make.height.equalTo(@50.0);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.tfIP);
        make.height.equalTo(@0.5);
        make.top.equalTo(weakSelf.tfIP.mas_bottom).with.offset(10.0f);
    }];
    
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50.0);
        make.width.equalTo(@80.0);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(line.mas_bottom).with.offset(10.0f);
    }];
    
}

- (void)submitButtonPressed:(UIButton *)sender {

    [self.tfIP resignFirstResponder];
    
    RabbitMQManager *mgr = [RabbitMQManager sharedInstance];
    [mgr setIPAddress:self.tfIP.text];

    if (![mgr connected]) {
        [mgr openRMQConnection];
    } else {
        [mgr closeRMQConnection];
        [mgr openRMQConnection];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 15;
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= maxLength || returnKey;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
