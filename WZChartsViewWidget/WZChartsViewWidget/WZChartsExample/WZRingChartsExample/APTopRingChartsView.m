//
//  APTopRingChartsView.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/15.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "APTopRingChartsView.h"
#import "WZRingChartsView.h"
#import "UIColor+WZPalette.h"
#import <Masonry.h>
#import "WholeSituation.h"
#import "WZRingAnimParams.h"

@interface APTopRingChartsView()

@property (strong, nonatomic) WZRingChartsView *ringChartsView;

@property (strong, nonatomic) WZRingAnimParams *animParams;

@property (strong, nonatomic) UIView *rightListView;

@property (strong, nonatomic) UILabel *num1Label;

@property (strong, nonatomic) UILabel *num2Label;

@property (strong, nonatomic) UILabel *num3Label;

@end

@implementation APTopRingChartsView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.animParams = [WZRingAnimParams new];
        [self.animParams initDate];
        [self createCellSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame animParams:(WZRingAnimParams *)animParams {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
    [self addSubview:self.ringChartsView];
    [self.rightListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(32);
        make.bottom.offset(-32);
        make.right.equalTo(self);
        make.width.offset(self.frame.size.width/3.);
    }];
}

#pragma mark @_@ Delegate

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

#pragma mark $_$ Public Method

- (void)updateAPTopRingChartsViewWithNum1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3 {
    self.num1Label.text = num1;
    self.num2Label.text = num2;
    self.num3Label.text = num3;
    [self.ringChartsView updateWZRingChartsViewWithPercentArray:[@[[NSNumber numberWithFloat:[num1 floatValue]/[num1 floatValue]],[NSNumber numberWithFloat:[num2 floatValue]/[num1 floatValue]],[NSNumber numberWithFloat:[num3 floatValue]/[num1 floatValue]]]mutableCopy]];
}

#pragma mark ⚆_⚆ Get/Set

- (WZRingChartsView *)ringChartsView {
    if (!_ringChartsView) {
        _ringChartsView = [[WZRingChartsView alloc]initWithFrame:CGRectMake(32*WZWIDTHRADIUS  , 44, 183, 183) animParams:self.animParams];
    }
    return _ringChartsView;
}

// 右列表
- (UIView *)rightListView {
    if (!_rightListView) {
        _rightListView = [UIView new];
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        [_rightListView addSubview:titleLabel];
        titleLabel.text = @"标题";
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        self.num1Label = [self numLabel];
        self.num2Label = [self numLabel];
        self.num3Label = [self numLabel];
        UIView *canLinkView = [self leftEachViewWithTitle:@"num1" imgStr:@"img_ situation_linknum" superLabel:self.num1Label];
        UIView *haveLinkView = [self leftEachViewWithTitle:@"num2" imgStr:@"img_ situation_havelink" superLabel:self.num2Label];
        UIView *workingView = [self leftEachViewWithTitle:@"num3" imgStr:@"img_ situation_working" superLabel:self.num3Label];
        [self addSubview:_rightListView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self->_rightListView);
        }];
        [canLinkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(24);
            make.height.offset(42);
            make.left.right.equalTo(self->_rightListView);
        }];
        [haveLinkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(canLinkView.mas_bottom).offset(20);
            make.height.offset(42);
            make.left.right.equalTo(self->_rightListView);
        }];
        [workingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(haveLinkView.mas_bottom).offset(20);
            make.height.offset(42);
            make.left.right.equalTo(self->_rightListView);
        }];
    }
    return _rightListView;
}

- (UILabel *)numLabel {
    UILabel *label =  [UILabel new];
    label.font = [UIFont fontWithName:@"DIN Alternate" size:24];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"---";
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

// 列表小分块
- (UIView *)leftEachViewWithTitle:(NSString *)title imgStr:(NSString *)imgStr superLabel:(UILabel *)superLabel {
    UIView *bkView = [UIView new];
    bkView.backgroundColor = [UIColor whiteColor];
    [_rightListView addSubview:bkView];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorFromHexString:@"#999999"];
    [bkView addSubview:label];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = title;
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
    [bkView addSubview:img];
    img.backgroundColor = [UIColor whiteColor];
    [bkView addSubview:superLabel];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.top.equalTo(bkView);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(8);
        make.right.equalTo(bkView);
        make.centerY.equalTo(img);
    }];
    [superLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.right.bottom.equalTo(bkView);
    }];
    
    return bkView;
}

@end
