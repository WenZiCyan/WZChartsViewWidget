//
//  WZLineViewParams.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/7.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZLineViewParams.h"
#import "UIColor+WZPalette.h"

@implementation WZLineViewParams

- (id)mutableCopyWithZone:(NSZone *)zone {
    WZLineViewParams *params = [[[self class] allocWithZone:zone] init];
    params.ifAnimation = self.ifAnimation;
    params.animDuration = self.animDuration;
    params.ifShowTopX = self.ifShowTopX;
    params.lineTopXWidth = self.lineTopXWidth;
    params.lineTopXColor = self.lineTopXColor;
    params.ifShowBottomX = self.ifShowBottomX;
    params.lineBottomXWidth = self.lineBottomXWidth;
    params.lineBottomXColor = self.lineBottomXColor;
    params.ifShowY = self.ifShowY;
    params.lineYWidth = self.lineYWidth;
    params.lineYColor = self.lineYColor;
    params.bottomHeight = self.bottomHeight;
    params.textFont = self.textFont;
    params.textColor = self.textColor;
    params.lineYClickColor = self.lineYClickColor;
    params.textClickColor = self.textClickColor;
    params.bkLayerColors = self.bkLayerColors;
    params.lineLayerColors = self.lineLayerColors;
    params.lineWidth = self.lineWidth;
    params.lineShowCount = self.lineShowCount;
    params.bkLayerColors = self.bkLayerColors;
    return params;
}

- (id)copyWithZone:(NSZone *)zone {
    WZLineViewParams *params = [[[self class] allocWithZone:zone] init];
    params.ifAnimation = self.ifAnimation;
    params.animDuration = self.animDuration;
    params.ifShowTopX = self.ifShowTopX;
    params.lineTopXWidth = self.lineTopXWidth;
    params.lineTopXColor = self.lineTopXColor;
    params.ifShowBottomX = self.ifShowBottomX;
    params.lineBottomXWidth = self.lineBottomXWidth;
    params.lineBottomXColor = self.lineBottomXColor;
    params.ifShowY = self.ifShowY;
    params.lineYWidth = self.lineYWidth;
    params.lineYColor = self.lineYColor;
    params.bottomHeight = self.bottomHeight;
    params.textFont = self.textFont;
    params.textColor = self.textColor;
    params.lineYClickColor = self.lineYClickColor;
    params.textClickColor = self.textClickColor;
    params.bkLayerColors = self.bkLayerColors;
    params.lineLayerColors = self.lineLayerColors;
    params.lineWidth = self.lineWidth;
    params.lineShowCount = self.lineShowCount;
    params.bkLayerColors = self.bkLayerColors;
    return params;
}

-(void)initDate {
    /******************动画******************/
    
    // 是否显示动画
    self.ifAnimation = YES;
    
    // 时间
    self.animDuration = 1;
    
    /******************XY 坐标样式******************/
    
    // 上 X 轴
    self.ifShowTopX = NO;
    self.lineTopXWidth = 1;
    self.lineTopXColor = [UIColor colorFromHexString:@"#eeeeee"];
    
    // 下 X 轴
    self.ifShowBottomX = YES;
    self.lineBottomXWidth = 1;
    self.lineBottomXColor = [UIColor colorFromHexString:@"#eeeeee"];
    
    // Y 轴
    self.ifShowY = YES;
    self.lineYWidth = 1;
    self.lineYColor = [UIColor colorFromHexString:@"#eeeeee"];
    
    // 下 X 轴坐标
    self.bottomHeight = 30;
    // 下 X 轴坐标UIFont
    self.textFont = [UIFont fontWithName:@"DIN Alternate" size:13];
    // 下 X 轴坐标UIColor
    self.textColor = [UIColor colorFromHexString:@"#a7a7a7"];
    
    // Y 轴线选中色
    self.lineYClickColor = [UIColor colorFromHexString:@"#c3f7d9"];
    // 下 X 轴坐标选中色
    self.textClickColor = [UIColor colorFromHexString:@"#0ecaa7"];
    
    /******************颜色******************/
    
    // 折线颜色数组
    self.lineLayerColors = [@[(__bridge id)[UIColor colorFromHexString:@"#2cce8b"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#1fe741"].CGColor]mutableCopy];
    
    // 背景颜色数组
    self.bkLayerColors = [@[(__bridge id)[UIColor colorFromHexString:@"#a9fdd4"].CGColor,(__bridge id)[[UIColor colorFromHexString:@"#a9fdd4"] colorWithAlphaComponent:0].CGColor]mutableCopy];
    
    /******************尺寸******************/
    
    // 宽度
    self.lineWidth = 2;
    
    /******************其他******************/
    
    // 一屏显示个数
    self.lineShowCount = 5;
    
}

// 折点按钮
- (UIButton *)pointBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"img_dayearn_unpoint"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"img_dayearn_unpoint"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"img_dayearn_point_light"] forState:UIControlStateSelected];
    return btn;
}

@end
