//
//  DroppableCircleChart.m
//  WallDisplayMapController
//
//  Created by Siyi Meng on 2015-06-26.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "DroppableCircleChart.h"
#import "PNChart.h"
#import "UIColor+Extend.h"
#import <ChameleonFramework/Chameleon.h>

const CGFloat CIRCLE_EDGE_INSET = 40.0;

@implementation DroppableCircleChart {
    PNCircleChart *circleChart;
    NSDictionary *dictTitle;
    
    UIView *imageBg;
    UIImageView *ivIcon;
    UILabel *lblTitle;
    UILabel *lblPercent;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        double sideLength = self.frame.size.width-2*CIRCLE_EDGE_INSET;
        
        dictTitle = @{@"single" : @"Single attached",
                      @"rowhouse" : @"Rowhouse",
                      @"apart" : @"Apartment",
                      @"active_pct" : @"Active",
                      @"transit_pct" : @"Transit",
                      @"vehicle_pct" : @"Vehicle",
                      @"rez" : @"Residential",
                      @"comm" : @"Commercial",
                      @"civic" : @"Civic",
                      @"ind" : @"Industrial",
                      @"heating_icon.png" : @"Heating + Hot water",
                      @"lights_icon.png" : @"Lights + Appliances",
                      @"mobility_icon.png" : @"Personal Mobility"
                      };
        
        circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(CIRCLE_EDGE_INSET-10.0, CIRCLE_EDGE_INSET+10.0, sideLength, sideLength)
                                                                    total:@100
                                                                  current:@0
                                                                clockwise:YES
                                                                   shadow:YES
                                                              shadowColor:[UIColor colorFromHexString:@"#e3e3e3"]
                                                     displayCountingLabel:NO
                                                        overrideLineWidth:[NSNumber numberWithFloat:sideLength*0.20]];
        circleChart.backgroundColor = ClearColor;//COLOR_BG_WHITE;
        self.backgroundColor = ClearColor;//COLOR_BG_WHITE;
        circleChart.userInteractionEnabled = NO;
        [self addSubview:circleChart];
        
        // Init Icons
        imageBg= [[UIView alloc] initWithFrame:CGRectMake(0, 0, sideLength*0.48, sideLength*0.48)];
        imageBg.layer.cornerRadius = (sideLength*0.48)/2;
        imageBg.layer.masksToBounds = YES;
        ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sideLength*0.33, sideLength*0.33)];
        imageBg.center = circleChart.center;
        ivIcon.center = imageBg.center;
        [self addSubview:imageBg];
        [self addSubview:ivIcon];
        
        // Init Labels
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30.0)];
        lblTitle.center = CGPointMake(circleChart.center.x, 25.0);
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:20.0];
        [self addSubview:lblTitle];
        
        lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(sideLength*0.75, sideLength*1.1, 100.0, 50.0)];
        lblPercent.textAlignment = NSTextAlignmentRight;
        lblPercent.textColor = [UIColor lightGrayColor];
        lblPercent.font = [UIFont fontWithName:FONT_HELVETICA_NEUE_CONDENSEDBOLD size:28.0];
        [self addSubview:lblPercent];

    }
    return self;
}

- (void)updateCircleChartWithCurrent:(NSNumber *)current type:(NSString *)type icon:(NSString *)iconName {
        
    [circleChart setStrokeColor:DICT_COLOR_TYPE[type]];
    [circleChart strokeChart];
    [circleChart updateChartByCurrent:current];
    
    
    // Update Icons
    UIImage *imgIcon = [UIImage imageNamed:iconName];
    if (imgIcon) {
        imageBg.backgroundColor = DICT_COLOR_TYPE[type];
        ivIcon.image = [UIImage imageNamed:iconName];
        ivIcon.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        imageBg.alpha = 0.0;
        lblPercent.textAlignment = NSTextAlignmentCenter;
        lblPercent.center = ivIcon.center;
    }
    


    // Update Labels
    lblTitle.text = dictTitle[iconName];
    lblPercent.text = [NSString stringWithFormat:@"%d%%", [current intValue]];
}

- (void)setShadowColor:(UIColor *)color {
    circleChart.circleBackground.strokeColor = color.CGColor;
}

- (void)clearBg {
    self.backgroundColor = ClearColor;
    circleChart.backgroundColor = ClearColor;
}

- (void)changeTextColorTo:(UIColor *)color {
    lblTitle.textColor = color;
    lblPercent.textColor = color;
}

@end
