//
//  SettingsViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "SettingsViewController.h"
#import "Masonry.h"
#import "RabbitMQManager.h"
#import "UIColor+Extend.h"

@interface SettingsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tfIP;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation SettingsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rmqOpenFail) name:RMQ_OPEN_CONN_FAILED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rmqOpenSuccess) name:RMQ_OPEN_CONN_OK object:nil];
    }
    return self;
}

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
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(15, 0, 50.0, 50.0);
    self.spinner.hidden = YES;
    [self.btnSubmit addSubview:self.spinner];

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
    DEFINE_WEAK_SELF
    [weakSelf.tfIP resignFirstResponder];
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    weakSelf.spinner.hidden = NO;
    [weakSelf.spinner startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        RabbitMQManager *mgr = [RabbitMQManager sharedInstance];
        
        [mgr setIPAddress:self.tfIP.text];
        [mgr openRMQConnection];

//
//        if (![mgr connected]) {
//            [mgr openRMQConnection];
//        } else {
//            [mgr closeRMQConnection];
//            [mgr openRMQConnection];
//        }
    });
    

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

- (void)rmqOpenSuccess {
    DEFINE_WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.spinner stopAnimating];
        weakSelf.spinner.hidden = YES;
        [weakSelf.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    });

}

- (void)rmqOpenFail {
    DEFINE_WEAK_SELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"RabbitMQ open connection failed.\n Please check your IP and try again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        [weakSelf.spinner stopAnimating];
        weakSelf.spinner.hidden = YES;
        [weakSelf.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
