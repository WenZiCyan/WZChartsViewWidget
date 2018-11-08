//
//  APTopRingChartsView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZRingAnimParams;

NS_ASSUME_NONNULL_BEGIN

@interface APTopRingChartsView : UIView

- (instancetype)initWithFrame:(CGRect)frame animParams:(WZRingAnimParams *)animParams;

/**
 更新

 @param num1 num1 description
 @param num2 num2 description
 @param num3 num3 description
 */
- (void)updateAPTopRingChartsViewWithNum1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3;

@end

NS_ASSUME_NONNULL_END
