//
//  ChooseElementViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-24.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "ChooseElementViewController.h"
#import "UIColor+Extend.h"
#import "Masonry.h"
#import "UnavailableView.h"

@interface ChooseElementViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ChooseElementViewController {
    
    UITableView *tableElements;
}

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
    
    if (!self.arrData) {
        // No data, widget elements unavailable
        [self showDataUnavailable];
        
    } else {
        // Display widget elements in table cells with the data we have
        [self showTableWithSelectableElements];
        
    }
    
}

- (void)showTableWithSelectableElements {
    tableElements = [[UITableView alloc] init];
    tableElements.delegate = self;
    tableElements.dataSource = self;
    tableElements.showsHorizontalScrollIndicator = NO;
    tableElements.showsVerticalScrollIndicator = NO;
    tableElements.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];
    [self.view addSubview:tableElements];
    
    DEFINE_WEAK_SELF
    [tableElements mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.and.trailing.equalTo(weakSelf.view);
    }];
    
    
//    UILabel *lblTest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 100.0)];
//    lblTest.backgroundColor = [UIColor greenColor];
//    lblTest.text = @"HELLO WORLD";
//    lblTest.textAlignment = NSTextAlignmentCenter;
//    lblTest.textColor = [UIColor redColor];
//    lblTest.userInteractionEnabled = YES;
//    [self.view addSubview:lblTest];
//    
//    [lblTest mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(@100.0);
//        make.centerY.equalTo(@200.0);
//    }];
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(pan:)];
//    [lblTest addGestureRecognizer:pan];


}

- (void)showDataUnavailable {
    UnavailableView *vUnav = [[UnavailableView alloc] initWithInfoText:@"Sorry, the requested information is currently unavailable."];
    [self.view addSubview:vUnav];
    
    DEFINE_WEAK_SELF
    [vUnav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.and.bottom.equalTo(weakSelf.view);
        
    }];
    
    [vUnav show];
}

#pragma mark -- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lblTest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 100.0)];
        lblTest.center = CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2);
        lblTest.text = @"HELLO WORLD";
        lblTest.backgroundColor = [UIColor greenColor];
        lblTest.textColor = [UIColor redColor];
        lblTest.userInteractionEnabled = YES;
        lblTest.textAlignment = NSTextAlignmentCenter;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pan:)];
        [lblTest addGestureRecognizer:pan];

        [cell.contentView addSubview:lblTest];
        
        
        
    }
    cell.backgroundColor = [UIColor colorFromHexString:@"#e3e3e3"];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrData count];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableElements deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)pan:(UIPanGestureRecognizer *)recognizor {
    UILabel *lblPanned = (UILabel *)[recognizor view];
    UIView *referenceView = lblPanned.superview;

    if (recognizor.state == UIGestureRecognizerStateEnded) {
        if (lblPanned.frame.origin.x < (referenceView.frame.origin.x + referenceView.frame.size.width)) {
            lblPanned.center = referenceView.center;
        } else {
            // stick it to DetailViewController's grid
        }
        
    } else {
        NSLog(@"%f", [recognizor locationInView:referenceView].x);
        lblPanned.center = CGPointMake([recognizor locationInView:referenceView].x, [recognizor locationInView:referenceView].y);
    }
    
}

//- (void)tap:(UITapGestureRecognizer *)recognizor {
//    
//    // view begin shaking to indicate it just entered dragging mode
//    UIView *tappedView = [recognizor view];
//    if ([tappedView.layer.animationKeys count] != 0) {
//        
//        // view can now be dragged
//        [tappedView addGestureRecognizer:pan];
//        
//    } else {
////        [UIView animateKeyframesWithDuration:0.124
////                                       delay:0.0
////                                     options:UIViewKeyframeAnimationOptionAllowUserInteraction |UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
////                                  animations:^{
////                                      tappedView.transform = CGAffineTransformMakeRotation(-0.05);
////                                      tappedView.transform = CGAffineTransformMakeRotation(0.05);
////                                      
////                                  }
////                                  completion:nil];
//        
//        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        CGFloat wobbleAngle = (rand() % (10 - 5) + 5) /100.0;
//        NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0f, 0.0f, 1.0f)];
//        NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0f, 0.0f, 1.0f)];
//        animation.values = [NSArray arrayWithObjects:valLeft, valRight, nil];
//        animation.autoreverses = YES;
//        
//        animation.duration = 0.125;
//        animation.repeatCount = HUGE_VALF;
//        [tappedView.layer addAnimation:animation forKey:@"iconShake"];
//        
//    }
//    
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
