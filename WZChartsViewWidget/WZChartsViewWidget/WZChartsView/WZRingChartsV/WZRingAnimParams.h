//
//  WZRingAnimParams.h
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZRingAnimParams : NSObject

/******************动画******************/

// 是否显示动画
@property (assign, nonatomic) BOOL ifAnimation;

// 时间
@property (nonatomic) double animDuration;

/******************颜色******************/

// 环形颜色列表
@property (strong, nonatomic) NSMutableArray<NSArray *> *colorRandom;

// 背景的颜色列表
@property (strong, nonatomic) NSMutableArray<NSArray *> *backColorRandom;

/******************尺寸******************/
// 环个数
@property (nonatomic) float ringCount;
// 环宽度
@property (nonatomic) float ringWidth;
// 环间距离
@property (nonatomic) float ringDistance;

/******************其他******************/
// 是否有背景环
@property (assign, nonatomic) BOOL ifHasBack;

/******************初始化******************/
//
-(void)initDate;

@end

NS_ASSUME_NONNULL_END
