//
//  UnavailableView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-17.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "UnavailableView.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"
#import "PNChart.h"


@interface UnavailableView()

@property NSString *errorMessage;

@end

@implementation UnavailableView

- (instancetype)initWithInfoText:(NSString *)text {
    self = [super init];
    if (self) {
        
        self.errorMessage = text;
        self.backgroundColor = [UIColor lightTextColor];
        
    }
    return self;
}

- (void)show {
    UILabel *lblMessage = [[UILabel alloc] init];
    lblMessage.text = self.errorMessage;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 0;
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    lblMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    lblMessage.textColor = [UIColor grayColor];
    
    [self addSubview:lblMessage];
    
    DEFINE_WEAK_SELF
    [lblMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.width.equalTo(weakSelf.mas_width).with.offset(-35.0f);
    }];
}

@end
