//
//  ChooseElementViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-24.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "ChooseElementViewController.h"
#import "UIColor+Extend.h"

@interface ChooseElementViewController ()

@end

@implementation ChooseElementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = COLOR_BG_WHITE;
    self.view.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.0, 40.0)];
    lblTitle.text = self.title;
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    lblTitle.textColor = COLOR_BG_WHITE;
    self.navigationItem.titleView = lblTitle;


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
