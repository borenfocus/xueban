//
//  XBBoxMoreSuggestWebViewController.m
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxMoreSuggestWebViewController.h"
#import "XBBoxMoreSuggestAPIManager.h"

@interface XBBoxMoreSuggestWebViewController()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBBoxMoreSuggestAPIManager *moreAPIManager;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, assign) NetworkLoadType loadType;

@end

@implementation XBBoxMoreSuggestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [XBProgressHUD showHUDAddedTo:self.view];
    [self.moreAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"更多推荐公众号"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"更多推荐公众号"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.moreAPIManager) {
        NSString *urlStr = [manager fetchDataWithReformer:nil][@"msg"][@"url"];
        if (urlStr) {
            self.loadType = NetworkLoadTypeGetData;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        } else
            self.loadType = NetworkLoadTypeGetNull;
        [XBProgressHUD hideHUDForView:self.view];
        [self notifyNoDataView];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.moreAPIManager) {
        [XBProgressHUD hideHUDForView:self.view];
        [self notifyNoDataView];
    }
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"更多推荐";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"空空如也"];
    else
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
}

- (void)setNoDataViewImageName:(NSString *)imageName withTitle:(NSString *)title {
    if (self.noDataView == nil) {
        self.noDataView = [XBNoDataView configImageName:imageName withTitle:title];
    }
    [self.view addSubview:self.noDataView];
}

- (void)clearNoDataView {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
    }
}

#pragma mark - getter and setter
- (XBBoxMoreSuggestAPIManager *)moreAPIManager {
    if (!_moreAPIManager) {
        _moreAPIManager = [[XBBoxMoreSuggestAPIManager alloc] init];
        _moreAPIManager.delegate = self;
    }
    return _moreAPIManager;
}

@end
