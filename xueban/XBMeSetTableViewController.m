//
//  XBMeSetTableViewController.m
//  xueban
//
//  Created by dang on 16/7/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeSetTableViewController.h"
#import "XBMeSetSwitchTableViewCell.h"
#import "XBEmptyTableViewCell.h"
#import "XBMeSetTableViewCell.h"

#import "XBMeSetLanguageViewController.h"
//#import "XBMeSetAboutViewController.h"
#import "AboutXueBanViewController.h"
#import "XBMeSetSignOutAlertView.h"
#import "XBLoginViewController.h"
#import "XBCleanCacheTool.h"

@interface XBMeSetTableViewController ()

@end

@implementation XBMeSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-设置"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6)
    {
        XBEmptyTableViewCell *cell = [[XBEmptyTableViewCell alloc] init];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        XBMeSetSwitchTableViewCell *cell = [[XBMeSetSwitchTableViewCell alloc] init];
        return cell;
    }
    else
    {
        XBMeSetTableViewCell *cell = [[XBMeSetTableViewCell alloc] init];
        [cell configureCellAtIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6)
    {
        return 15;
    }
    else
    {
        if (SCREENWIDTH > 375)
        {
            return 75;
        }
        else if(SCREENWIDTH ==375)
        {
            return 60;
        }
        else
        {
            return 60;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
//        XBMeAvatarViewController *avatarViewController = [[XBMeAvatarViewController alloc] init];
//        avatarViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:avatarViewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        XBMeSetLanguageViewController *languageViewController = [[XBMeSetLanguageViewController alloc] init];
        languageViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:languageViewController animated:YES];
    }
    else if (indexPath.row == 4)
    {
       // XBMeSetHelpViewController *helpViewController = [[XBMeSetHelpViewController alloc] init];
       // helpViewController.hidesBottomBarWhenPushed = YES;
       // [self.navigationController pushViewController:helpViewController animated:YES];
    }
    else if (indexPath.row == 5)
    {
        AboutXueBanViewController *aboutViewController = [[AboutXueBanViewController alloc] init];
        aboutViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
    else if (indexPath.row == 7)
    {
        XBMeSetSignOutAlertView *alertView = [[XBMeSetSignOutAlertView alloc] init];
        [alertView show];
        __weak typeof(alertView) weakAlertView = alertView;
        alertView.cancelHandler = ^(){
            [weakAlertView close];
        };
        alertView.confirmHandler = ^(){
            [weakAlertView close];
            [XBCleanCacheTool cleanCache];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IF_Login];
            XBLoginViewController *loginViewController = [[XBLoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:^{
                self.tabBarController.selectedIndex = 0;
            }];
        };
    }
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"设置";
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
