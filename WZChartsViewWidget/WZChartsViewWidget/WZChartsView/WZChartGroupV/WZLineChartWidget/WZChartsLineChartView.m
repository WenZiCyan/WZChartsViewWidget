//
//  WZChartsLineChartView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/19.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsLineChartView.h"
#import "WZLineViewParams.h"

@implementation WZChartsLineChartViewPoint

- (instancetype)initLineChartViewPointX:(float)x pointY:(float)y maxY:(float)maxY zoomY:(float)zoomY {
    self = [super init];
    self.x = x;
    self.maxY = maxY;
    self.zoomY = zoomY;
    self.y = y*(self.zoomY/maxY);
    self.textY = y;
    return self;
}

@end

@interface WZChartsLineChartView() {

    // 滑动距离
    CGFloat _offestMoveX;
}

// 样式配置
@property (strong, nonatomic) WZLineViewParams *lineViewParams;

// 折线转折点数组
@property (nonatomic, strong) NSMutableArray<WZChartsLineChartViewPoint *> *pointArray;

// 渐变背景视图
@property (strong, nonatomic) UIView *gradientBkView;
// 渐变图层
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
// backShapeLayer
@property (strong, nonatomic) CAShapeLayer *backShapeLayer;

// 线条渐变背景视图
@property (strong, nonatomic) UIView *gradientLineBkView;
// 线条渐变图层
@property (strong, nonatomic) CAGradientLayer *gradientLineLayer;
// lineShapeLayer
@property (strong, nonatomic) CAShapeLayer *lineShapeLayer;

// 按钮数组
@property (strong, nonatomic) NSMutableArray<UIButton *> *pointBtnArray;
// 最后处于选中状态的按钮
@property (strong, nonatomic) UIButton  *lastPointBtn;
// 点击大范围按钮数组
@property (strong, nonatomic) NSMutableArray<UIButton *> *bigPointBtnArray;
// 最后处于选中状态的大范围按钮
@property (strong, nonatomic) UIButton  *lastbigPointBtn;


@end

@implementation WZChartsLineChartView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineViewParams = [WZLineViewParams new];
        [self.lineViewParams initDate];
        self.pointArray = [NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame lineViewParams:(WZLineViewParams *)lineViewParams pointArray:(NSMutableArray<WZChartsLineChartViewPoint *> *)pointArray {
    self = [super initWithFrame:frame];
    if (self) {
        if (lineViewParams) {
            self.lineViewParams = lineViewParams;
        } else {
            WZLineViewParams *params = [WZLineViewParams new];
            [params initDate];
            self.lineViewParams = params;
        }
        self.pointArray = pointArray.count?pointArray:[NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (void)baseViewCreate {
    _offestMoveX = 0;
    self.pointBtnArray = [NSMutableArray<UIButton *> arrayWithCapacity:0];
    self.bigPointBtnArray = [NSMutableArray<UIButton *> arrayWithCapacity:0];
    [self createGridYAxisLineWithCount:self.pointArray.count showCount:self.lineViewParams.lineShowCount ifShow:self.lineViewParams.ifShowY lineWidth:self.lineViewParams.lineYWidth lineColor:self.lineViewParams.lineYColor];
    [self createBottomTextViewWithHeight:self.lineViewParams.bottomHeight textColor:self.lineViewParams.textColor textFont:self.lineViewParams.textFont];
    if (self.lineViewParams.ifShowTopX) {
        [self createGridTopXAxisLineWithLineWidth:self.lineViewParams.lineTopXWidth lineColor:self.lineViewParams.lineTopXColor];
    }
    if (self.lineViewParams.ifShowBottomX) {
        [self createGridBottomXAxisLineWithLineWidth:self.lineViewParams.lineBottomXWidth lineColor:self.lineViewParams.lineBottomXColor];
    }
    [self createGradientBackgroundView];
    [self createGradientLineBackgroundView];
    [self updateLineChartViewMaxIncome:0];
}

#pragma mark ◎_◎ 创建渐变背景

- (void)createGradientBackgroundView {
    self.gradientBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisTotalWidth, self.yAxisHeight)];
    [self.scrollView addSubview:self.gradientBkView];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, self.xAxisWidth, self.yAxisHeight);
    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(0, 1.0);
    self.gradientLayer.colors = self.lineViewParams.bkLayerColors;
    [self.gradientBkView.layer addSublayer:self.gradientLayer];
    [self createBackView];
}

- (void)createBackView {
    self.backShapeLayer = [CAShapeLayer layer];
    self.gradientBkView.layer.mask = self.backShapeLayer;
}

#pragma mark ➶_➴ 创建渐变线条

- (void)createGradientLineBackgroundView {
    self.gradientLineBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisTotalWidth, self.yAxisHeight)];
    [self.scrollView addSubview:self.gradientLineBkView];
    
    self.gradientLineLayer = [CAGradientLayer layer];
    self.gradientLineLayer.frame = CGRectMake(0, 0, self.xAxisWidth, self.yAxisHeight);
    self.gradientLineLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLineLayer.endPoint = CGPointMake(1.0, 0.0);
    self.gradientLineLayer.colors = self.lineViewParams.lineLayerColors;
    [self.gradientLineBkView.layer addSublayer:self.gradientLineLayer];
    [self createLineView];
}

- (void)createLineView {
    self.lineShapeLayer = [CAShapeLayer layer];
    self.lineShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.lineShapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.lineShapeLayer.lineCap=kCALineCapRound;
    self.lineShapeLayer.lineWidth = self.lineViewParams.lineWidth;
    self.gradientLineBkView.layer.mask = self.lineShapeLayer;
}

#pragma mark @_@ 刷新折线图表

- (void)updateLineChartViewMaxIncome:(float)maxIncome {
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 更新存在组件
    for (int i = 0; i < self.pointBtnArray.count; i++) {
        WZChartsLineChartViewPoint *point = (WZChartsLineChartViewPoint *)self.pointArray[i];
        point.maxY = maxIncome;
        point.y = point.textY*(point.zoomY/point.maxY);
        UIButton *pointBtn = (UIButton *)self.pointBtnArray[i];
        pointBtn.frame = CGRectMake(self.yStartWidth+self.yEachWidth*(self.yTotalCount-i-1)-10, self.yAxisHeight - point.y - 10, 20, 20);
        // 大范围点击按钮
        UIButton *bkPoint = (UIButton *)self.bigPointBtnArray[i];
        bkPoint.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1), 0, self.yEachWidth, self.yAxisHeight);
    }
    // 添加新组件
    NSInteger lastbtnCount = self.pointBtnArray.count;
    [self.pointArray enumerateObjectsUsingBlock:^(WZChartsLineChartViewPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 折线
        if (idx == 0) {
            [path moveToPoint:CGPointMake(self.yEachWidth*(self.yTotalCount-idx-1)+self.yStartWidth, self.yAxisHeight - obj.y)];
        } else {
            [path addLineToPoint:CGPointMake(self.yEachWidth*(self.yTotalCount-idx-1)+self.yStartWidth, self.yAxisHeight - obj.y)];
        }
        if (idx >= lastbtnCount) {
            UIButton *pointBtn = self.lineViewParams.pointBtn;
            pointBtn.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1)+self.yStartWidth-10, self.yAxisHeight - obj.y - 10, 20, 20);
            pointBtn.tag = idx;
            [self.scrollView addSubview:pointBtn];
            [self.pointBtnArray addObject:pointBtn];
            
            // 大范围按钮
            UIButton *bkPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bkPointBtn.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1), 0, self.yEachWidth, self.yAxisHeight);
            bkPointBtn.tag = idx;
            [bkPointBtn addTarget:self action:@selector(pointBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:bkPointBtn];
            [self.bigPointBtnArray addObject:bkPointBtn];
        }
    }];
    self.lineShapeLayer.path = path.CGPath;
    // 背景
    [path addLineToPoint:CGPointMake(self.yEachWidth*(self.yTotalCount-self.pointBtnArray.count)+self.yStartWidth, self.yAxisHeight)];
    [path addLineToPoint:CGPointMake(self.yEachWidth*(self.yTotalCount-1)+self.yStartWidth, self.yAxisHeight)];
    [path closePath];
    self.backShapeLayer.path = path.CGPath;
}

#pragma mark ➶_➴ Event Response

- (void)pointBtnClick:(UIButton *)btn {
    UIButton *pointBtn = (UIButton *)self.pointBtnArray[btn.tag];
    [self updateClickLineChartViewStyle:pointBtn];
    if (_wzChartsLineChartViewDelegate && [_wzChartsLineChartViewDelegate respondsToSelector:@selector(wzChartsLineChartView:pointBtn:)]) {
        [_wzChartsLineChartViewDelegate wzChartsLineChartView:self pointBtn:pointBtn];
    }
}

#pragma mark ◎_◎ Private Method
// 跟新点击事件页面样式
- (void)updateClickLineChartViewStyle:(UIButton *)clickBtn {
    if (self.lastPointBtn && self.lastPointBtn != clickBtn && self.lastPointBtn.selected) {
        self.lastPointBtn.selected = !self.lastPointBtn.selected;
        self.lastLineShapeLayer.strokeColor = self.lineViewParams.lineYColor.CGColor;
        self.lastbottomTextLayer.foregroundColor =self.lineViewParams.textColor.CGColor;
    }
    clickBtn.selected = !clickBtn.selected;
    self.lastLineShapeLayer = (CAShapeLayer *)self.lineShapeLayerArray[clickBtn.tag];
    self.lastLineShapeLayer.strokeColor = clickBtn.selected?self.lineViewParams.lineYClickColor.CGColor:self.lineViewParams.lineYColor.CGColor;
    self.lastbottomTextLayer = (CATextLayer *)self.bottomTextLayerArray[clickBtn.tag];
    self.lastbottomTextLayer.foregroundColor = clickBtn.selected?self.lineViewParams.textClickColor.CGColor:self.lineViewParams.textColor.CGColor;
    self.lastPointBtn = clickBtn;
}

#pragma mark $_$ Public Method

// 添加数据点
- (void)updateLineChartViewWithPointArray:(NSMutableArray<WZChartsLineChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome {
    [self updateBottomTextViewWithTextArray:timeArray lineCount:pointArray.count];
    self.gradientLineBkView.frame = self.gradientBkView.frame = CGRectMake(0, 0, self.xAxisTotalWidth, self.yAxisHeight);
    self.pointArray = pointArray;
    [self updateLineChartViewMaxIncome:maxIncome];
}
// 滑动更新图表
- (void)updateSlideLineChart:(CGFloat)offestX {
    self.gradientLineLayer.frame = CGRectMake(offestX, 0, self.xAxisWidth, self.yAxisHeight);
    self.gradientLayer.frame = CGRectMake(offestX, 0, self.xAxisWidth, self.yAxisHeight);
}
// 更新点击事件
- (void)updateLineChartViewClickStatusWithTag:(NSInteger)clickTag {
    UIButton *clickBtn = (UIButton *)self.pointBtnArray[clickTag];
    [self updateClickLineChartViewStyle:clickBtn];
}
// 获取点击点坐标
- (CGPoint)getLineChartViewClickPointWithTag:(NSInteger)clickTag {
    UIButton *clickBtn = (UIButton *)self.pointBtnArray[clickTag];
    return CGPointMake(clickBtn.center.x, clickBtn.center.y);
}
// 获取点击点 UIButton
- (UIButton *)getLineChartViewClickPointWithBtn:(NSInteger)clickTag {
    return (UIButton *)self.pointBtnArray[clickTag];
}

#pragma mark ⚆_⚆ Get/Set

@end

