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
#import "TutorialView.h"
#import "Masonry.h"

@interface MapControlViewController ()

@end

@implementation MapControlViewController {
    TutorialView* tutorialView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConnectingMessage) name:@"rmq_connection_about_to_open" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideConnectingMessage) name:@"rmq_open_connection_ok" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // connect the UI with network component and init the UI
    MapControlView *vMapControl = [[MapControlView alloc] initWithFrame:self.view.bounds];
    self.view = vMapControl;
    [(MapControlView*)self.view setTarget:[MapWallDisplayController sharedInstance]];
    
    // Add Help Button
    UIButton *btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHelp setTitle:@"Help" forState:UIControlStateNormal];
    btnHelp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0];
    btnHelp.titleLabel.textColor = [UIColor whiteColor];
    btnHelp.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnHelp addTarget:self action:@selector(helpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [vMapControl addSubview:btnHelp];
    DEFINE_WEAK_SELF
    [btnHelp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.view).with.offset(40.0f);
        make.bottom.equalTo(weakSelf.view).with.offset(-25.0f);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
    
    [self showTutorial];
}

- (IBAction)helpButtonPressed:(id)sender {
    [self showTutorial];
}

- (void) showTutorial
{
    NSLog(@"show tutorail");
    [tutorialView removeFromSuperview];
    tutorialView = [[TutorialView alloc] initWithFrame:self.view.frame];
    [tutorialView setController:self];
    tutorialView.backgroundColor = [UIColor whiteColor];
    
    CATransition* transition = [CATransition new];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view addSubview:tutorialView];
    [self.view.layer addAnimation:transition forKey:@"transitionIn"];
}

- (void) exitTutorial
{
    CATransition* transition = [CATransition new];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [tutorialView removeFromSuperview];
    [self.view.layer addAnimation:transition forKey:@"transitionOut"];
    [self.view setNeedsDisplay];
}

- (void)showConnectingMessage
{
    [(MapControlView*)self.view showConnectingMessage];
}

- (void)hideConnectingMessage
{
    //[(MapControlView*)self.view hideConnectingMessageAndshowInstructions];
    [(MapControlView*)self.view hideConnectingMessage];
}

@end
