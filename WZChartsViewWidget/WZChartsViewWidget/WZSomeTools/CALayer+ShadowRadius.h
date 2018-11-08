//
//  CALayer+ShadowRadius.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/11.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ShadowRadius)

// 设置阴影(知道bounds那种) 没有离屏渲染
- (CALayer *)setCustomShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity shadowRect:(CGRect)shadowRect superV:(UIView *)superV;

// 设置阴影(不知道bounds那种) 有离屏渲染
- (CALayer *)setNormalShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity superV:(UIView *)superV;

// 设置阴影(路径自定) 没有离屏渲染
- (CALayer *)setPathShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity path:(UIBezierPath *)path superV:(UIView *)superV;

// 设置圆角 没有离屏渲染
- (CALayer *)setCornerRadius:(CGSize)cornerRadius roundingCorners:(UIRectCorner)roundingCorners shadowRect:(CGRect)shadowRect superV:(UIView *)superV;

@end

NS_ASSUME_NONNULL_END
