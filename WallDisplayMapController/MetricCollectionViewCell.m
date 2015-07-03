//
//  MetricCollectionViewCell.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-03.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "MetricCollectionViewCell.h"
#import "DroppableChart.h"

@implementation MetricCollectionViewCell {
    DroppableChart *chart;
    UILabel *lblTest;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        chart = [[DroppableChart alloc] initWithFrame:frame];
        lblTest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
        lblTest.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
        lblTest.backgroundColor = [UIColor whiteColor];
        lblTest.font = [UIFont systemFontOfSize:25.0];
        lblTest.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:chart];
        [self.contentView addSubview:lblTest];
        
        
    }
    return self;
}


- (void)updateWithData:(NSDictionary *)dict {
    lblTest.text = dict[@"test"];
}

@end
