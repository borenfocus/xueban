//
//  XBSocialInfoViewController.m
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBSocialInfoViewController.h"
#import "XBSocialInfoContainerView.h"
#import "XBFindSocialCellDataKey.h"
#import "XBPrivateContentViewController.h"
#import "UIImageView+WebCache.h"

@interface XBSocialInfoViewController ()

@end

@implementation XBSocialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社交详情"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社交详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initView {
    XBSocialInfoContainerView *containerView = [[XBSocialInfoContainerView alloc] initWithFrame:self.view.bounds];
    containerView.configDict = self.configDict;
    [self.view addSubview:containerView];
    containerView.avatarHandler = ^(){
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.configDict[kFindSocialCellDataKeyHeadImg]]];
    };
    containerView.chatHandler = ^(){
        XBPrivateContentViewController *viewController = [[XBPrivateContentViewController alloc] init];
        viewController.userId = self.configDict[kFindSocialCellDataKeyUserId];
        viewController.avatarUrl = self.configDict[kFindSocialCellDataKeyAvatarUrl];
        [self.navigationController pushViewController:viewController animated:YES];
    };
}

- (void)initNavigationItem {
    self.title = @"个人资料卡";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
}

@end
