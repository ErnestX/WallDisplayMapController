//
//  WidgetViewController.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-16.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "WidgetViewController.h"
#import "MobilityView.h"
#import "UnavailableView.h"
#import "LandUseView.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"
#import "PNChart.h"
#import "XMLDictionary.h"

#import "DensityModel.h"
#import "BuildingsModel.h"
#import "EnergyModel.h"
#import "DistrictEnergyModel.h"
#import "RabbitMQManager.h"


@interface WidgetViewController () <UITableViewDataSource, UITableViewDelegate>

@property DensityModel *modelDensity;
@property BuildingsModel *modelBuildings;
@property EnergyModel *modelEnergy;
@property DistrictEnergyModel *modelDistrictEnergy;

@end

@implementation WidgetViewController {
    NSArray *arrCategories;
    UIView *vTimeline;
    UIView *vCategory;
    UIView *vContent;
    UITableView *tableCategory;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consumerThreadBegin) name:RMQ_CONSUMER_THREAD_STARTED object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrCategories = @[@"Mobility", @"Land Use", @"Energy & Carbon", @"Economy", @"Equity", @"Well Being"];
    
    [self initUI];

    
}

- (void)initUI {
    vTimeline = [[UIView alloc] init];
    vTimeline.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    [self.view addSubview:vTimeline];
    
    vCategory = [[UIView alloc] init];
    [self.view addSubview:vCategory];
    
    tableCategory = [[UITableView alloc] init];
    tableCategory.delegate = self;
    tableCategory.dataSource = self;
    tableCategory.showsHorizontalScrollIndicator = NO;
    tableCategory.showsVerticalScrollIndicator = NO;
    tableCategory.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor lightGrayColor]];
    [vCategory addSubview:tableCategory];
    
    vContent = [[UIView alloc] init];
    vContent.backgroundColor = COLOR_BG_WHITE;
    [self.view addSubview:vContent];
    
    // AutoLayout
    __weak typeof(self) weakSelf = self;

    [vTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.equalTo(@100);
        
    }];
    
    [vCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(vTimeline.mas_top);
        make.width.equalTo(@120);
    }];
    
    [tableCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.and.trailing.equalTo(vCategory);
    }];
    
    [vContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(vCategory.mas_leading);
        make.bottom.equalTo(vTimeline.mas_top);
    }];
    
    
    [tableCategory selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
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
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:19.0];
    cell.textLabel.text = arrCategories[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCategories.count;
}

#pragma mark helpers

- (void)showContentWithIndex:(NSInteger) index {
    [[vContent subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (index == 0) {
        // Show Mobility View
        MobilityView *vMob = [[MobilityView alloc] init];
        vMob.backgroundColor = COLOR_BG_WHITE;
        [vContent addSubview:vMob];
        
        [vMob mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.and.bottom.equalTo(vContent);
        }];
        
        [vMob updateWithModelDict:@{@"plan_value" : @10185,
                                    @"existing_value" : @12842,
                                    @"Active" : @86,
                                    @"Transit" : @27,
                                    @"Vehicle" : @47}];
        
    } else if (index == 1) {
        // Show Land use view
        LandUseView *vLU = [[LandUseView alloc] init];
        vLU.backgroundColor = COLOR_BG_WHITE;
        [vContent addSubview:vLU];
        
        [vLU mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.and.bottom.equalTo(vContent);
        }];
        
        [vLU updateWithModelDict:@{@"people_value" : @208,
                                   @"dwelling_value" : @107,
                                   @"Single detached" : @0,
                                   @"Rowhouse" : @37,
                                   @"Apartment" : @63}];
        
    } else {
        // Show Data Unavailable
        UnavailableView *vUnav = [[UnavailableView alloc] initWithInfoText:@"Sorry, the requested information is currently unavailable."];
        vUnav.backgroundColor = COLOR_BG_WHITE;
        [vContent addSubview:vUnav];
        
        [vUnav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.and.bottom.equalTo(vContent);
            
        }];
        
        [vUnav show];
    }
    
}

- (void) consumerThreadBegin {
    [[RabbitMQManager sharedInstance] beginConsumingWidgetsWithCallbackBlock:^(NSString *msg) {        
        // parse xml into a dictionary
        NSDictionary *dictTemp = [NSDictionary dictionaryWithXMLString:[msg stringByReplacingOccurrencesOfString:@"d2p1:" withString:@""]];
        NSArray *attributes = dictTemp[@"ResultDict"][@"KeyValueOfstringstring"];

        NSMutableDictionary *dictModel = [NSMutableDictionary dictionary];
        [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *temp = obj;
            dictModel[temp[@"Key"]] = temp[@"Value"];
        }];

        NSString *urlBase = dictModel[@"_url_base"];

        if ([urlBase containsString:WIDGET_DENSITY]){

        } else if ([urlBase containsString:WIDGET_BUILDINGS]) {

        } else if ([urlBase containsString:WIDGET_DISTRICTENERGY]) {
            // not considering energy for now

        } else if ([urlBase containsString:WIDGET_ENERGY]) {
            // not considering energy for now

        } else {
            // error pop up? widget type undefined?
        }
        
        NSLog(@"message: %@", msg);
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
