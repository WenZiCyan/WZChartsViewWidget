//
//  CALayer+ShadowRadius.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/11.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "CALayer+ShadowRadius.h"

@implementation CALayer (ShadowRadius)

- (CALayer *)setCustomShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity shadowRect:(CGRect)shadowRect superV:(UIView *)superV {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, shadowRect);
    superV.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    superV.layer.shadowColor = shadowColor.CGColor;
    superV.layer.shadowOffset = shadowOffset;
    superV.layer.shadowRadius = shadowRadius?shadowRadius:5;
    superV.layer.shadowOpacity = shadowOpacity?shadowOpacity:1;
    superV.clipsToBounds = NO;
    return superV.layer;
}

- (CALayer *)setCornerRadius:(CGSize)cornerRadius roundingCorners:(UIRectCorner)roundingCorners shadowRect:(CGRect)shadowRect superV:(UIView *)superV {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect byRoundingCorners:roundingCorners cornerRadii:cornerRadius];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    [superV.layer insertSublayer:maskLayer atIndex:0];
    return superV.layer;
}

- (CALayer *)setNormalShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity superV:(UIView *)superV {
    superV.layer.shadowColor = shadowColor.CGColor;
    superV.layer.shadowOffset = shadowOffset;
    superV.layer.shadowRadius = shadowRadius?shadowRadius:5;
    superV.layer.shadowOpacity = shadowOpacity?shadowOpacity:1;
    return superV.layer;
}

- (CALayer *)setPathShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius shadowOpacity:(float)shadowOpacity path:(UIBezierPath *)path superV:(UIView *)superV {
    superV.layer.shadowPath = path.CGPath;
    superV.layer.shadowColor = shadowColor.CGColor;
    superV.layer.shadowOffset = shadowOffset;
    superV.layer.shadowRadius = shadowRadius?shadowRadius:5;
    superV.layer.shadowOpacity = shadowOpacity?shadowOpacity:1;
    superV.clipsToBounds = NO;
    return superV.layer;
}

@end
