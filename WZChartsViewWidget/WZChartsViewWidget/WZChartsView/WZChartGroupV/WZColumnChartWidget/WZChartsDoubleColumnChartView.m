//
//  WZChartsDoubleColumnChartView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/19.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsDoubleColumnChartView.h"
#import "WZColumnViewParams.h"
#import "WZColumnView.h"

@implementation WZChartsDoubleColumnChartViewPoint

- (instancetype)initDoubleColumnChartViewPointX:(float)x pointLeftY:(float)leftY pointRightY:(float)rightY zoomY:(float)zoomY {
    self = [super init];
    self.x = x;
    self.leftTextY = leftY;
    self.rightTextY = rightY;
    self.zoomY = zoomY;
    self.leftY = leftY*self.zoomY;
    self.rightY = rightY*self.zoomY;
    return self;
}

@end

@interface WZChartsDoubleColumnChartView() {
    
    // 滑动距离
    CGFloat _offestMoveX;
}

// 左颜色数组
@property (strong, nonatomic) NSMutableArray<UIColor *> *leftLayerColorsArray;
// 右颜色数组
@property (strong, nonatomic) NSMutableArray<UIColor *> *rightLayerColorsArray;
// 样式配置
@property (strong, nonatomic) WZColumnViewParams *columnViewParams;
// 坐标点数组
@property (nonatomic, strong) NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *pointArray;

// 左 view
@property (strong, nonatomic) NSMutableArray<WZColumnView *> *leftColumnViewArray;
// 最后处于选中状态的左 view
@property (strong, nonatomic) WZColumnView *lastLeftBackView;
// 左配置
@property (strong, nonatomic) WZColumnViewParams *leftParams;

// 右 view
@property (strong, nonatomic) NSMutableArray<WZColumnView *> *rightColumnViewArray;
// 最后处于选中状态的右 view
@property (strong, nonatomic) WZColumnView *lastRightBackView;
// 右配置
@property (strong, nonatomic) WZColumnViewParams *rightParams;

// 按钮数组
@property (strong, nonatomic) NSMutableArray<UIButton *> *btnArray;
// 最后处于选中状态的按钮
@property (strong, nonatomic) UIButton *lastBtn;

@end

@implementation WZChartsDoubleColumnChartView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.columnViewParams = [WZColumnViewParams new];
        [self.columnViewParams initDate];
        self.leftLayerColorsArray = [@[(__bridge id)[UIColor colorFromHexString:@"#a0f1c5"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#fecd01"].CGColor]mutableCopy];
        self.rightLayerColorsArray = [@[(__bridge id)[UIColor colorFromHexString:@"#0ec0e1"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#34e9c6"].CGColor]mutableCopy];
        self.pointArray = [NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams leftLayerColorsArray:(NSMutableArray<UIColor *> *)leftLayerColorsArray rightLayerColorsArray:(NSMutableArray<UIColor *> *)rightLayerColorsArray pointArray:(NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *)pointArray {
    self = [super initWithFrame:frame];
    if (self) {
        if (columnViewParams) {
            self.columnViewParams = columnViewParams;
        } else {
            WZColumnViewParams *params = [WZColumnViewParams new];
            [params initDate];
            self.columnViewParams = params;
        }
        self.leftLayerColorsArray = leftLayerColorsArray.count?leftLayerColorsArray:[@[(__bridge id)[UIColor colorFromHexString:@"#a0f1c5"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#fecd01"].CGColor]mutableCopy];
        self.rightLayerColorsArray = rightLayerColorsArray.count?rightLayerColorsArray:[@[(__bridge id)[UIColor colorFromHexString:@"#0ec0e1"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#34e9c6"].CGColor]mutableCopy];
        self.pointArray = pointArray.count?pointArray:[NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (void)baseViewCreate {
    self.leftColumnViewArray = [NSMutableArray<WZColumnView *> arrayWithCapacity:0];
    self.rightColumnViewArray = [NSMutableArray<WZColumnView *> arrayWithCapacity:0];
    self.btnArray = [NSMutableArray<UIButton *> arrayWithCapacity:0];
    [self createGridYAxisLineWithCount:self.pointArray.count showCount:self.columnViewParams.lineShowCount ifShow:self.columnViewParams.ifShowY lineWidth:self.columnViewParams.lineYWidth lineColor:self.columnViewParams.lineYColor];
    [self createBottomTextViewWithHeight:self.columnViewParams.bottomHeight textColor:self.columnViewParams.textColor textFont:self.columnViewParams.textFont];
    if (self.columnViewParams.ifShowTopX) {
        [self createGridTopXAxisLineWithLineWidth:self.columnViewParams.lineTopXWidth lineColor:self.columnViewParams.lineTopXColor];
    }
    if (self.columnViewParams.ifShowBottomX) {
        [self createGridBottomXAxisLineWithLineWidth:self.columnViewParams.lineBottomXWidth lineColor:self.columnViewParams.lineBottomXColor];
    }
    [self createBackGradientView];
    [self updateDoubleColumnView];
}

- (void)createBackGradientView {
    // 更新已有组件
    for (int i = 0; i < self.btnArray.count; i++) {
        WZColumnView *lView = (WZColumnView *)self.leftColumnViewArray[i];
        lView.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1), 0, self.yEachWidth/2., self.yAxisHeight);
        
        WZColumnView *rView = (WZColumnView *)self.rightColumnViewArray[i];
        rView.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1) + self.yEachWidth/2., 0, self.yEachWidth/2., self.yAxisHeight);
        
        UIButton *bkPoint = (UIButton *)self.btnArray[i];
        bkPoint.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1), 0, self.yEachWidth, self.yAxisHeight);
    }
    // 添加新组件
    NSInteger lastbtnCount = self.btnArray.count;
    [self.pointArray enumerateObjectsUsingBlock:^(WZChartsDoubleColumnChartViewPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= lastbtnCount) {
            WZColumnView *leftView = [[WZColumnView alloc]initWithFrame:CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1), 0, self.yEachWidth/2., self.yAxisHeight) columnViewParams:self.leftParams];
            [self.scrollView addSubview:leftView];
            [self.leftColumnViewArray addObject:leftView];
            
            WZColumnView *rightView = [[WZColumnView alloc]initWithFrame:CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1) + self.yEachWidth/2., 0, self.yEachWidth/2., self.yAxisHeight) columnViewParams:self.rightParams];
            [self.scrollView addSubview:rightView];
            [self.rightColumnViewArray addObject:rightView];

            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clickBtn.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1), 0, self.yEachWidth, self.yAxisHeight);
            clickBtn.tag = idx;
            [clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:clickBtn];
            [self.btnArray addObject:clickBtn];
        }
    }];
}

- (void)updateDoubleColumnView {
    [self.pointArray enumerateObjectsUsingBlock:^(WZChartsDoubleColumnChartViewPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 改变左边遮照高度/渐变高度
        WZColumnView *leftView = (WZColumnView *)self.leftColumnViewArray[idx];
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint:CGPointMake(self.yStartWidth-self.leftParams.lineDis, self.yAxisHeight-self.leftParams.lineWidth/2)];
        [leftPath addLineToPoint:CGPointMake(self.yStartWidth-self.leftParams.lineDis, self.yAxisHeight - obj.leftY)];
        
        [leftView updateWZColumnViewWithShapePath:leftPath gradientFrame:CGRectMake(0, self.yAxisHeight - obj.leftY - self.leftParams.lineWidth/2, self.yEachWidth/2., obj.leftY + self.leftParams.lineWidth/2)];
        
        // 改变右边遮照高度/渐变高度
        WZColumnView *rightView = (WZColumnView *)self.rightColumnViewArray[idx];
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint:CGPointMake(self.rightParams.lineDis, self.yAxisHeight-self.rightParams.lineWidth/2)];
        [rightPath addLineToPoint:CGPointMake(self.rightParams.lineDis, self.yAxisHeight - obj.rightY)];

        [rightView updateWZColumnViewWithShapePath:rightPath gradientFrame:CGRectMake(0, self.yAxisHeight - obj.rightY - self.rightParams.lineWidth/2, self.yEachWidth/2., obj.rightY + self.rightParams.lineWidth/2)];
    }];
}

#pragma mark ➶_➴ Event Response

- (void)clickBtnClick:(UIButton *)btn {
    [self updateClickeDoubleColumnChartViewStyle:btn];
    if (_wzChartsDoubleColumnChartViewDelegate && [_wzChartsDoubleColumnChartViewDelegate respondsToSelector:@selector(wzChartsDoubleColumnChartView:clickBtn:)]) {
        [_wzChartsDoubleColumnChartViewDelegate wzChartsDoubleColumnChartView:self clickBtn:btn];
    }
}

#pragma mark ◎_◎ Private Method

- (void)updateClickeDoubleColumnChartViewStyle:(UIButton *)clickBtn {
    if (self.lastLeftBackView && self.lastRightBackView && self.lastBtn && self.lastBtn != clickBtn && self.lastBtn.selected) {
        self.lastBtn.selected = !self.lastBtn.selected;
        self.lastLeftBackView.alpha = self.leftParams.viewAlpha;
        self.lastRightBackView.alpha = self.rightParams.viewAlpha;
        self.lastLineShapeLayer.strokeColor = self.columnViewParams.lineYColor.CGColor;
        if (clickBtn.tag < self.bottomTextLayerArray.count) {
            self.lastbottomTextLayer.foregroundColor =self.columnViewParams.textColor.CGColor;
         }
    }
    clickBtn.selected = !clickBtn.selected;
    self.lastLineShapeLayer = (CAShapeLayer *)self.lineShapeLayerArray[clickBtn.tag];
    self.lastLineShapeLayer.strokeColor = clickBtn.selected?self.columnViewParams.lineYClickColor.CGColor:self.columnViewParams.lineYColor.CGColor;
    if (clickBtn.tag < self.bottomTextLayerArray.count) {
        self.lastbottomTextLayer = (CATextLayer *)self.bottomTextLayerArray[clickBtn.tag];
        self.lastbottomTextLayer.foregroundColor = clickBtn.selected?self.columnViewParams.textClickColor.CGColor:self.columnViewParams.textColor.CGColor;;
    }
    self.lastLeftBackView = (WZColumnView *)self.leftColumnViewArray[clickBtn.tag];
    self.lastRightBackView = (WZColumnView *)self.rightColumnViewArray[clickBtn.tag];
    self.lastLeftBackView.alpha = clickBtn.selected? 1.:self.leftParams.viewAlpha;
    self.lastRightBackView.alpha = clickBtn.selected? 1.:self.rightParams.viewAlpha;
    self.lastBtn = clickBtn;
}

#pragma mark $_$ Public Method

// 添加数据点
- (void)updateDoubleColumnChartViewWithPointArray:(NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome {
    [self updateBottomTextViewWithTextArray:timeArray lineCount:pointArray.count];
    self.pointArray = pointArray;
    [self createBackGradientView];
    [self updateDoubleColumnView];
}

// 更新点击事件
- (void)updateDoubleColumnChartViewClickStatusWithTag:(NSInteger)clickTag {
    UIButton *clickBtn = (UIButton *)self.btnArray[clickTag];
    [self updateClickeDoubleColumnChartViewStyle:clickBtn];
}

// 获取点击点头部坐标
- (NSArray<NSValue *> *)getDoubleColumnChartViewClickPointWithTag:(NSInteger)clickTag {
    WZChartsDoubleColumnChartViewPoint *clickPoint = (WZChartsDoubleColumnChartViewPoint *)self.pointArray[clickTag];
    NSArray *pointArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(self.yStartWidth-self.leftParams.lineDis+self.yEachWidth*(self.yTotalCount-clickTag-1), self.yAxisHeight - clickPoint.leftY)],[NSValue valueWithCGPoint:CGPointMake(self.rightParams.lineDis+self.yEachWidth*(self.yTotalCount-clickTag-1) + self.yEachWidth/2., self.yAxisHeight - clickPoint.rightY)], nil];
    return pointArray;
}

#pragma mark ⚆_⚆ Get/Set

- (WZColumnViewParams *)leftParams {
    if (!_leftParams) {
        _leftParams = [self.columnViewParams copy];
        _leftParams.colorRandom = self.leftLayerColorsArray;
    }
    return _leftParams;
}

- (WZColumnViewParams *)rightParams {
    if (!_rightParams) {
        _rightParams = [self.columnViewParams copy];
        _rightParams.colorRandom = self.rightLayerColorsArray;
    }
    return _rightParams;
}

@end
