//
//  TutorialViewController.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-31.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialView.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [(TutorialView*)self.view setController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)exitTutorial {
    [self performSegueWithIdentifier:@"BackSegue" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}

@end
