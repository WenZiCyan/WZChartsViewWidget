//
//  WZColumnView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/11/5.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZColumnViewParams;

NS_ASSUME_NONNULL_BEGIN

@interface WZColumnView : UIView

/**
 创建柱形条

 @param frame 位置
 @param columnViewParams 样式配置
 @return 柱形条
 */
- (instancetype)initWithFrame:(CGRect)frame columnViewParams:(WZColumnViewParams *)columnViewParams;

/**
 更新柱形条

 @param shapePath 遮照路径
 @param gradientFrame 渐变位置
 */
- (void)updateWZColumnViewWithShapePath:(UIBezierPath *)shapePath gradientFrame:(CGRect)gradientFrame;

@end

NS_ASSUME_NONNULL_END
