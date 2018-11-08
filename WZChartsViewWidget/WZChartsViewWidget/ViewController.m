//
//  ViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/7.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "ViewController.h"
#import "WZRingChartsViewController.h"
#import "WZLineViewController.h"
#import "WZDoubleColumnViewController.h"
#import "WZGroupChartsViewController.h"
#import "WZSingleColumnViewController.h"
#import <Masonry.h>
#import "UIColor+WZPalette.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_dataArray;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

#pragma mark ❀_❀ LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ChartsDemo";
    [self.view addSubview:self.tableView];
    [self createTableViewWithData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(rectStatus.size.height+rectNav.size.height, 0, 0, 0));
    }];
}

#pragma mark @_@ UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = _dataArray[indexPath.row][@"title"];
    UIViewController *vc;
    if ([title isEqualToString:@"圆环图"]) {
        vc = [[WZRingChartsViewController alloc]init];
    }
    else if ([title isEqualToString:@"折线图"]) {
        vc = [[WZLineViewController alloc]init];
    }
    else if ([title isEqualToString:@"Single柱形图"]) {
        vc = [[WZSingleColumnViewController alloc]init];
    }
    else if ([title isEqualToString:@"Double柱形图"]) {
        vc = [[WZDoubleColumnViewController alloc]init];
    }
    else if ([title isEqualToString:@"复合图"]) {
        vc = [[WZGroupChartsViewController alloc]init];
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method

- (void)createTableViewWithData {
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dic1 = @{@"title":@"圆环图"};
    NSDictionary *dic2 = @{@"title":@"折线图"};
    NSDictionary *dic3 = @{@"title":@"Single柱形图"};
    NSDictionary *dic4 = @{@"title":@"Double柱形图"};
    NSDictionary *dic5 = @{@"title":@"复合图"};
    [_dataArray addObject:dic1];
    [_dataArray addObject:dic2];
    [_dataArray addObject:dic3];
    [_dataArray addObject:dic4];
    [_dataArray addObject:dic5];
    [self.tableView reloadData];
}

#pragma mark $_$ Public Method

#pragma mark ⚆_⚆ Get/Set

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        }
        _tableView.backgroundColor = [UIColor colorFromHexString:@"f8fafc"];
    }
    return _tableView;
}


@end
