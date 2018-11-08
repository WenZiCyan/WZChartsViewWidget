//
//  WZRingChartsView.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZRingAnimParams;

NS_ASSUME_NONNULL_BEGIN

@interface WZRingChartsView : UIView

- (instancetype)initWithFrame:(CGRect)frame animParams:(WZRingAnimParams *)animParams;

- (void)updateWZRingChartsViewWithPercentArray:(NSMutableArray<NSNumber *> *)percentArray;

@end

NS_ASSUME_NONNULL_END
