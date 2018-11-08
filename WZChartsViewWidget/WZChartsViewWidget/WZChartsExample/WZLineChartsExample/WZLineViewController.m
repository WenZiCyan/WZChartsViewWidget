//
//  WZLineViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/7.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZLineViewController.h"
#import "UIColor+WZPalette.h"
#import "WZChartsLineChartView.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "WholeSituation.h"

@interface WZLineViewController () <UIScrollViewDelegate,WZChartsLineChartViewDelegate> {
    
    NSMutableArray<WZChartsLineChartViewPoint *> *_array;
    
    NSMutableArray<NSString *> *_textArray;
}

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) WZChartsLineChartView *lineChartsView;

@end

@implementation WZLineViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"折线图";
    self.view.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.lineChartsView];
    _array = [NSMutableArray arrayWithCapacity:0];
    _textArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.scrollerView.contentSize=CGSizeMake(WZWIDTHOFSCREEN,WZHEIGHTOFSCREEN);
    self.scrollerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestInfoData];
    }];
    [self.scrollerView.mj_header beginRefreshing];
}

#pragma mark @_@ WZChartsLineChartViewDelegate

- (void)wzChartsLineChartView:(WZChartsLineChartView *)lineChartView pointBtn:(UIButton *)pointBtn {
    
}

// 视图滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_lineChartsView updateSlideLineChart:scrollView.contentOffset.x];
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)requestInfoData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_array addObject:[[WZChartsLineChartViewPoint alloc]initLineChartViewPointX:0 pointY:30 maxY:40 zoomY:200/1.5]];
        [self->_array addObject:[[WZChartsLineChartViewPoint alloc]initLineChartViewPointX:0 pointY:20 maxY:40 zoomY:200/1.5]];
        [self->_array addObject:[[WZChartsLineChartViewPoint alloc]initLineChartViewPointX:0 pointY:0 maxY:40 zoomY:200/1.5]];
        [self->_array addObject:[[WZChartsLineChartViewPoint alloc]initLineChartViewPointX:0 pointY:25 maxY:40 zoomY:200/1.5]];
        [self->_array addObject:[[WZChartsLineChartViewPoint alloc]initLineChartViewPointX:0 pointY:17 maxY:40 zoomY:200/1.5]];
        
        [self->_textArray addObject:@"1-1"];
        [self->_textArray addObject:@"1-2"];
        [self->_textArray addObject:@"1-3"];
        [self->_textArray addObject:@"1-4"];
        [self->_textArray addObject:@"1-5"];
        
        [self.lineChartsView updateLineChartViewWithPointArray:self->_array timeArray:self->_textArray maxIncome:40];
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

- (WZChartsLineChartView *)lineChartsView {
    if (!_lineChartsView) {
        _lineChartsView = [[WZChartsLineChartView alloc]initWithFrame:CGRectMake(0, 16, WZWIDTHOFSCREEN, 200)];
        _lineChartsView.scrollView.delegate = self;
        _lineChartsView.wzChartsLineChartViewDelegate = self;
    }
    return _lineChartsView;
}

@end
