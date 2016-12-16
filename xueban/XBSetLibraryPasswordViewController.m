//
//  XBSetLibraryPasswordViewController.m
//  xueban
//
//  Created by dang on 16/9/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBSetLibraryPasswordViewController.h"
#import "XBSetLibraryPasswordAPIManager.h"
#import "XBSetLibraryPasswordContainerView.h"
#import <IQKeyboardManager.h>

@interface XBSetLibraryPasswordViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    NSString *libPasswordCopy;
}
@property (nonatomic, strong) XBSetLibraryPasswordAPIManager *passwordAPIManager;
//@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation XBSetLibraryPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initNavigationItem];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置图书馆密码"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置图书馆密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *params = @{};
    if (manager == self.passwordAPIManager) {
        params = @{
                    
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.passwordAPIManager) {
        [XBProgressHUD hideHUDForView:self.view];
        [self popViewController];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.passwordAPIManager) {
        
    }
    [XBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showMessage:@"网络连接失败" view:self.view];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initView {
    XBSetLibraryPasswordContainerView *containerView = [[XBSetLibraryPasswordContainerView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:containerView];
    containerView.confirmHandler = ^(NSString *libPassword){
        libPasswordCopy = libPassword;
        [XBProgressHUD showHUDAddedTo:self.view];
        [self.passwordAPIManager loadData];
    };
}

- (void)initNavigationItem {
    self.title = @"图书馆密码";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

#pragma mark - getter and setter
- (XBSetLibraryPasswordAPIManager *)passwordAPIManager {
    if (_passwordAPIManager == nil) {
        _passwordAPIManager = [[XBSetLibraryPasswordAPIManager alloc] init];
        _passwordAPIManager.delegate = self;
        _passwordAPIManager.paramSource = self;
    }
    return _passwordAPIManager;
}

@end
