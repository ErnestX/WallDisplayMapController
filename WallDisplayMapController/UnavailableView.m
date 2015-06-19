//
//  UnavailableView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-17.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "UnavailableView.h"
#import "Masonry.h"

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
    lblMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    lblMessage.textColor = [UIColor darkTextColor];
    
    [self addSubview:lblMessage];
    
    __weak typeof(self) weakSelf = self;
    [lblMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(weakSelf);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
