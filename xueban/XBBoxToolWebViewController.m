//
//  XBBoxToolWebViewController.m
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxToolWebViewController.h"
#import "XBBoxSetTableViewController.h"
#import "XBBoxContentCellDataKey.h"
#import "XBBoxUnionIdAPIManager.h"
#import "XueBanAPIUrl.h"

@interface XBBoxToolWebViewController()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    NSString *unionId;
}
@property (nonatomic, strong) XBBoxUnionIdAPIManager *unionIdAPIManager;

@end

@implementation XBBoxToolWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self.unionIdAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"功能号"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"功能号"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.unionIdAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.unionIdAPIManager) {
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        unionId = responseDict[@"msg"][@"unionId"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?unionId=%@", kNetPath_Official_Func, self.officialId, unionId]]]];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.unionIdAPIManager) {

    }
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushToSetViewController {
    XBBoxSetTableViewController *tableViewController = [[XBBoxSetTableViewController alloc] init];
    tableViewController.officialId = self.configDict[kBoxContentCellDataKeyId];
    [self.navigationController pushViewController:tableViewController animated:YES];

}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = self.configDict[kBoxContentCellDataKeyTitle];
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(10.0f, 0.0f, 22.0f, 22.0f);
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"box_center_home"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(pushToSetViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

#pragma mark - getter and setter
- (XBBoxUnionIdAPIManager *)unionIdAPIManager {
    if (!_unionIdAPIManager) {
        _unionIdAPIManager = [[XBBoxUnionIdAPIManager alloc] init];
        _unionIdAPIManager.paramSource = self;
        _unionIdAPIManager.delegate = self;
    }
    return _unionIdAPIManager;
}

@end
