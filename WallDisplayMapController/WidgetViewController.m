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
    self.vTimeline.backgroundColor = [UIColor flatGrayColorDark];
    [self.view addSubview:self.vTimeline];
    
    self.vCategory = [[UIView alloc] init];
    [self.view addSubview:self.vCategory];
    
    self.tableCategory = [[UITableView alloc] init];
    self.tableCategory.delegate = self;
    self.tableCategory.dataSource = self;
    self.tableCategory.showsHorizontalScrollIndicator = NO;
    self.tableCategory.showsVerticalScrollIndicator = NO;
    self.tableCategory.backgroundColor = [UIColor flatGrayColor];
    [self.vCategory addSubview:self.tableCategory];
    
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

    
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    cell.backgroundColor = [UIColor flatGrayColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor flatWhiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:14.0];
    cell.textLabel.text = self.arrCategories[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCategories.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
