//
//  WZChartsDoubleColumnChartView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/19.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsBaseBackView.h"

@interface WZChartsDoubleColumnChartViewPoint : NSObject
// x 轴偏移量
@property (assign, nonatomic) float x;
// left y 轴偏移量
@property (assign, nonatomic) float leftY;
// rigth y 轴偏移量
@property (assign, nonatomic) float rightY;
// left y 轴值
@property (assign, nonatomic) float leftTextY;
// rigth y 轴值
@property (assign, nonatomic) float rightTextY;
// y 轴缩放比
@property (assign, nonatomic) float zoomY;
// Xcode 判断是否为 init 方法规则：方法返回 id，并且名字以 init + 大写字母开头 + 其他为准则
- (instancetype)initDoubleColumnChartViewPointX:(float)x pointLeftY:(float)leftY pointRightY:(float)rightY zoomY:(float)zoomY;

@end

@class WZChartsDoubleColumnChartView;
@class WZColumnViewParams;

@protocol WZChartsDoubleColumnChartViewDelegate <NSObject>

@optional
// 柱形点击事件
- (void)wzChartsDoubleColumnChartView:(WZChartsDoubleColumnChartView *)doubleColumnChartView clickBtn:(UIButton *)clickBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WZChartsDoubleColumnChartView : WZChartsBaseBackView

/**
 创建图表

 @param frame 位置
 @param columnViewParams 样式配置
 @param leftLayerColorsArray 左柱形颜色数组
 @param rightLayerColorsArray 右柱形颜色数组
 @param pointArray 点数组
 @return 图表
 */
- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams leftLayerColorsArray:(NSMutableArray<UIColor *> *)leftLayerColorsArray rightLayerColorsArray:(NSMutableArray<UIColor *> *)rightLayerColorsArray pointArray:(NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *)pointArray;

@property (weak, nonatomic) id<WZChartsDoubleColumnChartViewDelegate>wzChartsDoubleColumnChartViewDelegate;

// 添加数据点
- (void)updateDoubleColumnChartViewWithPointArray:(NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome;
// 更新点击事件
- (void)updateDoubleColumnChartViewClickStatusWithTag:(NSInteger)clickTag;
// 获取点击点头部坐标
- (NSArray<NSValue *> *)getDoubleColumnChartViewClickPointWithTag:(NSInteger)clickTag;

@end

NS_ASSUME_NONNULL_END
