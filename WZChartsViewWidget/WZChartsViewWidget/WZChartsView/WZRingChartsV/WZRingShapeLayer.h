//
//  WZRingShapeLayer.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZRingShapeLayer : CALayer

/**
 创建单个圆环

 @param frame 位置
 @param cellWidth 宽度
 @param colorArray y颜色
 @param radius 半径
 @return CALayer
 */
- (instancetype)init:(CGRect)frame cellWidth:(float)cellWidth colorArray:(NSArray <UIColor *> *)colorArray radius:(float)radius;

/**
 环动画

 @param percent 环百分比
 @param animation 是否动画
 @param duration 动画时间
 */
- (void)wzRingShapeLayerRingChangeWithPercent:(double)percent animation:(BOOL)animation duration:(float)duration;

@end

NS_ASSUME_NONNULL_END
