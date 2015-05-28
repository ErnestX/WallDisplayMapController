//
//  ViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "ViewController.h"
#import "MapControlView.h"
#import "MapWallDisplayController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // connect the UI with network component and init the UI
    MapWallDisplayController *controller = [[MapWallDisplayController alloc] init];
    [(MapControlView*)self.view setTarget:controller WithCallBackIntervalInSec:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
