//
//  WZSingleColumnViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZSingleColumnViewController.h"
#import "WZChartsSingleColumnChartView.h"
#import "UIColor+WZPalette.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import "WholeSituation.h"
#import "WZColumnViewParams.h"

@interface WZSingleColumnViewController () <UIScrollViewDelegate,WZChartsSingleColumnChartViewDelegate> {
    
    NSMutableArray<WZChartsSingleColumnChartViewPoint *> *_array;
    
    NSMutableArray<NSString *> *_textArray;
}

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) WZChartsSingleColumnChartView *singleColumnChartView;

@property (strong, nonatomic) WZColumnViewParams *columnViewParams;

@end

@implementation WZSingleColumnViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Single柱形图";
    self.view.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.singleColumnChartView];
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

#pragma mark @_@ WZChartsSingleColumnChartViewDelegate

- (void)wzChartsSingleColumnChartView:(WZChartsSingleColumnChartView *)singleColumnChartView clickBtn:(UIButton *)clickBtn {
    
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)requestInfoData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_array addObject:[[WZChartsSingleColumnChartViewPoint alloc]initSingleColumnChartViewSingleX:0 singleY:43.4 zoomY:190/65]];
        [self->_array addObject:[[WZChartsSingleColumnChartViewPoint alloc]initSingleColumnChartViewSingleX:0 singleY:23.5 zoomY:190/65]];
        [self->_array addObject:[[WZChartsSingleColumnChartViewPoint alloc]initSingleColumnChartViewSingleX:0 singleY:14.7 zoomY:190/65]];
        [self->_array addObject:[[WZChartsSingleColumnChartViewPoint alloc]initSingleColumnChartViewSingleX:0 singleY:4.9 zoomY:190/65]];
        [self->_array addObject:[[WZChartsSingleColumnChartViewPoint alloc]initSingleColumnChartViewSingleX:0 singleY:55.6 zoomY:190/65]];
        
        [self->_textArray addObject:@"1-1"];
        [self->_textArray addObject:@"1-2"];
        [self->_textArray addObject:@"1-3"];
        [self->_textArray addObject:@"1-4"];
        [self->_textArray addObject:@"1-5"];
        
        [self.singleColumnChartView updateSingleColumnChartViewWithPointArray:self->_array timeArray:self->_textArray maxIncome:65];
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

- (WZChartsSingleColumnChartView *)singleColumnChartView {
    if (!_singleColumnChartView) {
        _singleColumnChartView = [[WZChartsSingleColumnChartView alloc]initWithFrame:CGRectMake(0, 16, WZWIDTHOFSCREEN, 200) columnViewParams:self.columnViewParams layerColorsArray:[@[(__bridge id)[UIColor colorFromHexString:@"#d0b1c3"].CGColor,(__bridge id)[UIColor colorFromHexString:@"#decd98"].CGColor]mutableCopy] pointArray:[@[]mutableCopy]];
        _singleColumnChartView.scrollView.delegate = self;
        _singleColumnChartView.wzChartsSingleColumnChartViewDelegate = self;
    }
    return _singleColumnChartView;
}

- (WZColumnViewParams *)columnViewParams {
    if (!_columnViewParams) {
        _columnViewParams = [WZColumnViewParams new];
        [_columnViewParams initDate];
        _columnViewParams.ifShowY = NO;
        _columnViewParams.lineYClickColor = [UIColor colorFromHexString:@"#dc8732"];
        _columnViewParams.lineYColor = [UIColor clearColor];
        _columnViewParams.lineWidth = 25;
        _columnViewParams.lineDis = 0;
    }
    return _columnViewParams;
}

@end
