//
//  WZChartsBaseBackView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/18.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+WZPalette.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZChartsBaseBackView : UIView

// 图表显示宽度
@property (readonly) CGFloat xAxisWidth;
// 图表总宽度
@property (readonly) CGFloat xAxisTotalWidth;
// 图表显示高度
@property (readonly) CGFloat yAxisHeight;
// 图表显示y轴条数
@property (readonly) NSInteger yShowCount;
// 图表y轴条数
@property (readonly) NSInteger yTotalCount;
// 图表y轴起始位置
@property (readonly) CGFloat yStartWidth;
// 图表y轴间距
@property (readonly) CGFloat yEachWidth;

@property (strong, nonatomic) UIScrollView *scrollView;
// y轴线条数组
@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *lineShapeLayerArray;
// 最后处于选中状态的y轴线
@property (strong, nonatomic) CAShapeLayer *lastLineShapeLayer;
// 下x轴CATextLayer数组
@property (strong, nonatomic) NSMutableArray<CATextLayer *> *bottomTextLayerArray;
// 最后处于选中状态的下x轴CATextLayer
@property (strong, nonatomic) CATextLayer *lastbottomTextLayer;

// 创建Y轴线 count（默认0条） showCount（默认0条）
-(void)createGridYAxisLineWithCount:(NSInteger)count showCount:(NSInteger)showCount ifShow:(BOOL)ifShow lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor;
// 创建上X轴线（默认无）
-(void)createGridTopXAxisLineWithLineWidth:(float)lineWidth lineColor:(UIColor *)lineColor;
// 创建下X轴线（默认无）
-(void)createGridBottomXAxisLineWithLineWidth:(float)lineWidth lineColor:(UIColor *)lineColor;
// 创建下X轴线文字高度/文字样式
- (void)createBottomTextViewWithHeight:(float)height textColor:(UIColor *)textColor textFont:(UIFont *)textFont;

// 更新下X轴线文字及线条数
- (void)updateBottomTextViewWithTextArray:(NSMutableArray<NSString *> *)textArray lineCount:(NSInteger)lineCount;

@end

NS_ASSUME_NONNULL_END
