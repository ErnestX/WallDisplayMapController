//
//  MasterViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-23.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MasterViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"
#import "PNChart.h"
#import "XMLDictionary.h"
#import "UIColor+Extend.h"
#import "ChooseElementViewController.h"
#import "GlobalManager.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MasterViewController {
    NSArray *arrCategories;
    
    UITableView *tableCategory;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        arrCategories = @[@"Travel", @"Land Use", @"Energy & Carbon", @"Economy", @"Dwellings", @"Well Being"];
                
        [[NSNotificationCenter defaultCenter] addObserver:[GlobalManager sharedInstance] selector:@selector(beginConsumingMetricsData) name:RMQ_CONSUMER_THREAD_STARTED object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    
    // Make navigation bar colored
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorFromHexString:@"#1ABC9C"];
    
    // Customize appearance of navigation bar title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 40.0)];
    lblTitle.text = @"Select Category";
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    lblTitle.textColor = COLOR_BG_WHITE;
    self.navigationItem.titleView = lblTitle;
    
    tableCategory = [[UITableView alloc] init];
    tableCategory.delegate = self;
    tableCategory.dataSource = self;
    tableCategory.showsHorizontalScrollIndicator = NO;
    tableCategory.showsVerticalScrollIndicator = NO;
    tableCategory.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    tableCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableCategory];
    
    __weak typeof(self) weakSelf = self;
    [tableCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.and.trailing.equalTo(weakSelf.view);
    }];

}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = DICT_COLOR_TYPE[arrCategories[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = arrCategories[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChooseElementViewController *vc = [[ChooseElementViewController alloc] init];
    vc.title = arrCategories[indexPath.row];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target: nil action: nil];
    self.navigationItem.backBarButtonItem = backBarButton;
    vc.category = arrCategories[indexPath.row];
    
    [self.navigationController pushViewController:vc animated: YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:[GlobalManager sharedInstance] name:RMQ_CONSUMER_THREAD_STARTED object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
