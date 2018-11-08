//
//  WZGroupChartsViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZGroupChartsViewController.h"
#import "WZGroupChartsView.h"
#import "UIColor+WZPalette.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "WholeSituation.h"

@interface WZGroupChartsViewController () <UIScrollViewDelegate,WZGroupChartsViewDelegte> {
    
    NSInteger _page;
    
    NSMutableArray *_dataArray;
}

@property (strong, nonatomic) UIScrollView *backScrollView;

@property (strong, nonatomic) WZGroupChartsView *groupChartsView;

@end

@implementation WZGroupChartsViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"复合图";
     self.view.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.groupChartsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.backScrollView.contentSize=CGSizeMake(WZWIDTHOFSCREEN,self.groupChartsView.frame.origin.y+self.groupChartsView.frame.size.height +16);
    self.backScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        [self requestInfoData];
    }];
    [self.backScrollView.mj_header beginRefreshing];
}

#pragma mark @_@ WZGroupChartsViewDelegte

// 图表翻页事件
- (void)wzGroupChartsView:(WZGroupChartsView *)groupChartsView scrollViewDidScrollPage:(NSInteger)scrollPage turnLeft:(BOOL)turnLeft {
    NSLog(@"%ld",(long)scrollPage);
    if (turnLeft && scrollPage == 0) {
        self->_page = 2;
        [self requestInfoData];
    }
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)requestInfoData {
    if (_page == 1) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];

    NSDictionary *dic1 = @{@"pointY":@59.4098,@"topZoomY":@(195/1.5),@"pointLeftY":@3.6,@"pointRightY":@4.8,@"bottomZoomY":@(170/24.)};
    NSDictionary *dic2 = @{@"pointY":@67.33455,@"topZoomY":@(195/1.5),@"pointLeftY":@9.5,@"pointRightY":@11.0,@"bottomZoomY":@(170/24.)};
    NSDictionary *dic3 = @{@"pointY":@150.5544,@"topZoomY":@(195/1.5),@"pointLeftY":@14.6,@"pointRightY":@4.9,@"bottomZoomY":@(170/24.)};
    NSDictionary *dic4 = @{@"pointY":@124.7453,@"topZoomY":@(195/1.5),@"pointLeftY":@19.4,@"pointRightY":@3.3,@"bottomZoomY":@(170/24.)};
    NSDictionary *dic5 = @{@"pointY":@30.5432,@"topZoomY":@(195/1.5),@"pointLeftY":@22.9,@"pointRightY":@1.5,@"bottomZoomY":@(170/24.)};
    
    [_dataArray addObject:dic1];
    [_dataArray addObject:dic2];
    [_dataArray addObject:dic3];
    [_dataArray addObject:dic4];
    [_dataArray addObject:dic5];
    
    [array addObject:dic1];
    [array addObject:dic2];
    [array addObject:dic3];
    [array addObject:dic4];
    [array addObject:dic5];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_page == 1) {
            [self.groupChartsView initBottomChartsGroupViewWithViewWithArray:self->_dataArray topMaxIncome:170 bottomMaxIncome:24];
        } else {
            [self.groupChartsView updateBottomChartsGroupViewWithViewWithArray:array topMaxIncome:170 bottomMaxIncome:24];
        }
        [self.backScrollView.mj_header endRefreshing];
    });
}

#pragma mark $_$ Public Method

#pragma mark ⚆_⚆ Get/Set

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]init];
        _backScrollView.delegate = self;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.backgroundColor = self.view.backgroundColor;
    }
    return _backScrollView;
}

- (WZGroupChartsView *)groupChartsView {
    if (!_groupChartsView) {
        _groupChartsView = [[WZGroupChartsView alloc]initWithFrame:CGRectMake(0, 16, WZWIDTHOFSCREEN, 580)];
        _groupChartsView.wzGroupChartsViewDelegte = self;
    }
    return _groupChartsView;
}

@end
