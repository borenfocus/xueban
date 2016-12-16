//
//  XBUserAgreementWebViewController.m
//  xueban
//
//  Created by dang on 2016/10/29.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBUserAgreementWebViewController.h"

@interface XBUserAgreementWebViewController ()

@end

@implementation XBUserAgreementWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationItem];
    NSString * urlStr = @"";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"用户协议"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"用户协议"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"用户协议";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

@end
