//
//  WZChartsBaseBackView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/18.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsBaseBackView.h"

@interface WZChartsBaseBackView() {
    // yx轴线条是否显示
    BOOL _lineIfShow;
}
// 上 x 轴线条
@property (strong, nonatomic) CAShapeLayer *xTopShapeLayer;
// 下 x 轴线条
@property (strong, nonatomic) CAShapeLayer *xBottomShapeLayer;
// Y 轴显示条数
@property (assign, nonatomic) NSInteger yShowCounts;
// Y 轴总条数
@property (assign, nonatomic) NSInteger yTotalCounts;
// 背景
@property (strong, nonatomic) UIView *backLineView;
// 底部 text 高度 默认0
@property (assign, nonatomic) float bottomHeight;
// y 轴线宽
@property (assign, nonatomic) float lineYWidth;
// y 轴线颜色
@property (strong, nonatomic) UIColor *lineYColor;
// 下 X 轴坐标UIColor
@property (strong, nonatomic) UIColor *textColor;
// 下 X 轴坐标UIFont
@property (strong, nonatomic) UIFont *textFont;

@end

@implementation WZChartsBaseBackView

#pragma mark ❀_❀ LifeCycle

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.yShowCounts = 0;
        self.yTotalCounts = 0;
        self.bottomHeight = 0;
        self.lineYWidth = 1;
        self.lineYColor = [UIColor colorFromHexString:@"#eeeeee"];
        self.lineShapeLayerArray = [NSMutableArray<CAShapeLayer *> arrayWithCapacity:0];
        self.bottomTextLayerArray = [NSMutableArray<CATextLayer *> arrayWithCapacity:0];
        self.textColor = [UIColor colorFromHexString:@"#a7a7a7"];
        self.textFont = [UIFont fontWithName:@"DIN Alternate" size:13];
        [self.scrollView addSubview:self.backLineView];
    }
    return self;
}

#pragma mark @_@ 创建基础XY轴线

//创建Y轴线（默认0条）
-(void)createGridYAxisLineWithCount:(NSInteger)count showCount:(NSInteger)showCount ifShow:(BOOL)ifShow lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor {
    self.yShowCounts = showCount;
    self.yTotalCounts = count;
    self.lineYWidth = lineWidth?lineWidth:1;
    self.lineYColor = lineColor?lineColor:[UIColor colorFromHexString:@"#eeeeee"];
    _lineIfShow = ifShow;
    if (count <= showCount) {
        count = showCount;
    }
    self.scrollView.contentSize = CGSizeMake(self.xAxisTotalWidth+2, self.yAxisHeight);
}

//创建上X轴线（默认无）
-(void)createGridTopXAxisLineWithLineWidth:(float)lineWidth lineColor:(UIColor *)lineColor {
    UIBezierPath *xLinePath = [UIBezierPath bezierPath];
    [xLinePath moveToPoint:CGPointMake(0, 0)];
    [xLinePath addLineToPoint:CGPointMake(self.xAxisTotalWidth, 0)];
    
    self.xTopShapeLayer = [CAShapeLayer layer];
    self.xTopShapeLayer.path = xLinePath.CGPath;
    self.xTopShapeLayer.lineWidth = lineWidth;
    self.xTopShapeLayer.strokeColor = lineColor.CGColor;
    [self.backLineView.layer addSublayer:self.xTopShapeLayer];
}

//创建下X轴线（默认无）
-(void)createGridBottomXAxisLineWithLineWidth:(float)lineWidth lineColor:(UIColor *)lineColor {
    UIBezierPath *xLinePath = [UIBezierPath bezierPath];
    [xLinePath moveToPoint:CGPointMake(0, self.yAxisHeight)];
    [xLinePath addLineToPoint:CGPointMake(self.xAxisTotalWidth, self.yAxisHeight)];
    
    self.xBottomShapeLayer = [CAShapeLayer layer];
    self.xBottomShapeLayer.path = xLinePath.CGPath;
    self.xBottomShapeLayer.lineWidth = lineWidth;
    self.xBottomShapeLayer.strokeColor = lineColor.CGColor;
    [self.backLineView.layer addSublayer:self.xBottomShapeLayer];
}

- (void)createBottomTextViewWithHeight:(float)height textColor:(UIColor *)textColor textFont:(UIFont *)textFont {
    self.bottomHeight = height;
    self.textColor = textColor?textColor:[UIColor colorFromHexString:@"#a7a7a7"];
    self.textFont = textFont?textFont:[UIFont fontWithName:@"DIN Alternate" size:13];
}

- (void)updateBottomTextViewWithTextArray:(NSMutableArray<NSString *> *)textArray lineCount:(NSInteger)lineCount {
    if (textArray.count) {
        self.yTotalCounts = textArray.count;
    } else {
        self.yTotalCounts = lineCount;
    }
    if (textArray.count) {
        for (int i = 0; i < self.bottomTextLayerArray.count; i++) {
            CATextLayer *textLayer = (CATextLayer *)self.bottomTextLayerArray[i];
            textLayer.frame = CGRectMake(self.yEachWidth*(self.yTotalCounts-i-1), textLayer.frame.origin.y, self.yEachWidth, self.bottomHeight);
        }
        NSInteger startCount = self.bottomTextLayerArray.count;
        for (NSInteger i = startCount; i< self.yTotalCounts; i++) {
            CATextLayer *textLayers = [self normalTextLayer];
            CGRect sizeToFit = [@"xx-xx" boundingRectWithSize:CGSizeMake(self.yEachWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil];
            textLayers.frame = CGRectMake(self.yEachWidth*(self.yTotalCounts-i-1), self.yAxisHeight+(self.bottomHeight/2.-sizeToFit.size.height/2.), self.yEachWidth, self.bottomHeight);
            textLayers.string = (i-startCount)<textArray.count?(NSString *)textArray[i]:@"00";
            [self.backLineView.layer addSublayer:textLayers];
            [self.bottomTextLayerArray addObject:textLayers];
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.xAxisTotalWidth+2, self.yAxisHeight);
    
    for (int i = 0; i < self.lineShapeLayerArray.count; i++) {
        CAShapeLayer *lineLayer = (CAShapeLayer *)self.lineShapeLayerArray[i];
        UIBezierPath *borderLinePath = [UIBezierPath bezierPath];
        [borderLinePath moveToPoint:CGPointMake(self.yEachWidth*(self.yTotalCounts-i-1)+self.yStartWidth, 0)];
        [borderLinePath addLineToPoint:CGPointMake(self.yEachWidth*(self.yTotalCounts-i-1)+self.yStartWidth, self.yAxisHeight)];
        lineLayer.path = borderLinePath.CGPath;
    }
    NSInteger lineStartCount = self.lineShapeLayerArray.count;
    for (NSInteger i = lineStartCount; i < self.yTotalCounts; i++) {
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = _lineIfShow?self.lineYColor.CGColor:[UIColor clearColor].CGColor;
        border.fillColor = nil;
        UIBezierPath *borderLinePath = [UIBezierPath bezierPath];
        [borderLinePath moveToPoint:CGPointMake(self.yEachWidth*(self.yTotalCounts-i-1)+self.yStartWidth, 0)];
        [borderLinePath addLineToPoint:CGPointMake(self.yEachWidth*(self.yTotalCounts-i-1)+self.yStartWidth, self.yAxisHeight)];
        border.path = borderLinePath.CGPath;
        border.lineWidth = self.lineYWidth;
        [self.backLineView.layer addSublayer:border];
        [self.lineShapeLayerArray addObject:border];
    }

    if (self.xBottomShapeLayer) {
        UIBezierPath *xLinePath = [UIBezierPath bezierPath];
        [xLinePath moveToPoint:CGPointMake(0, self.yAxisHeight)];
        [xLinePath addLineToPoint:CGPointMake(self.xAxisTotalWidth, self.yAxisHeight)];
        
        self.xBottomShapeLayer.path = xLinePath.CGPath;
    }
    if (self.xTopShapeLayer) {
        UIBezierPath *xLinePath = [UIBezierPath bezierPath];
        [xLinePath moveToPoint:CGPointMake(0, 0)];
        [xLinePath addLineToPoint:CGPointMake(self.xAxisTotalWidth, 0)];

        self.xTopShapeLayer.path = xLinePath.CGPath;
    }
}

#pragma mark ⚆_⚆ Get/Set

- (CATextLayer *)normalTextLayer {
    CATextLayer *normalTextLayer = [CATextLayer layer];
    UIFont *font = self.textFont;
    CFStringRef fontCFString = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontCFString);
    normalTextLayer.font = fontRef;
    normalTextLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    normalTextLayer.wrapped = YES;
    normalTextLayer.alignmentMode = kCAAlignmentCenter;
    normalTextLayer.contentsScale = [UIScreen mainScreen].scale;
    normalTextLayer.foregroundColor = self.textColor.CGColor;
    return normalTextLayer;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, 0, self.xAxisWidth, self.yAxisHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)backLineView {
    if (!_backLineView) {
        _backLineView = [UIView new];
        _backLineView.frame = CGRectMake(0, 0, self.xAxisWidth, self.yAxisHeight);
    }
    return _backLineView;
}

#pragma mark ◎_◎ 返回宽度
- (CGFloat)xAxisWidth {
    return self.frame.size.width;
}

#pragma mark ◎_◎ 返回总宽度
- (CGFloat)xAxisTotalWidth {
    if (self.yTotalCount <= self.yShowCount) {
        return self.yShowCount*self.yEachWidth;
    }
    return self.yTotalCount*self.yEachWidth;
}

#pragma mark $_$ 返回高度
- (CGFloat)yAxisHeight {
    return self.frame.size.height - self.bottomHeight;
}

#pragma mark ⚆_⚆ 返回显示Y轴条数
- (NSInteger)yShowCount {
    return self.yShowCounts;
}

#pragma mark ⚆_⚆ 返回Y轴条数
- (NSInteger)yTotalCount {
    return self.yTotalCounts;
}

#pragma mark ➶_➴ 图表y轴起始位置

- (CGFloat)yStartWidth {
    return self.yEachWidth/2.;
}

#pragma mark ✪_✪ 图表y轴间距

- (CGFloat)yEachWidth {
    if (self.yShowCount) {
        return self.frame.size.width/self.yShowCount;
    }
    return self.frame.size.width;
}

@end
