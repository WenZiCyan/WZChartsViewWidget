//
//  WZGroupChartsView.h
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZGroupChartsView;

@protocol WZGroupChartsViewDelegte <NSObject>

/**
 图表翻页事件
 
 @param groupChartsView self
 @param scrollPage 页数
 @param turnLeft 是否左翻
 */
-(void)wzGroupChartsView:(WZGroupChartsView *)groupChartsView scrollViewDidScrollPage:(NSInteger)scrollPage turnLeft:(BOOL)turnLeft;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WZGroupChartsView : UIView

@property (weak, nonatomic) id<WZGroupChartsViewDelegte>wzGroupChartsViewDelegte;
// 更新图表
- (void)updateBottomChartsGroupViewWithViewWithArray:(NSMutableArray *)array topMaxIncome:(float)topMaxIncome bottomMaxIncome:(float)bottomMaxIncome;
// 初始化图表
- (void)initBottomChartsGroupViewWithViewWithArray:(NSMutableArray *)array topMaxIncome:(float)topMaxIncome bottomMaxIncome:(float)bottomMaxIncome;

@end

NS_ASSUME_NONNULL_END
