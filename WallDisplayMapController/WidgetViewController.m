//
//  WidgetViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "WidgetViewController.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>
#import "MobilityView.h"
#import "UnavailableView.h"
#import "PNChart.h"

@interface WidgetViewController () <UITableViewDataSource, UITableViewDelegate>

@property UIView *vTimeline;
@property UIView *vCategory;
@property UIView *vContent;

@property UITableView *tableCategory;

@property NSArray *arrCategories;

@end

@implementation WidgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrCategories = @[@"Mobility", @"Land Use", @"Energy & Carbon", @"Economy", @"Equity", @"Well Being"];
    
    [self initUI];
    
}

- (void)initUI {
    self.vTimeline = [[UIView alloc] init];
    self.vTimeline.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    [self.view addSubview:self.vTimeline];
    
    self.vCategory = [[UIView alloc] init];
    [self.view addSubview:self.vCategory];
    
    self.tableCategory = [[UITableView alloc] init];
    self.tableCategory.delegate = self;
    self.tableCategory.dataSource = self;
    self.tableCategory.showsHorizontalScrollIndicator = NO;
    self.tableCategory.showsVerticalScrollIndicator = NO;
    self.tableCategory.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor lightGrayColor]];
    [self.vCategory addSubview:self.tableCategory];
    
    self.vContent = [[UIView alloc] init];
    self.vContent.backgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
    [self.view addSubview:self.vContent];
    
    // AutoLayout
    __weak typeof(self) weakSelf = self;

    [self.vTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.equalTo(@100);
        
    }];
    
    [self.vCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.vTimeline.mas_top);
        make.width.equalTo(@120);
    }];
    
    [self.tableCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.and.trailing.equalTo(weakSelf.vCategory);
    }];
    
    [self.vContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(weakSelf.vCategory.mas_leading);
        make.bottom.equalTo(weakSelf.vTimeline.mas_top);
    }];
    
    
    [self.tableCategory selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self showContentWithIndex:0];

}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showContentWithIndex:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115.0;
}


#pragma mark UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor lightGrayColor]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:14.0];
    cell.textLabel.text = self.arrCategories[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCategories.count;
}

#pragma mark helpers

- (void)showContentWithIndex:(NSInteger) index {
    [[self.vContent subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    if (index == 0) {
        // Show Mobility View
        MobilityView *vMob = [[MobilityView alloc] init];
        vMob.backgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
        [self.vContent addSubview:vMob];
        
        [vMob mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.and.bottom.equalTo(weakSelf.vContent);
        }];
        
        [vMob updateWithModelDict:@{@"plan_value" : @10185,
                                    @"existing_value" : @12842}];
        
    } else {
        // Show Data Unavailable
        UnavailableView *vUnav = [[UnavailableView alloc] initWithInfoText:@"Sorry, the requested information is currently unavailable."];
        vUnav.backgroundColor = [UIColor colorWithWhite:0.988 alpha:1.0];
        [self.vContent addSubview:vUnav];
        
        [vUnav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.and.bottom.equalTo(weakSelf.vContent);
            
        }];
        
        [vUnav show];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
