//
//  WZRingChartsView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZRingChartsView.h"
#import "WZRingShapeLayer.h"
#import "WZRingAnimParams.h"

@interface WZRingChartsView()

@property (strong, nonatomic) WZRingAnimParams *animParams;

@property (strong, nonatomic) NSMutableArray<WZRingShapeLayer *> *ringShapeLayerArray;

@property (strong, nonatomic) NSMutableArray<WZRingShapeLayer *> *backRingShapeLayerArray;

@end

@implementation WZRingChartsView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animParams = [WZRingAnimParams new];
        [self.animParams initDate];
        [self createCellSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame animParams:(WZRingAnimParams *)animParams {
    self = [super initWithFrame:frame];
    if (self) {
        if (animParams) {
            self.animParams = animParams;
        } else {
            WZRingAnimParams *params = [WZRingAnimParams new];
            [params initDate];
            self.animParams = params;
        }
        [self createCellSubView];
    }
    return self;
}

- (void)createCellSubView {
    self.ringShapeLayerArray = [NSMutableArray<WZRingShapeLayer *> arrayWithCapacity:0];
    self.backRingShapeLayerArray = [NSMutableArray<WZRingShapeLayer *> arrayWithCapacity:0];
    if (self.animParams.ifHasBack) {
        for (int i = 1; i <= self.animParams.ringCount; i++) {
            WZRingShapeLayer *backLayer = [[WZRingShapeLayer alloc]init:self.bounds cellWidth:self.animParams.ringWidth colorArray:self.animParams.backColorRandom.count>=i? self.animParams.backColorRandom[i-1]:self.animParams.backColorRandom[self.animParams.backColorRandom.count-1] radius:self.bounds.size.width/2-self.animParams.ringWidth*i-self.animParams.ringDistance*i];
            backLayer.shouldRasterize = YES;
            [self.layer addSublayer:backLayer];
            [self.backRingShapeLayerArray addObject:backLayer];
        }
    }
    
    for (int i = 1; i <= self.animParams.ringCount; i++) {
        WZRingShapeLayer *ringLayer = [[WZRingShapeLayer alloc]init:self.bounds cellWidth:self.animParams.ringWidth colorArray:self.animParams.colorRandom.count>=i? self.animParams.colorRandom[i-1]:self.animParams.colorRandom[self.animParams.colorRandom.count-1] radius:self.bounds.size.width/2-self.animParams.ringWidth*i-self.animParams.ringDistance*i];
        [self.layer addSublayer:ringLayer];
        [self.ringShapeLayerArray addObject:ringLayer];
    }
}

#pragma mark @_@ Delegate

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

#pragma mark $_$ Public Method

- (void)updateWZRingChartsViewWithPercentArray:(NSMutableArray<NSNumber *>*)percentArray {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int i = 0;
        for (WZRingShapeLayer *layer in self.ringShapeLayerArray) {
            [layer wzRingShapeLayerRingChangeWithPercent:[percentArray[i] floatValue] animation:YES duration:self.animParams.animDuration];
            i++;
        }
        if (self.animParams.ifHasBack) {
            int j = 0;
            for (WZRingShapeLayer *layer in self.backRingShapeLayerArray) {
                [layer wzRingShapeLayerRingChangeWithPercent:1 animation:NO duration:self.animParams.animDuration];
                j++;
            }
        }
    });
}

#pragma mark ⚆_⚆ Get/Set

@end
