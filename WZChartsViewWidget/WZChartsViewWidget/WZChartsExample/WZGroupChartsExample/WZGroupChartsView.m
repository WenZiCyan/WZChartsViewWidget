//
//  WZGroupChartsView.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/8.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZGroupChartsView.h"
#import "WZChartsDoubleColumnChartView.h"
#import "WZChartsLineChartView.h"
#import <Masonry.h>
#import "CALayer+ShadowRadius.h"
#import "WZColumnViewParams.h"
#import "WZLineViewParams.h"

@interface WZGroupChartsView() <UIScrollViewDelegate,WZChartsLineChartViewDelegate,WZChartsDoubleColumnChartViewDelegate> {
    
    NSMutableArray *_topArray;
}

@property (strong, nonatomic) UILabel *topTitleLabel;

@property (strong, nonatomic) WZChartsDoubleColumnChartView *doubleColumnChartView;

@property (strong, nonatomic) WZChartsLineChartView *lineChartView;

@property (strong, nonatomic) UIView *bottomView;
// 收益弹出View
@property (strong, nonatomic) UIView *topPopView;
// 收益弹出Label
@property (strong, nonatomic) UILabel *topPopLabel;
// 在线时长弹出Label
@property (strong, nonatomic) UILabel *leftPopLabel;
// 工作时长弹出Label
@property (strong, nonatomic) UILabel *rightPopLabel;

@property (assign, nonatomic) NSInteger lastClickBtnTag;

@property (strong, nonatomic) NSMutableArray<WZChartsLineChartViewPoint *> *topPointArray;

@property (strong, nonatomic) NSMutableArray<WZChartsDoubleColumnChartViewPoint *> *bottomPointArray;

@property (strong, nonatomic) NSMutableArray<NSString *> *timeArray;

@property (strong, nonatomic) WZLineViewParams *lineViewParams;

@property (strong, nonatomic) WZColumnViewParams *columnViewParams;

@end

@implementation WZGroupChartsView

#pragma mark ❀_❀ LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topPointArray = [NSMutableArray arrayWithCapacity:0];
        self.bottomPointArray = [NSMutableArray arrayWithCapacity:0];
        self.timeArray = [NSMutableArray arrayWithCapacity:0];
        _topArray = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = [UIColor whiteColor];
        self.lastClickBtnTag = -1;
        [self createCellSubView];
    }
    return self;
}

- (void)createCellSubView {
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.offset(24);
    }];
    [self addSubview:self.lineChartView];
    [self addSubview:self.doubleColumnChartView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.right.offset(-24);
        make.top.equalTo(self.doubleColumnChartView.mas_bottom).offset(30);
    }];
}

#pragma mark ▷_▷ UIScrollViewDelegate
// 两视图同时滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:_lineChartView.scrollView]){
        CGPoint offset = _doubleColumnChartView.scrollView.contentOffset;
        offset.x = _lineChartView.scrollView.contentOffset.x;
        [_doubleColumnChartView.scrollView setContentOffset:offset];
    }else{
        CGPoint offset = _lineChartView.scrollView.contentOffset;
        offset.x = _doubleColumnChartView.scrollView.contentOffset.x;
        [_lineChartView.scrollView setContentOffset:offset];
    }
    [_lineChartView updateSlideLineChart:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    BOOL turnLeft = scrollView.contentOffset.x<=0?YES:NO;
    if (_wzGroupChartsViewDelegte && [_wzGroupChartsViewDelegte respondsToSelector:@selector(wzGroupChartsView:scrollViewDidScrollPage:turnLeft:)]) {
        [_wzGroupChartsViewDelegte wzGroupChartsView:self scrollViewDidScrollPage:currentPage turnLeft:turnLeft];
    }
}

#pragma mark ✬_✬ WZChartsLineChartViewDelegate

- (void)wzChartsLineChartView:(WZChartsLineChartView *)lineChartView pointBtn:(UIButton *)pointBtn {
    [self.doubleColumnChartView updateDoubleColumnChartViewClickStatusWithTag:pointBtn.tag];
    [self updateAPBottomChartsGroupViewWithClickBtn:pointBtn];
}

#pragma mark ✺_✺ WZChartsDoubleColumnChartViewDelegate

- (void)wzChartsDoubleColumnChartView:(WZChartsDoubleColumnChartView *)doubleColumnChartView clickBtn:(UIButton *)clickBtn {
    [self.lineChartView updateLineChartViewClickStatusWithTag:clickBtn.tag];
    [self updateAPBottomChartsGroupViewWithClickBtn:clickBtn];
}

#pragma mark ➶_➴ Event Response

#pragma mark ◎_◎ Private Method
// 更新点击事件
- (void)updateAPBottomChartsGroupViewWithClickBtn:(UIButton *)clickBtn {
    self.lastClickBtnTag = clickBtn.tag;
    self.leftPopLabel.hidden = !clickBtn.selected;
    self.rightPopLabel.hidden = !clickBtn.selected;
    
    self.topPopView.transform = CGAffineTransformMakeScale(0,0);
    CGPoint topPopPoint = [self.lineChartView getLineChartViewClickPointWithTag:clickBtn.tag];
    if ([self getClickAngleWithClickTag:clickBtn.tag] >= M_PI) {
        self.topPopView.center = CGPointMake(topPopPoint.x, topPopPoint.y - 25);
    } else {
        self.topPopView.center = CGPointMake(topPopPoint.x, topPopPoint.y + 25);
    }
    
    WZChartsLineChartViewPoint *topPoint = (WZChartsLineChartViewPoint *)self.topPointArray[clickBtn.tag];
    self.topPopLabel.text = [NSString stringWithFormat:@"%.4f",topPoint.textY];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topPopView.transform = clickBtn.selected?CGAffineTransformMakeScale(1,1):CGAffineTransformMakeScale(0, 0);
    } completion:nil];
    
    NSArray<NSValue *> *pointArray = [self.doubleColumnChartView getDoubleColumnChartViewClickPointWithTag:clickBtn.tag];
    CGPoint leftPopPoint = [[pointArray objectAtIndex:0] CGPointValue];
    self.leftPopLabel.center = CGPointMake(leftPopPoint.x-3, leftPopPoint.y-15);
    
    CGPoint rightPopPoint = [[pointArray objectAtIndex:1] CGPointValue];
    self.rightPopLabel.center = CGPointMake(rightPopPoint.x+3, rightPopPoint.y-15);
    
    WZChartsDoubleColumnChartViewPoint *point = (WZChartsDoubleColumnChartViewPoint *)self.bottomPointArray[clickBtn.tag];
    self.leftPopLabel.text = [NSString stringWithFormat:@"%.1f",point.leftTextY];
    self.rightPopLabel.text = [NSString stringWithFormat:@"%.1f",point.rightTextY];
}
// 返回角度
- (float)getClickAngleWithClickTag:(NSInteger)clickTag {
    WZChartsLineChartViewPoint *clickPoint = (WZChartsLineChartViewPoint *)self.topPointArray[clickTag];
    if (clickPoint.y < 35) {
        return 360;
    }
    if (clickPoint.y > 165) {
        return 0;
    }
    WZChartsLineChartViewPoint *leftClickPoint;
    if (clickTag == 0) {
        leftClickPoint = [[WZChartsLineChartViewPoint alloc]init];
        leftClickPoint.y = 0;
    } else {
        leftClickPoint = (WZChartsLineChartViewPoint *)self.topPointArray[clickTag-1];
    }
    
    WZChartsLineChartViewPoint *rightClickPoint;
    if (clickTag == self.topPointArray.count - 1) {
        rightClickPoint = [[WZChartsLineChartViewPoint alloc]init];
        rightClickPoint.y = 0;
    } else {
        rightClickPoint = (WZChartsLineChartViewPoint *)self.topPointArray[clickTag+1];
    }
    
    CGFloat x11 = -5;
    CGFloat y11 = leftClickPoint.y - clickPoint.y;
    CGFloat x12 = 0;
    CGFloat y12 = 5;
    
    CGFloat x1 = x11 * x12 + y11 * y12;
    CGFloat y1 = x11 * y12 - x12 * y11;
    
    CGFloat x21 = 0;
    CGFloat y21 = 5;
    CGFloat x22 = 5;
    CGFloat y22 = rightClickPoint.y - clickPoint.y;
    
    CGFloat x2 = x21 * x22 + y21 * y22;
    CGFloat y2 = x21 * y22 - x22 * y21;
    
    return acos(x1/sqrt(x1 * x1 + y1 * y1)) + acos(x2/sqrt(x2 * x2 + y2 * y2));
}

#pragma mark $_$ Public Method
// 更新图表
- (void)updateBottomChartsGroupViewWithViewWithArray:(NSMutableArray *)array topMaxIncome:(float)topMaxIncome bottomMaxIncome:(float)bottomMaxIncome {
    _topArray = array;
    for (int i = 0; i < _topArray.count; i++) {
        [self.topPointArray addObject:[[WZChartsLineChartViewPoint alloc] initLineChartViewPointX:0 pointY:[_topArray[i][@"pointY"] floatValue] maxY:topMaxIncome <= 5?5:topMaxIncome zoomY:[_topArray[i][@"topZoomY"] floatValue]]];
        [self.bottomPointArray addObject:[[WZChartsDoubleColumnChartViewPoint alloc] initDoubleColumnChartViewPointX:0 pointLeftY:[_topArray[i][@"pointLeftY"] floatValue] pointRightY:[_topArray[i][@"pointRightY"] floatValue] zoomY:[_topArray[i][@"bottomZoomY"] floatValue]]];
        [self.timeArray addObject:@"1-1"];
    }
    [self.lineChartView updateLineChartViewWithPointArray:self.topPointArray timeArray:self.timeArray maxIncome:topMaxIncome <= 5?5:topMaxIncome];
    [self.doubleColumnChartView updateDoubleColumnChartViewWithPointArray:self.bottomPointArray timeArray:[@[]mutableCopy] maxIncome:bottomMaxIncome];
    
    if (self.lastClickBtnTag > -1) {
        CGPoint topPopPoint = [self.lineChartView getLineChartViewClickPointWithTag:self.lastClickBtnTag];
        if ([self getClickAngleWithClickTag:self.lastClickBtnTag] >= M_PI) {
            self.topPopView.center = CGPointMake(self.topPopView.center.x+_topArray.count*self.lineChartView.yEachWidth, topPopPoint.y - 25);
        } else {
            self.topPopView.center = CGPointMake(self.topPopView.center.x+_topArray.count*self.lineChartView.yEachWidth, topPopPoint.y + 25);
        }
    }
    self.leftPopLabel.center = CGPointMake(self.leftPopLabel.center.x+_topArray.count*self.lineChartView.yEachWidth, self.leftPopLabel.center.y);
    self.rightPopLabel.center = CGPointMake(self.rightPopLabel.center.x+_topArray.count*self.lineChartView.yEachWidth, self.rightPopLabel.center.y);
}
// 初始化图表 -_- 应该有更好的方法吧
- (void)initBottomChartsGroupViewWithViewWithArray:(NSMutableArray *)array topMaxIncome:(float)topMaxIncome bottomMaxIncome:(float)bottomMaxIncome {
    [_lineChartView removeFromSuperview];
    [_doubleColumnChartView removeFromSuperview];
    [_topPopView removeFromSuperview];
    [_leftPopLabel removeFromSuperview];
    [_rightPopLabel removeFromSuperview];
    [_bottomView removeFromSuperview];
    _lineChartView = nil;
    _doubleColumnChartView = nil;
    _topPopView = nil;
    _leftPopLabel = nil;
    _rightPopLabel = nil;
    _bottomView = nil;
    self.topPointArray = [NSMutableArray arrayWithCapacity:0];
    self.bottomPointArray = [NSMutableArray arrayWithCapacity:0];
    self.timeArray = [NSMutableArray arrayWithCapacity:0];
    self.lastClickBtnTag = -1;
    [self addSubview:self.lineChartView];
    [self addSubview:self.doubleColumnChartView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.right.offset(-24);
        make.top.equalTo(self.doubleColumnChartView.mas_bottom).offset(30);
    }];
    [self updateBottomChartsGroupViewWithViewWithArray:array topMaxIncome:topMaxIncome bottomMaxIncome:bottomMaxIncome];
    // 初始默认点击显示点
    if (_topArray.count >= 3) {
        self.lastClickBtnTag = _topArray.count-3;
    } else {
        self.lastClickBtnTag = 0;
    }
    [self.lineChartView updateLineChartViewClickStatusWithTag:self.lastClickBtnTag];
    [self.doubleColumnChartView updateDoubleColumnChartViewClickStatusWithTag:self.lastClickBtnTag];
    [self updateAPBottomChartsGroupViewWithClickBtn:[self.lineChartView getLineChartViewClickPointWithBtn:self.lastClickBtnTag]];
}

#pragma mark ⚆_⚆ Get/Set

- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:_topTitleLabel];
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
        _topTitleLabel.backgroundColor = [UIColor whiteColor];
        _topTitleLabel.text = @"XXXXX(标题)";
        [self addSubview:_topTitleLabel];
    }
    return _topTitleLabel;
}

- (WZChartsLineChartView *)lineChartView {
    if (!_lineChartView) {
        _lineChartView = [[WZChartsLineChartView alloc]initWithFrame:CGRectMake(0, 75, self.frame.size.width, 230) lineViewParams:self.lineViewParams pointArray:[@[]mutableCopy]];
        _lineChartView.scrollView.delegate = self;
        _lineChartView.wzChartsLineChartViewDelegate = self;
        _lineChartView.clipsToBounds = YES;
    }
    return _lineChartView;
}

- (WZChartsDoubleColumnChartView *)doubleColumnChartView {
    if (!_doubleColumnChartView) {
        _doubleColumnChartView = [[WZChartsDoubleColumnChartView alloc]initWithFrame:CGRectMake(0, self.lineChartView.frame.origin.y + self.lineChartView.frame.size.height, self.frame.size.width, 200) columnViewParams:self.columnViewParams leftLayerColorsArray:[@[]mutableCopy] rightLayerColorsArray:[@[]mutableCopy] pointArray:[@[]mutableCopy]];
        _doubleColumnChartView.scrollView.delegate = self;
        _doubleColumnChartView.wzChartsDoubleColumnChartViewDelegate = self;
    }
    return _doubleColumnChartView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        UIView *dayOnLineView = [self bottomEachViewWithTitle:@"左边XXXX(h)" imgStr:@"img_accelerator_dayonline"];
        UIView *dayWorkHourView = [self bottomEachViewWithTitle:@"右边XXXX(h)" imgStr:@"img_ situation_daywork"];
        [self addSubview:_bottomView];
        [dayOnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self->_bottomView);
            make.right.equalTo(self->_bottomView.mas_centerX).offset(-8);
        }];
        [dayWorkHourView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self->_bottomView);
            make.left.equalTo(self->_bottomView.mas_centerX).offset(8);
        }];
    }
    return _bottomView;
}

// 列表小分块
- (UIView *)bottomEachViewWithTitle:(NSString *)title imgStr:(NSString *)imgStr {
    UIView *bkView = [UIView new];
    bkView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:bkView];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorFromHexString:@"#333333"];
    [bkView addSubview:label];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = title;
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
    [bkView addSubview:img];
    img.backgroundColor = [UIColor whiteColor];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.centerY.equalTo(bkView);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(4);
        make.centerY.equalTo(bkView);
        make.right.equalTo(bkView);
    }];
    
    return bkView;
}

- (UIView *)topPopView {
    if (!_topPopView) {
        _topPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.lineChartView.yEachWidth, 25)];
        _topPopLabel = [[UILabel alloc]initWithFrame:_topPopView.bounds];
        _topPopLabel.textAlignment = NSTextAlignmentCenter;
        _topPopLabel.backgroundColor = [UIColor clearColor];
        _topPopLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        _topPopLabel.font = [UIFont fontWithName:@"DIN Alternate" size:13];
        _topPopLabel.text = @"0.0000";
        [_topPopView addSubview:_topPopLabel];
        [_topPopView.layer setCornerRadius:CGSizeMake(2, 2) roundingCorners:UIRectCornerAllCorners shadowRect:_topPopView.bounds superV:_topPopView];
        [_topPopView.layer setCustomShadowWithShadowColor:[UIColor colorFromHexString:@"#e5e5e5"] shadowOffset:CGSizeMake(0, 1) shadowRadius:5 shadowOpacity:1 shadowRect:_topPopView.bounds superV:_topPopView];
        _topPopView.transform = CGAffineTransformMakeScale(0,0);
        [self.lineChartView.scrollView addSubview:_topPopView];
    }
    return _topPopView;
}

- (UILabel *)leftPopLabel {
    if (!_leftPopLabel) {
        _leftPopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
        _leftPopLabel.textAlignment = NSTextAlignmentCenter;
        _leftPopLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        _leftPopLabel.font = [UIFont fontWithName:@"DIN Alternate" size:13];
        _leftPopLabel.text = @"0";
        [self.doubleColumnChartView.scrollView addSubview:_leftPopLabel];
    }
    return _leftPopLabel;
}

- (UILabel *)rightPopLabel {
    if (!_rightPopLabel) {
        _rightPopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
        _rightPopLabel.textAlignment = NSTextAlignmentCenter;
        _rightPopLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        _rightPopLabel.font = [UIFont fontWithName:@"DIN Alternate" size:13];
        _rightPopLabel.text = @"0";
        [self.doubleColumnChartView.scrollView addSubview:_rightPopLabel];
    }
    return _rightPopLabel;
}

- (WZLineViewParams *)lineViewParams {
    if (!_lineViewParams) {
        _lineViewParams = [WZLineViewParams new];
        [_lineViewParams initDate];
    }
    return _lineViewParams;
}

- (WZColumnViewParams *)columnViewParams {
    if (!_columnViewParams) {
        _columnViewParams = [WZColumnViewParams new];
        [_columnViewParams initDate];
    }
    return _columnViewParams;
}


@end
