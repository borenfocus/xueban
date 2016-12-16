//
//  XBMeCollectionWebViewController.m
//  xueban
//
//  Created by dang on 2016/10/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeCollectionWebViewController.h"
#import "XBMeCollectionCellDataKey.h"
#import "XBBoxCenterNewsCollectAPIManager.h"

@interface XBMeCollectionWebViewController ()

@property (nonatomic, strong) XBBoxCenterNewsCollectAPIManager *collectAPIManager;

@end

@implementation XBMeCollectionWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.configDict[kMeCollectionCellDataKeyUrl]]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-收藏详情"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-收藏详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = self.configDict[kMeCollectionCellDataKeyOfficialTitle];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

@end
