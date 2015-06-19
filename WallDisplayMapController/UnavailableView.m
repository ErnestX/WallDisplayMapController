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
        
    }
    return self;
}

- (void)show {
    UILabel *lblMessage = [[UILabel alloc] init];
    lblMessage.text = self.errorMessage;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 0;
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    lblMessage.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25.0];
    lblMessage.textColor = [UIColor lightGrayColor];
    
    [self addSubview:lblMessage];
    
    __weak typeof(self) weakSelf = self;
    [lblMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(weakSelf);
    }];
}

@end
