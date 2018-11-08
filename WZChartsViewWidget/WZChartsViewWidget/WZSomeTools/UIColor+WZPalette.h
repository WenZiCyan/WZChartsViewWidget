//
//  UIColor+WZPalette.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/11/5.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WZPalette)

/**
 *
 *  十六进制加透明度
 *
 *  @param hexString 颜色的十六进制
 *  @param alpha     透明度
 *
 *  @return 返回UIColor
 */
+ (instancetype)colorFromHexString:(NSString *)hexString Alpha:(CGFloat)alpha;

/**
 *
 *  十六进制,6位长度不包含透明度，8位前2位是透明度，后面是颜色值
 *
 *  @param hexString 颜色的十六进制，如“#ffffff”或者#FFFFFFF
 *
 *  @return 返回UIColor类型
 */
+ (instancetype)colorFromHexString:(NSString *)hexString;

/**
 *
 *  通过传递包含r,g,b,a值的数组生成颜色
 *
 *  @param rgbaArray 包含R,G,B,A
 *
 *  @return 返回UIColor类型
 */
+ (instancetype)colorFromRGBAArray:(NSArray *)rgbaArray;



/**
 通过传入的值装换成颜色，比如255,255,255,1

 @param red 红色取值范围[0,255]
 @param green 绿色取值范围[0,255]
 @param blue 蓝色取值范围[0,255]
 @param alpha 透明度取值范围[0,1]
 @return UIColor
 */
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

/**
 *
 *  返回颜色所对应的十六进制值
 *
 *  @return 该颜色的十六进制
 */
- (NSString *)hexString;

/**
 *
 *  返回颜色所分别对应的R,G,B,A值
 *
 *  @return 包含R,G,B,A值的数组
 */
- (NSArray *)rgbaArray;

/**
 *
 *  返回红色数值
 *
 *  @return 红色值
 */
- (CGFloat)red;

/**
 *
 *  返回绿色数值
 *
 *  @return 绿色值
 */
- (CGFloat)green;

/**
 *
 *  返回蓝色值
 *
 *  @return 蓝色值
 */
- (CGFloat)blue;

/**
 *
 *  返回透明值
 *
 *  @return 透明值
 */
- (CGFloat)alpha;

/**
 *
 *  更改颜色的透明度
 *
 *  @param alpha 更改的透明度
 *
 *  @return 返回新的UIColor
 */
- (instancetype)changeAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
