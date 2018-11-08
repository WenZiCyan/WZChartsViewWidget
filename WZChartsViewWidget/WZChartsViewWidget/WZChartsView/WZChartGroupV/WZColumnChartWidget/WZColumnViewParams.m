//
//  WZColumnViewParams.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/11/5.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZColumnViewParams.h"
#import "UIColor+WZPalette.h"

#define WZRandomColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:((a)/1.0)] //颜色设置
#define WZHEIGHTOFSCREEN [[UIScreen mainScreen] bounds].size.height
#define WZWIDTHOFSCREEN [[UIScreen mainScreen] bounds].size.width
#define WZWIDTHRADIUS (WZWIDTHOFSCREEN/375.0)

@implementation WZColumnViewParams

-(void)initDate{
    /******************动画******************/
    
    // 是否显示动画
    self.ifAnimation = YES;
    // 时间
    self.animDuration = 1.0;
    
    /******************XY 坐标样式******************/
    
    // 上 X 轴
    self.ifShowTopX = YES;
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
    self.bottomHeight = 0;
    // 下 X 轴坐标UIFont
    self.textFont = [UIFont fontWithName:@"DIN Alternate" size:13];
    // 下 X 轴坐标UIColor
    self.textColor = [UIColor colorFromHexString:@"#a7a7a7"];
    
    // Y 轴线选中色
    self.lineYClickColor = [UIColor colorFromHexString:@"#c3f7d9"];
    // 下 X 轴坐标选中色
    self.textClickColor = [UIColor colorFromHexString:@"#0ecaa7"];
    
    /******************颜色******************/
    
    // 颜色列表
    self.colorRandom = [@[(__bridge id)WZRandomColor(53, 234, 198, 1).CGColor,(__bridge id)WZRandomColor(14, 191, 225, 1).CGColor]mutableCopy];
    
    /******************尺寸******************/
    
    // 宽度
    self.lineWidth = 10;
    
    /******************其他******************/
    
    // 一屏显示个数
    self.lineShowCount = 5;
    // 透明度
    self.viewAlpha = 0.3;
    // 柱形偏移
    self.lineDis = 2+self.lineWidth/2;
}

@end
