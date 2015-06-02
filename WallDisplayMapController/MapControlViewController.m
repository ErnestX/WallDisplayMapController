//
//  ViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MapControlViewController.h"
#import "MapControlView.h"
#import "MapWallDisplayController.h"

@interface MapControlViewController ()

@end

@implementation MapControlViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConnectingMessage) name:@"rmq_connection_about_to_open" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInstructions) name:@"rmq_open_connection_ok" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // connect the UI with network component and init the UI
    [(MapControlView*)self.view setTarget:[MapWallDisplayController sharedInstance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showConnectingMessage
{
    
}

- (void)showInstructions
{
    
}

@end
