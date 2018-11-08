//
//  WZColumnView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/11/5.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZColumnView.h"
#import "WZColumnViewParams.h"

@interface WZColumnView() <CAAnimationDelegate>

// 渐变背景
@property (strong, nonatomic) CAGradientLayer *wzColumGradientLayer;
// 遮照
@property (strong, nonatomic) CAShapeLayer *wzColumShapeLayer;
// 样式配置
@property (strong, nonatomic) WZColumnViewParams *columnViewParams;

@property (retain, nonatomic) CABasicAnimation *animation;

@end

@implementation WZColumnView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.columnViewParams = [WZColumnViewParams new];
        [self.columnViewParams initDate];
        [self createCellSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams {
    self = [super initWithFrame:frame];
    if (self) {
        self.columnViewParams = columnViewParams;
        [self createCellSubView];
    }
    return self;
}

- (void)createCellSubView {
    self.alpha = self.columnViewParams.viewAlpha;

    // 渐变
    self.wzColumGradientLayer = [CAGradientLayer layer];
    self.wzColumGradientLayer.startPoint = CGPointMake(0, 0.0);
    self.wzColumGradientLayer.endPoint = CGPointMake(0, 1.0);
    self.wzColumGradientLayer.colors = self.columnViewParams.colorRandom;
    [self.layer addSublayer:self.wzColumGradientLayer];
    
    // 遮照
    self.wzColumShapeLayer = [CAShapeLayer layer];
    self.wzColumShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.wzColumShapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.wzColumShapeLayer.lineCap=kCALineCapRound;
    self.wzColumShapeLayer.lineWidth = self.columnViewParams.lineWidth;
    self.layer.mask = self.wzColumShapeLayer;
}

#pragma mark @_@ Delegate

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

#pragma mark $_$ Public Method

- (void)updateWZColumnViewWithShapePath:(UIBezierPath *)shapePath gradientFrame:(CGRect)gradientFrame {
    self.wzColumGradientLayer.frame = gradientFrame;
    self.wzColumShapeLayer.path = shapePath.CGPath;
    if (self.columnViewParams.ifAnimation) {
        [self.wzColumShapeLayer addAnimation:self.animation forKey:@"strokeEnd"];
    }
}

#pragma mark ⚆_⚆ Get/Set

- (CABasicAnimation *)animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _animation.delegate = self;
        _animation.duration = self.columnViewParams.animDuration;
        _animation.fromValue = [NSNumber numberWithInteger:0];
        _animation.toValue = [NSNumber numberWithInteger:1];
    }
    return _animation;
}

@end
