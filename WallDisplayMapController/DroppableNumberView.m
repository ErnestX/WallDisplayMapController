//
//  DroppableNumberView.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-07-14.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableNumberView.h"
#import "Masonry.h"
#import <Chameleon.h>

@implementation DroppableNumberView {
    
    UILabel *lblMain;
    UILabel *lblSub;
    UILabel *lblDesc;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ClearColor;//COLOR_BG_WHITE;
        
        lblMain = [[UILabel alloc] init];
        lblMain.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:60.0];
        
        lblSub = [[UILabel alloc] init];
        lblSub.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:27.0];
        lblSub.textColor = [UIColor lightGrayColor];
        
        lblDesc = [[UILabel alloc] init];
        lblDesc.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:15.0];
        lblDesc.numberOfLines = 0;
        lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
        lblDesc.textColor = [UIColor lightGrayColor];
        
        [self addSubview:lblMain];
        [self addSubview:lblSub];
        [self addSubview:lblDesc];
        
        DEFINE_WEAK_SELF
        [lblMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf).with.offset(20.0f);
            make.top.equalTo(weakSelf).with.offset(30.0f);
        }];
        
        [lblSub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lblMain);
            make.top.equalTo(lblMain.mas_baseline).with.offset(10.0f);
        }];
        
        [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf).with.offset(-20.0f);
            make.leading.equalTo(lblMain);
            make.top.equalTo(lblSub.mas_baseline).with.offset(6.0f);
        }];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame target:(UIView *)target delegate:(id)delegate {
    
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addDropTarget:target];
        
    }
    return self;
    
}

- (void)updateWithMainMeasure:(NSString *)main subMeasure:(NSString *)sub description:(NSString *)desc type:(NSString *)type {
    
    lblMain.textColor = DICT_COLOR_TYPE[type];
    lblMain.text = main;
    lblDesc.text = desc;
    if (sub) lblSub.text = sub;

}



@end
