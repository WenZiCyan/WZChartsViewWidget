//
//  UIColor+WZPalette.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/11/5.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "UIColor+WZPalette.h"

@implementation UIColor (WZPalette)

+ (instancetype)colorFromHexString:(NSString *)hexString Alpha:(CGFloat)alpha
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:alpha];
}

+ (instancetype)colorFromHexString:(NSString *)hexString
{
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (hexString.length == 6) {
        return [self colorFromHexString:hexString Alpha:1.0];
    }
    else
    {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&rgbValue];
        return [[self class] colorWithR:((rgbValue & 0x00FF0000) >> 16) G:((rgbValue & 0x00FF00) >> 8) B:(rgbValue & 0xFF) A:((rgbValue & 0xFF000000) >>24)/255.0f];
    }
}

+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (instancetype)colorFromRGBAArray:(NSArray *)rgbaArray
{
    if (rgbaArray.count < 4) {
        return [[self class] clearColor];
    }
    return [[self class] colorWithR:[rgbaArray[0] floatValue] G:[rgbaArray[1] floatValue] B:[rgbaArray[2] floatValue] A:[rgbaArray[3] floatValue]];
}

- (NSArray *)rgbaArray
{
    
    CGFloat r=0,g=0,b=0,a=0;
    //判断是否存在getRed:green:blue:alpha:这个方法，有就通过这个方法获取RGBA的值
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        //返回数组
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @[@(r),@(g),@(b),@(a)];
}
- (NSString *)hexString
{
    NSArray *colorArray    = [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (CGFloat)red
{
    return [[self rgbaArray][0] floatValue];
}

- (CGFloat)green
{
    return [[self rgbaArray][1] floatValue];
}

- (CGFloat)blue
{
    return [[self rgbaArray][2] floatValue];
}

- (CGFloat)alpha
{
    return [[self rgbaArray][3] floatValue];
}

- (instancetype)changeAlpha:(CGFloat)alpha
{
    return [self colorWithAlphaComponent:alpha];
}

@end
