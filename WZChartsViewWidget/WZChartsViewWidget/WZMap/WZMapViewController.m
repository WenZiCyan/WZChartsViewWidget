//
//  WZMapViewController.m
//  WZChartsViewWidget
//
//  Created by 方静雯 on 2018/11/16.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "WZMapViewController.h"
#import "FSInteractiveMapView.h"
#import <WebKit/WebKit.h>
#import <SVGKit.h>
#import <SVGKImage.h>
#import <SVGKParser.h>
#import <Masonry.h>

@interface WZMapViewController ()

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) FSInteractiveMapView *mapView;

@property (nonatomic, weak) CAShapeLayer* oldClickedLayer;

@end

@implementation WZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *svgName = @"chinaHigh";
//
//    SVGKImage *svgImage = [SVGKImage imageNamed:svgName];
//
//    SVGKLayeredImageView *svgView = [[SVGKLayeredImageView alloc] initWithSVGKImage:svgImage];
//
//    [self.view addSubview:svgView];
//    [svgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//    }];
    self.mapView = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(16, 96, self.view.frame.size.width - 32, 500)];
    [self.mapView loadMap:@"chinaHigh" withColors:nil];
    
    [self.mapView setClickHandler:^(NSString* identifier, CAShapeLayer* layer) {
        if(self->_oldClickedLayer) {
            self->_oldClickedLayer.zPosition = 0;
            self->_oldClickedLayer.shadowOpacity = 0;
        }

        self->_oldClickedLayer = layer;
        
        // We set a simple effect on the layer clicked to highlight it
        layer.zPosition = 10;
        layer.shadowOpacity = 0.5;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 5;
        layer.shadowOffset = CGSizeMake(0, 0);
    }];
    
    [self.view addSubview:self.mapView];
}

@end
