//
//  WZRingChartsViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/7.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZRingChartsViewController.h"
#import "UIColor+WZPalette.h"
#import "APTopRingChartsView.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "WholeSituation.h"
#import "WZRingAnimParams.h"

@interface WZRingChartsViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) APTopRingChartsView *ringChartsView1;

@property (strong, nonatomic) APTopRingChartsView *ringChartsView2;

@end

@implementation WZRingChartsViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"圆环图";
    self.view.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.ringChartsView1];
    [self.scrollerView addSubview:self.ringChartsView2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.scrollerView.contentSize=CGSizeMake(WZWIDTHOFSCREEN,self.ringChartsView2.frame.origin.y+self.ringChartsView2.frame.size.height +16);
    self.scrollerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestInfoData];
    }];
    [self.scrollerView.mj_header beginRefreshing];
}

#pragma mark @_@ Delegate

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)requestInfoData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.ringChartsView1 updateAPTopRingChartsViewWithNum1:@"100" num2:@"67" num3:@"30"];
        [self.ringChartsView2 updateAPTopRingChartsViewWithNum1:@"100" num2:@"37" num3:@"10"];
        [self.scrollerView.mj_header endRefreshing];
    });
}

#pragma mark $_$ Public Method

#pragma mark ⚆_⚆ Get/Set

- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc]init];
        _scrollerView.delegate = self;
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.backgroundColor = self.view.backgroundColor;
    }
    return _scrollerView;
}

- (APTopRingChartsView *)ringChartsView1 {
    if (!_ringChartsView1) {
        WZRingAnimParams *params = [WZRingAnimParams new];
        [params initDate];
        _ringChartsView1 = [[APTopRingChartsView alloc]initWithFrame:CGRectMake(0, 16, WZWIDTHOFSCREEN, 271) animParams:params];
    }
    return _ringChartsView1;
}

- (APTopRingChartsView *)ringChartsView2 {
    if (!_ringChartsView2) {
        WZRingAnimParams *params = [WZRingAnimParams new];
        [params initDate];
        params.ifHasBack = NO;
        params.ringWidth = 20;
        _ringChartsView2 = [[APTopRingChartsView alloc]initWithFrame:CGRectMake(0, 304, WZWIDTHOFSCREEN, 271) animParams:params];
    }
    return _ringChartsView2;
}


@end
