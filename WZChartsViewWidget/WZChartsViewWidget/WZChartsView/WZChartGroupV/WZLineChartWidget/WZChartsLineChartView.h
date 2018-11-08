//
//  WZChartsLineChartView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/19.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZChartsBaseBackView.h"

@interface WZChartsLineChartViewPoint : NSObject
// x 轴偏移量
@property (assign, nonatomic) float x;
// y 轴最大值
@property (assign, nonatomic) float maxY;
// y 轴偏移量
@property (assign, nonatomic) float y;
// y 轴值
@property (assign, nonatomic) float textY;
// y 轴缩放比
@property (assign, nonatomic) float zoomY;
// Xcode 判断是否为 init 方法规则：方法返回 id，并且名字以 init + 大写字母开头 + 其他为准则
- (instancetype)initLineChartViewPointX:(float)x pointY:(float)y maxY:(float)maxY zoomY:(float)zoomY;

@end

@class WZLineViewParams;
@class WZChartsLineChartView;

@protocol WZChartsLineChartViewDelegate <NSObject>

@optional
// 按钮点击事件
- (void)wzChartsLineChartView:(WZChartsLineChartView *)lineChartView pointBtn:(UIButton *)pointBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WZChartsLineChartView : WZChartsBaseBackView

/**
 创建图表

 @param frame 位置
 @param lineViewParams 样式配置
 @param pointArray 点坐标
 @return 图表
 */
- (instancetype)initWithFrame:(CGRect)frame lineViewParams:(WZLineViewParams *)lineViewParams pointArray:(NSMutableArray<WZChartsLineChartViewPoint *> *)pointArray;

@property (weak, nonatomic) id<WZChartsLineChartViewDelegate>wzChartsLineChartViewDelegate;

// 添加数据点/时间
- (void)updateLineChartViewWithPointArray:(NSMutableArray<WZChartsLineChartViewPoint *> *)pointArray timeArray:(NSMutableArray<NSString *> *)timeArray maxIncome:(float)maxIncome;
//滑动更新图表
- (void)updateSlideLineChart:(CGFloat)offestX;
// 更新点击事件
- (void)updateLineChartViewClickStatusWithTag:(NSInteger)clickTag;
// 获取点击点坐标
- (CGPoint)getLineChartViewClickPointWithTag:(NSInteger)clickTag;
// 获取点击点 UIButton
- (UIButton *)getLineChartViewClickPointWithBtn:(NSInteger)clickTag;

@end

NS_ASSUME_NONNULL_END
