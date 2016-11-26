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

#define NUMBER_OF_CONTROL_BUTTONS 4
#define CONTROL_BUTTON_HEIGHT 60.0
#define CONTROL_BUTTON_GAP 30.0

@interface MapControlViewController ()

@end

@implementation MapControlViewController {
    TutorialView *tutorialView;
    MapControlView *vMapControl;
    
    NSInteger selectedButtonTag;
    NSMutableArray *arrControlButtons;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showConnectingMessage)
                                                     name:@"rmq_connection_about_to_open"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideConnectingMessage)
                                                     name:@"rmq_open_connection_ok"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideConnectingMessage)
                                                     name:@"rmq_open_connection_fail"
                                                   object:nil];
        
        selectedButtonTag = 0;
        arrControlButtons = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // connect the UI with network component and init the UI
    vMapControl = [[MapControlView alloc] initWithFrame:self.view.bounds];
    self.view = vMapControl;
    [(MapControlView *)self.view setTarget:[MapWallDisplayController sharedInstance]];
    
    DEFINE_WEAK_SELF

    // Add four buttons to control the displays
    for (int i=0; i<NUMBER_OF_CONTROL_BUTTONS; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"Display %i", i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(controlButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == selectedButtonTag) {
            btn.backgroundColor = [UIColor lightGrayColor];
            btn.enabled = NO;
        }
        
        [vMapControl addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.view).with.offset(-40.0f);
            make.top.equalTo(weakSelf.view).with.offset(40.0 + i * CONTROL_BUTTON_HEIGHT + i * CONTROL_BUTTON_GAP);
            make.height.equalTo(@(CONTROL_BUTTON_HEIGHT));
            make.width.equalTo(@120);
        }];
        
        [arrControlButtons addObject:btn];
    }

    // Add Help Button
    UIButton *btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHelp setTitle:@"How To Use" forState:UIControlStateNormal];
    btnHelp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    btnHelp.titleLabel.textColor = [UIColor whiteColor];
    btnHelp.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnHelp addTarget:self action:@selector(helpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [vMapControl addSubview:btnHelp];

    [btnHelp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.view).with.offset(38.0f);
        make.bottom.equalTo(weakSelf.view).with.offset(-14.0f);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
    
    [self showTutorial];
}

- (void)controlButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btnSelected = (UIButton *)sender;
        NSInteger btnID = btnSelected.tag;

        // Reset previously selected button states
        UIButton *btnPrevSelected = arrControlButtons[selectedButtonTag];
        btnPrevSelected.enabled = YES;
        btnPrevSelected.backgroundColor = [UIColor whiteColor];
        
        // Newly selected
        btnSelected.enabled = NO;
        btnSelected.backgroundColor = [UIColor lightGrayColor];
        selectedButtonTag = btnID;
        
        [[MapWallDisplayController sharedInstance] switchToControllMode:btnID];
    }
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

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
