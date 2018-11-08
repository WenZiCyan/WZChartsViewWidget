//
//  WZChartsSingleColumnChartView.h
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsBaseBackView.h"

@interface WZChartsSingleColumnChartViewPoint : NSObject
// x 轴偏移量
@property (assign, nonatomic) float singleX;
// y 轴偏移量
@property (assign, nonatomic) float singleY;
// y 轴值
@property (assign, nonatomic) float singleTextY;
// y 轴缩放比
@property (assign, nonatomic) float zoomY;

// Xcode 判断是否为 init 方法规则：方法返回 id，并且名字以 init + 大写字母开头 + 其他为准则
- (instancetype)initSingleColumnChartViewSingleX:(float)singleX singleY:(float)singleY zoomY:(float)zoomY;

@end

@class WZChartsSingleColumnChartView;
@class WZColumnViewParams;

@protocol WZChartsSingleColumnChartViewDelegate <NSObject>

@optional
// 柱形点击事件
- (void)wzChartsSingleColumnChartView:(WZChartsSingleColumnChartView *)singleColumnChartView clickBtn:(UIButton *)clickBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WZChartsSingleColumnChartView : WZChartsBaseBackView

/**
 创建图表
 
 @param frame 位置
 @param columnViewParams 样式配置
 @param layerColorsArray 柱形颜色数组
 @param pointArray 点数组
 @return 图表
 */
- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams layerColorsArray:(NSMutableArray<UIColor *> *)layerColorsArray pointArray:(NSMutableArray<WZChartsSingleColumnChartViewPoint *> *)pointArray;

@property (weak, nonatomic) id<WZChartsSingleColumnChartViewDelegate>wzChartsSingleColumnChartViewDelegate;

// 添加数据点
- (void)updateSingleColumnChartViewWithPointArray:(NSMutableArray<WZChartsSingleColumnChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome;
// 更新点击事件
- (void)updateSingleColumnChartViewClickStatusWithTag:(NSInteger)clickTag;
// 获取点击点头部坐标
- (NSArray<NSValue *> *)getSingleColumnChartViewClickPointWithTag:(NSInteger)clickTag;


@end

NS_ASSUME_NONNULL_END
