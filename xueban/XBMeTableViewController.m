//
//  XBMeTableViewController.m
//  xueban
//
//  Created by dang on 16/6/24.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeTableViewController.h"
#import "XBMeHeaderTableViewCell.h"
#import "XBEmptyTableViewCell.h"
#import "XBMeTableViewCell.h"

//#import "XBMeSetTableViewController.h"
#import "AboutXueBanViewController.h"
#import "XBMeAboutTableViewController.h"
#import "XBMeDetailTableViewController.h"
#import "XBPrivateListTableViewController.h"
#import "XBMeCollectionTableViewController.h"
#import "XBBoxCenterTableViewController.h"
#import "XBMeFileTableViewController.h"
#import "XBMeHelpWebViewController.h"
#import "XBPersonInfoDataCenter.h"

NSString * const kMeDidChangeAvatarNotification = @"kMeDidChangeAvatarNotification";
extern NSString *const kPrivateDidRecieveNotification;
extern NSString *const kChatDidEnterNotification;

@interface XBMeTableViewController ()
{
    XBMeHeaderTableViewCell *headerTableViewCell;
}
@end

@implementation XBMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self initNavigationItem];
    [self setupTableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:kMeDidChangeAvatarNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateDidRecieveNotificationAction:) name:kPrivateDidRecieveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterNotificationAction:) name:kChatDidEnterNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ------ 消掉小红点
    [self.tableView reloadData];
    [MobClick beginLogPageView:@"我的"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9) {
        XBEmptyTableViewCell *cell = [[XBEmptyTableViewCell alloc] init];
        return cell;
    } else if (indexPath.row == 1) {
        headerTableViewCell = [[XBMeHeaderTableViewCell alloc] init];
        [headerTableViewCell configWithDict:[[XBPersonInfoDataCenter sharedInstance] loadUser]];
        return headerTableViewCell;
    } else {
        XBMeTableViewCell *cell = [[XBMeTableViewCell alloc] init];
        [cell configureCellAtIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9) {
        return 15;
    } else if (indexPath.row == 1) {
       return 100;
    } else {
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        XBMeDetailTableViewController *detailTableViewController = [[XBMeDetailTableViewController alloc] init];
        detailTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailTableViewController animated:YES];
    } else if (indexPath.row == 3) {
        XBMeAboutTableViewController *tableViewController = [[XBMeAboutTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        tableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else if (indexPath.row == 4) {
        XBPrivateListTableViewController *tableViewController = [[XBPrivateListTableViewController alloc] init];
        tableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else if (indexPath.row == 5) {
        XBMeCollectionTableViewController *tableViewController = [[XBMeCollectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        tableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else if (indexPath.row == 7) {
        XBMeFileTableViewController *fileTableViewController = [[XBMeFileTableViewController alloc] init];
        fileTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fileTableViewController animated:YES];
    } else if (indexPath.row == 8) {
        XBMeHelpWebViewController *webViewController = [[XBMeHelpWebViewController alloc] init];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if (indexPath.row == 10) {
//        XBMeSetTableViewController *setTableViewController = [[XBMeSetTableViewController alloc] init];
//        setTableViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:setTableViewController animated:YES];
        AboutXueBanViewController *viewController = [[AboutXueBanViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - private method
- (void)initNavigationItem {
//    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBarButton.frame = CGRectMake(10.0f, 0.0f, 40.0f, 30.0f);
//    [rightBarButton setTitle:@"设置" forState:UIControlStateNormal];
//    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [rightBarButton addTarget:self action:@selector(pushToSetViewController) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - event response
- (void)notificationAction:(NSNotification *)notify {
    headerTableViewCell.circleImageView.image = notify.userInfo[@"avatarImage"];
}

- (void)privateDidRecieveNotificationAction:(NSNotification *)notify {
    XBMeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.badgeLabel.hidden = NO;
    cell.badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
}

- (void)didEnterNotificationAction:(NSNotification *)notify {
    XBMeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    NSInteger allUnreadNum = 0;
    NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
    for (NSDictionary *dict in unreadArray) {
        allUnreadNum += [dict[@"unreadNum"] integerValue];
    }
    if (allUnreadNum > 0) {
        cell.badgeLabel.hidden = NO;
        cell.badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    } else {
        cell.badgeLabel.hidden = YES;
    }
}

@end
