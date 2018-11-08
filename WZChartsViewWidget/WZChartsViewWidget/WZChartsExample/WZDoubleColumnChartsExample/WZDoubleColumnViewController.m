//
//  WZDoubleColumnViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZDoubleColumnViewController.h"
#import "WZChartsDoubleColumnChartView.h"
#import "UIColor+WZPalette.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "WholeSituation.h"

@interface WZDoubleColumnViewController () <UIScrollViewDelegate,WZChartsDoubleColumnChartViewDelegate> {
    
    NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *_array;
    
    NSMutableArray<NSString *> *_textArray;
}

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) WZChartsDoubleColumnChartView *doubleColumnChartView;

@end

@implementation WZDoubleColumnViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Double柱形图";
    self.view.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.doubleColumnChartView];
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

#pragma mark @_@ WZChartsDoubleColumnChartViewDelegate

- (void)wzChartsDoubleColumnChartView:(WZChartsDoubleColumnChartView *)doubleColumnChartView clickBtn:(UIButton *)clickBtn {
    
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)requestInfoData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_array addObject:[[WZChartsDoubleColumnChartViewPoint alloc]initDoubleColumnChartViewPointX:0 pointLeftY:10 pointRightY:4.0 zoomY:190/24]];
        [self->_array addObject:[[WZChartsDoubleColumnChartViewPoint alloc]initDoubleColumnChartViewPointX:0 pointLeftY:14.5 pointRightY:7.2 zoomY:190/24]];
        [self->_array addObject:[[WZChartsDoubleColumnChartViewPoint alloc]initDoubleColumnChartViewPointX:0 pointLeftY:15.3 pointRightY:6.8 zoomY:190/24]];
        [self->_array addObject:[[WZChartsDoubleColumnChartViewPoint alloc]initDoubleColumnChartViewPointX:0 pointLeftY:9.8 pointRightY:13.5 zoomY:190/24]];
        [self->_array addObject:[[WZChartsDoubleColumnChartViewPoint alloc]initDoubleColumnChartViewPointX:0 pointLeftY:11.8 pointRightY:24 zoomY:190/24]];
        
        [self->_textArray addObject:@"1-1"];
        [self->_textArray addObject:@"1-2"];
        [self->_textArray addObject:@"1-3"];
        [self->_textArray addObject:@"1-4"];
        [self->_textArray addObject:@"1-5"];
        
        [self.doubleColumnChartView updateDoubleColumnChartViewWithPointArray:self->_array timeArray:self->_textArray maxIncome:24];
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

- (WZChartsDoubleColumnChartView *)doubleColumnChartView {
    if (!_doubleColumnChartView) {
        _doubleColumnChartView = [[WZChartsDoubleColumnChartView alloc]initWithFrame:CGRectMake(0, 16, WZWIDTHOFSCREEN, 200)];
        _doubleColumnChartView.scrollView.delegate = self;
        _doubleColumnChartView.wzChartsDoubleColumnChartViewDelegate = self;
    }
    return _doubleColumnChartView;
}

@end
