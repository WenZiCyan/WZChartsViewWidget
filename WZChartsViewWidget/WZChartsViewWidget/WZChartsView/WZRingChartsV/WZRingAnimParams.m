//
//  WZRingAnimParams.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZRingAnimParams.h"

#define WZRandomColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:((a)/1.0)] //颜色设置
#define WZHEIGHTOFSCREEN [[UIScreen mainScreen] bounds].size.height
#define WZWIDTHOFSCREEN [[UIScreen mainScreen] bounds].size.width
#define WZWIDTHRADIUS (WZWIDTHOFSCREEN/375.0)

@implementation WZRingAnimParams

-(void)initDate{
    /******************动画时间******************/

    // 是否显示动画
    self.ifAnimation = YES;
    // 时间
    self.animDuration = 1.0;

    /******************颜色******************/

    // 环形颜色列表
    self.colorRandom =[@[@[WZRandomColor(53, 234, 198, 1),WZRandomColor(14, 191, 225, 1)],
                         @[WZRandomColor(159, 241, 198, 1),
                         WZRandomColor(255, 204, 0, 1)],@[WZRandomColor(255, 178, 57, 1),WZRandomColor(255, 59, 48, 1)]]mutableCopy];
    
    // 背景的颜色列表
    self.backColorRandom =[@[@[WZRandomColor(249, 250, 252, 1),WZRandomColor(249, 250, 252, 1)],]mutableCopy];
    
    /******************尺寸******************/
    
    // 环个数
    self.ringCount = 3;
    
    // 环宽度
    self.ringWidth = 12.5*WZWIDTHRADIUS;
    
    // 环间距离
    self.ringDistance = 4.*WZWIDTHRADIUS;
    
    /******************其他******************/
    
    // 是否有背景环
    self.ifHasBack = YES;
}

@end
