//
//  WZChartsSingleColumnChartView.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsSingleColumnChartView.h"
#import "WZColumnViewParams.h"
#import "WZColumnView.h"

@implementation WZChartsSingleColumnChartViewPoint

- (instancetype)initSingleColumnChartViewSingleX:(float)singleX singleY:(float)singleY zoomY:(float)zoomY {
    self = [super init];
    self.singleX = singleX;
    self.singleTextY = singleY;
    self.zoomY = zoomY;
    self.singleY = singleY*self.zoomY;
    return self;
}

@end

@interface WZChartsSingleColumnChartView() {
    
    // 滑动距离
    CGFloat _offestMoveX;
}

// 柱形颜色数组
@property (strong, nonatomic) NSMutableArray<UIColor *> *layerColorsArray;
// 样式配置
@property (strong, nonatomic) WZColumnViewParams *columnViewParams;
// 坐标点数组
@property (nonatomic, strong) NSMutableArray<WZChartsSingleColumnChartViewPoint *> *pointArray;

// view
@property (strong, nonatomic) NSMutableArray<WZColumnView *> *columnViewArray;
// 最后处于选中状态的 view
@property (strong, nonatomic) WZColumnView *lastbackView;
// 配置
@property (strong, nonatomic) WZColumnViewParams *columnParams;

// 按钮数组
@property (strong, nonatomic) NSMutableArray<UIButton *> *btnArray;
// 最后处于选中状态的按钮
@property (strong, nonatomic) UIButton *lastBtn;

@end

@implementation WZChartsSingleColumnChartView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.columnViewParams = [WZColumnViewParams new];
        [self.columnViewParams initDate];
        self.layerColorsArray = [@[(__bridge id)[UIColor colorFromHexString:@"#d0b1cc"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#decd98"].CGColor]mutableCopy];
        self.pointArray = [NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams layerColorsArray:(NSMutableArray<UIColor *> *)layerColorsArray pointArray:(NSMutableArray<WZChartsSingleColumnChartViewPoint *> *)pointArray {
    self = [super initWithFrame:frame];
    if (self) {
        if (columnViewParams) {
            self.columnViewParams = columnViewParams;
        } else {
            WZColumnViewParams *params = [WZColumnViewParams new];
            [params initDate];
            self.columnViewParams = params;
        }
        self.layerColorsArray = layerColorsArray.count?layerColorsArray:[@[(__bridge id)[UIColor colorFromHexString:@"#a0b1cc"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#decd98"].CGColor]mutableCopy];
        self.pointArray = pointArray.count?pointArray:[NSMutableArray arrayWithCapacity:0];
        [self baseViewCreate];
    }
    return self;
}

- (void)baseViewCreate {
    self.columnViewArray = [NSMutableArray<WZColumnView *> arrayWithCapacity:0];
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
    [self updateSingleColumnView];
}

- (void)createBackGradientView {
    // 更新已有组件
    for (int i = 0; i < self.btnArray.count; i++) {
        WZColumnView *columnView = (WZColumnView *)self.columnViewArray[i];
        columnView.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1), 0, self.yEachWidth, self.yAxisHeight);
      
        UIButton *bkPoint = (UIButton *)self.btnArray[i];
        bkPoint.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-i-1), 0, self.yEachWidth, self.yAxisHeight);
    }
    // 添加新组件
    NSInteger lastbtnCount = self.btnArray.count;
    [self.pointArray enumerateObjectsUsingBlock:^(WZChartsSingleColumnChartViewPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= lastbtnCount) {
            WZColumnView *columnView = [[WZColumnView alloc]initWithFrame:CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1), 0, self.yEachWidth, self.yAxisHeight) columnViewParams:self.columnParams];
            [self.scrollView addSubview:columnView];
            [self.columnViewArray addObject:columnView];
            
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clickBtn.frame = CGRectMake(self.yEachWidth*(self.yTotalCount-idx-1), 0, self.yEachWidth, self.yAxisHeight);
            clickBtn.tag = idx;
            [clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:clickBtn];
            [self.btnArray addObject:clickBtn];
        }
    }];
}

- (void)updateSingleColumnView {
    [self.pointArray enumerateObjectsUsingBlock:^(WZChartsSingleColumnChartViewPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 改变遮照高度/渐变高度
        WZColumnView *columnView = (WZColumnView *)self.columnViewArray[idx];
        UIBezierPath *columnPath = [UIBezierPath bezierPath];
        [columnPath moveToPoint:CGPointMake(self.yEachWidth/2.-self.columnParams.lineDis, self.yAxisHeight-self.columnParams.lineWidth/2)];
        [columnPath addLineToPoint:CGPointMake(self.yEachWidth/2.-self.columnParams.lineDis, self.yAxisHeight - obj.singleY)];
        
        [columnView updateWZColumnViewWithShapePath:columnPath gradientFrame:CGRectMake(0, self.yAxisHeight - obj.singleY - self.columnParams.lineWidth/2, self.yEachWidth, obj.singleY + self.columnParams.lineWidth/2)];
    }];
}

#pragma mark ➶_➴ Event Response

- (void)clickBtnClick:(UIButton *)btn {
    [self updateClickeSingleColumnChartViewStyle:btn];
    if (_wzChartsSingleColumnChartViewDelegate && [_wzChartsSingleColumnChartViewDelegate respondsToSelector:@selector(wzChartsSingleColumnChartView:clickBtn:)]) {
        [_wzChartsSingleColumnChartViewDelegate wzChartsSingleColumnChartView:self clickBtn:btn];
    }
}

#pragma mark ◎_◎ Private Method

- (void)updateClickeSingleColumnChartViewStyle:(UIButton *)clickBtn {
    if (self.lastbackView && self.lastBtn && self.lastBtn != clickBtn && self.lastBtn.selected) {
        self.lastBtn.selected = !self.lastBtn.selected;
        self.lastbackView.alpha = self.columnParams.viewAlpha;
        self.lastLineShapeLayer.strokeColor = self.columnViewParams.lineYColor.CGColor;
        if (clickBtn.tag < self.bottomTextLayerArray.count) {
            self.lastbottomTextLayer.foregroundColor =self.columnViewParams.textColor.CGColor;
        }
    }
    clickBtn.selected = !clickBtn.selected;
    self.lastLineShapeLayer = (CAShapeLayer *)self.lineShapeLayerArray[clickBtn.tag];
    self.lastLineShapeLayer.strokeColor = clickBtn.selected?self.columnViewParams.lineYClickColor.CGColor:self.columnViewParams.lineYColor.CGColor;
    self.lastbackView = (WZColumnView *)self.columnViewArray[clickBtn.tag];
    self.lastbackView.alpha = clickBtn.selected? 1.:self.columnParams.viewAlpha;
    if (clickBtn.tag < self.bottomTextLayerArray.count) {
        self.lastbottomTextLayer = (CATextLayer *)self.bottomTextLayerArray[clickBtn.tag];
        self.lastbottomTextLayer.foregroundColor = clickBtn.selected?self.columnViewParams.textClickColor.CGColor:self.columnViewParams.textColor.CGColor;;
    }
    self.lastBtn = clickBtn;
}

#pragma mark $_$ Public Method

// 添加数据点
- (void)updateSingleColumnChartViewWithPointArray:(NSMutableArray<WZChartsSingleColumnChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome {
    [self updateBottomTextViewWithTextArray:timeArray lineCount:pointArray.count];
    self.pointArray = pointArray;
    [self createBackGradientView];
    [self updateSingleColumnView];
}

// 更新点击事件
- (void)updateSingleColumnChartViewClickStatusWithTag:(NSInteger)clickTag {
    UIButton *clickBtn = (UIButton *)self.btnArray[clickTag];
    [self updateClickeSingleColumnChartViewStyle:clickBtn];
}

// 获取点击点头部坐标
- (NSArray<NSValue *> *)getSingleColumnChartViewClickPointWithTag:(NSInteger)clickTag {
    WZChartsSingleColumnChartViewPoint *clickPoint = (WZChartsSingleColumnChartViewPoint *)self.pointArray[clickTag];
    NSArray *pointArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(self.yStartWidth-self.columnParams.lineDis+self.yEachWidth*(self.yTotalCount-clickTag-1), self.yAxisHeight - clickPoint.singleY)],[NSValue valueWithCGPoint:CGPointMake(self.columnParams.lineDis+self.yEachWidth*(self.yTotalCount-clickTag-1) + self.yEachWidth/2., self.yAxisHeight - clickPoint.singleY)], nil];
    return pointArray;
}

#pragma mark ⚆_⚆ Get/Set

- (WZColumnViewParams *)columnParams {
    if (!_columnParams) {
        _columnParams = [self.columnViewParams copy];
        _columnParams.colorRandom = self.layerColorsArray;
    }
    return _columnParams;
}

@end
