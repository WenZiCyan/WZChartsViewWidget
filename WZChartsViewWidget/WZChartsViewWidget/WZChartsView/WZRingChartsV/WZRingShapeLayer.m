//
//  WZRingShapeLayer.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZRingShapeLayer.h"

@interface WZRingShapeLayer() <CAAnimationDelegate>

@property (strong, nonatomic) CAShapeLayer *maskShapeLayer;

@property (assign, nonatomic) float radious;

@property (assign, nonatomic) float cellWidth;

@property (assign, nonatomic) NSArray <UIColor *> *colorArray;

@property (assign, nonatomic) float endAngle;

@property (retain, nonatomic) CABasicAnimation *animation;

@end

@implementation WZRingShapeLayer

#pragma mark ❀_❀ LifeCycle

- (instancetype)init:(CGRect)frame cellWidth:(float)cellWidth colorArray:(NSArray <UIColor *> *)colorArray radius:(float)radius {
    self = [super init];
    if (self) {
        self.endAngle = 3*M_PI/2.;
        self.radious = radius;
        self.colorArray = colorArray;
        self.cellWidth = cellWidth;
        self.frame = frame;
        [self initLayers];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder cellWidth:(float)cellWidth colorArray:(NSArray <UIColor *> *)colorArray radius:(float)radius {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.endAngle = 3*M_PI/2.;
        self.radious = radius;
        self.colorArray = colorArray;
        self.cellWidth = cellWidth;
        [self initLayers];
    }
    return self;
}

-(void)initLayers{
    // 背景色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.colors = @[(id)(UIColor *)self.colorArray[0].CGColor, (id)(UIColor *)self.colorArray[1].CGColor];
    [self addSublayer:gradientLayer];
    
    self.mask = self.maskShapeLayer;
}

#pragma mark @_@ Delegate

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

#pragma mark $_$ Public Method

- (void)wzRingShapeLayerRingChangeWithPercent:(double)percent animation:(BOOL)animation duration:(float)duration {
    self.animation.duration = duration;
    percent = (percent > 0.99 && percent < 1) ? 0.99 : percent;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.radious startAngle:self.endAngle endAngle:self.endAngle+M_PI*2*percent clockwise:YES];
    _maskShapeLayer.path = path.CGPath;
    _animation.fromValue = [NSNumber numberWithInteger: animation ? 0 : 1];
    [self.maskShapeLayer addAnimation:_animation forKey:@"strokeEnd"];
}

#pragma mark ⚆_⚆ Get/Set

- (CAShapeLayer *)maskShapeLayer {
    if (!_maskShapeLayer) {
        _maskShapeLayer = [CAShapeLayer layer];
        _maskShapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _maskShapeLayer.lineWidth = self.cellWidth;
        _maskShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _maskShapeLayer.strokeColor = [UIColor blackColor].CGColor;
        _maskShapeLayer.lineCap = kCALineCapRound;
    }
    return _maskShapeLayer;
}

- (CABasicAnimation *)animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _animation.delegate = self;
        _animation.duration = 1.f;
        _animation.fromValue = [NSNumber numberWithInteger:0];
        _animation.toValue = [NSNumber numberWithInteger:1];
    }
    return _animation;
}

@end
