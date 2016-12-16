//
//  XBLoginViewController.m
//  xueban
//
//  Created by dang on 16/8/5.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBLoginViewController.h"
#import "XBRootTabBarController.h"
#import "XBLoginContainerView.h"
#import "XBLoginAPIManager.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD+Add.h"
#import "XBPersonInfoReformer.h"
#import "XBPersonInfoDataCenter.h"
#import "JPUSHService.h"

extern NSString * const XBDidSignOutNotification;

@interface XBLoginViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, UITextFieldDelegate>
{
    NSString *accountCopy;
    NSString *passwordCopy;
}
@property (nonatomic, strong) XBLoginAPIManager *loginAPIManager;

@property (nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation XBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationController.navigationBar.hidden = YES;

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 80;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    self.userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick beginLogPageView:@"登录"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.loginAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        //保存token 跳转进入到下一页
        NSDictionary *data = [manager fetchDataWithReformer:nil];
        [self.userDefaults setObject:data[@"msg"][@"term"] forKey:MyTerm_Key];
        [self.userDefaults synchronize];
        [[CTAppContext sharedInstance] updateLoginToken:data[@"msg"][@"LoginToken"] Token:data[@"msg"][@"Token"]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IF_Login];

        XBPersonInfoReformer *personInfoReformer = [[XBPersonInfoReformer alloc] init];
        NSDictionary *userDict = [manager fetchDataWithReformer:personInfoReformer];
        [[XBPersonInfoDataCenter sharedInstance] saveUser:userDict];
        
        NSString *userId = userDict[@"user_id"];
        
        //去除字符串中的标点符号 将user_id中的"-"去掉
        NSMutableString *str1 = [NSMutableString stringWithString:userId];
        for (int i = 0; i < str1.length; i++)
        {
            unichar c = [str1 characterAtIndex:i];
            NSRange range = NSMakeRange(i, 1);
            if (c == '-' || c == '(' || c == ')') //此处可以是任何字符
            {
                [str1 deleteCharactersInRange:range];
                --i;
            }
        }
        userId = [NSString stringWithString:str1];
        [JPUSHService setAlias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [XBProgressHUD hideHUDForView:self.view];
//        XBRootTabBarController *rootTabBarController = [[XBRootTabBarController alloc] init];
//        [self.navigationController pushViewController:rootTabBarController animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XBDidSignOutNotification object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.loginAPIManager)
    {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [XBProgressHUD hideHUDForView:self.view];
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        NSNumber *code = responseDict[@"code"];
        if ([code intValue] == -1)
        {
//            [MBProgressHUD showMessage:@"账户或密码错误" view:self.view];
            kShowHUD(@"账户或密码错误", nil);
        }
        else
        {
//            [MBProgressHUD showMessage:@"网络连接失败" view:self.view];
            kShowHUD(@"网络连接失败", nil);
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5f];
//    CGRect rect  = self.view.frame;
//    rect.origin.y -= 250;
//    self.view.frame = rect;
//    [UIView commitAnimations];
}

#pragma mark - event response
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark - private method
- (void)initView
{
    XBLoginContainerView *container = [[XBLoginContainerView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:container];
    container.usernameTextField.delegate = self;
    __weak typeof(self) ws = self;
    container.closeHandler = ^(){
        [ws dismissViewControllerAnimated:YES completion:nil];
    };
    container.loginHandler = ^(NSString *account, NSString *password){
        accountCopy = account;
        passwordCopy = password;
        [self.view endEditing:YES];
        [XBProgressHUD showHUDAddedTo:self.view];
        [self.loginAPIManager loadData];
    };
}

#pragma mark - getters and setters
- (XBLoginAPIManager *)loginAPIManager {
    if (_loginAPIManager == nil) {
        _loginAPIManager = [[XBLoginAPIManager alloc] init];
        _loginAPIManager.delegate = self;
        _loginAPIManager.paramSource = self;
    }
    return _loginAPIManager;
}

@end
