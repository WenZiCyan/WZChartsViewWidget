//
//  WZLineViewParams.h
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/7.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZLineViewParams : NSObject <NSCopying,NSMutableCopying>

/******************动画******************/

// 是否显示动画
@property (assign, nonatomic) BOOL ifAnimation;

// 时间
@property (nonatomic) double animDuration;

/******************XY 坐标样式******************/

// 是否需要显示上 X 轴
@property (assign, nonatomic) BOOL ifShowTopX;
// 上 X 轴线宽
@property (nonatomic) float lineTopXWidth;
// 上 X 轴线色
@property (strong, nonatomic) UIColor *lineTopXColor;

// 是否需要显示下 X 轴
@property (assign, nonatomic) BOOL ifShowBottomX;
// 下 X 轴线宽
@property (nonatomic) float lineBottomXWidth;
// 下 X 轴线色
@property (strong, nonatomic) UIColor *lineBottomXColor;

// 是否需要显示 Y 轴
@property (assign, nonatomic) BOOL ifShowY;
// Y 轴线宽
@property (nonatomic) float lineYWidth;
// Y 轴线色
@property (strong, nonatomic) UIColor *lineYColor;

// 下 X 轴坐标高度
@property (nonatomic) float bottomHeight;
// 下 X 轴坐标UIColor
@property (strong, nonatomic) UIColor *textColor;
// 下 X 轴坐标UIFont
@property (strong, nonatomic) UIFont *textFont;

// Y 轴线选中色
@property (strong, nonatomic) UIColor *lineYClickColor;
// 下 X 轴坐标选中色
@property (strong, nonatomic) UIColor *textClickColor;

/******************颜色******************/

// 折线颜色数组
@property (strong, nonatomic) NSMutableArray<UIColor *> *lineLayerColors;
// 背景颜色数组
@property (strong, nonatomic) NSMutableArray<UIColor *> *bkLayerColors;

/******************尺寸******************/

// 宽度
@property (nonatomic) float lineWidth;

/******************其他******************/

// 一屏显示个数
@property (nonatomic) NSInteger lineShowCount;

// 折点按钮
@property (strong, nonatomic) UIButton *pointBtn;

/******************初始化******************/
//
-(void)initDate;

@end

NS_ASSUME_NONNULL_END
