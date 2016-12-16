//
//  XBPrivateListTableViewController.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateListTableViewController.h"
#import "XBPrivateListCellDataKey.h"
#import "XBPrivateListTableViewCell.h"

#import "XBPrivateListReformer.h"
#import "XBPrivateContentViewController.h"
#import "XBBoxPrivateLetterCleanAlertView.h"
#import "XBRefreshHeader.h"
#import "RedDotView.h"

extern NSString *const kPrivateDidRecieveNotification;
NSString *const kChatDidEnterNotification = @"kChatDidEnterNotification";

@interface XBPrivateListTableViewController ()< CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
     RedDotView *_redDotView;
}
@property (nonatomic, strong) XBPrivateListReformer *listReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NetworkLoadType loadType;
@end

@implementation XBPrivateListTableViewController
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterNotificationAction:) name:kChatDidEnterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateDidRecieveNotificationAction:) name:kPrivateDidRecieveNotification object:nil];
    _redDotView = [[RedDotView alloc] initWithMaxDistance:45 bubbleColor:[UIColor colorWithHexString:RedColor]];
    [self initNavigationItem];    
    NSArray *chatArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyChatList_Key];
    if (chatArray) {
        self.listArray = [[NSMutableArray alloc] initWithArray:chatArray];
    }
    [self setupTableView];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self.listAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"私信列表"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"私信列表"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.listAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSourse 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBPrivateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBPrivateListTableViewCell class])];
    [cell configWithDict:[self.listArray objectAtIndex:indexPath.row]];
    [_redDotView attach:cell.badgeLabel withSeparateBlock:^BOOL(UIView *view) {
        cell.badgeLabel.hidden = YES;
        
        [UIApplication sharedApplication].applicationIconBadgeNumber -= [cell.badgeLabel.text integerValue];
        [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:3];
        if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
        {
            item.badgeValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
        }
        else
        {
            item.badgeValue = nil;
        }
        
        NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
        NSMutableArray *unreadListArray = [[NSMutableArray alloc] initWithArray:unreadArray];
        for (NSInteger i = 0; i < unreadListArray.count; i++)
        {
            NSDictionary *unreadDict = [unreadListArray objectAtIndex:i];
            NSDictionary *dict = [self.listArray objectAtIndex:indexPath.row];
            if ([unreadDict[@"fromId"] isEqual: dict[kPrivateListCellDataKeyUserId]])
            {
                [unreadListArray removeObjectAtIndex:i];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:[unreadListArray copy] forKey:MyUnreadArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBPrivateListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIApplication sharedApplication].applicationIconBadgeNumber -= [cell.badgeLabel.text integerValue];
    [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:3];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
    {
        item.badgeValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
    else
    {
        item.badgeValue = nil;
    }
    XBPrivateContentViewController *viewController = [[XBPrivateContentViewController alloc] init];
    viewController.userId = [self.listArray objectAtIndex:indexPath.row][kPrivateListCellDataKeyUserId];
//    viewController.configDict = [self.listArray objectAtIndex:indexPath.row];
    viewController.avatarUrl = [self.listArray objectAtIndex:indexPath.row][kPrivateListCellDataKeyHeadImg];
    [self.navigationController pushViewController:viewController animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_listArray removeObjectAtIndex:indexPath.row];
//    // 从列表中删除
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    return @{};
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.listAPIManager)
    {
        self.listArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.listReformer]];
        if ([self.listArray count] > 0)
        {
            self.loadType = NetworkLoadTypeGetData;
            [[NSUserDefaults standardUserDefaults] setObject:[self.listArray copy] forKey:MyChatList_Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
            self.loadType = NetworkLoadTypeGetNull;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [XBProgressHUD hideHUDForView:self.tableView];
        [self notifyNoDataView];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.listAPIManager)
    {
        self.loadType = NetworkLoadTypeGetFail;
        [self.tableView.mj_header endRefreshing];
        [XBProgressHUD hideHUDForView:self.tableView];
        //[self notifyNoDataView];
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBarButton
{
    XBBoxPrivateLetterCleanAlertView *alertView = [[XBBoxPrivateLetterCleanAlertView alloc] init];
    [alertView show];
    __weak typeof(alertView) weakAlertView = alertView;
    alertView.cancelHandler = ^(){
        [weakAlertView close];
    };
    alertView.confirmHandler = ^(){
        [weakAlertView close];
        [_listArray removeAllObjects];
        [self.tableView reloadData];
    };
}

- (void)privateDidRecieveNotificationAction:(NSNotification *)notify
{
    [self.listAPIManager loadData];
}

- (void)didEnterNotificationAction:(NSNotification *)notify
{
    NSDictionary *lastDict = notify.userInfo[@"lastContent"];
    [self.listArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dict[kPrivateListCellDataKeyUserId] == lastDict[@"fromId"] || dict[kPrivateListCellDataKeyUserId] == lastDict[@"toId"])
        {
            [self.listArray removeObject:dict];
            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [mutableDict setObject:lastDict[@"content"] forKey:kPrivateListCellDataKeyContent];
            [mutableDict setObject:@0 forKey:kPrivateListCellDataKeyUnreadNum];
            [self.listArray insertObject:[mutableDict copy] atIndex:0];
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - private method
- (void)initNavigationItem
{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
//    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBarButton.frame = CGRectMake(10.0f, 0.0f, 22.0f, 22.0f);
//    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"box_privateletter_clean"] forState:UIControlStateNormal];
//    [rightBarButton addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBPrivateListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBPrivateListTableViewCell class])];
}

- (void)notifyNoDataView
{
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"和好友聊聊天吧"];
    else
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
}

- (void)setNoDataViewImageName:(NSString *)imageName withTitle:(NSString *)title
{
    if (self.noDataView == nil)
    {
        self.noDataView = [XBNoDataView configImageName:imageName withTitle:title];
    }
    [self.tableView addSubview:self.noDataView];
}

- (void)clearNoDataView
{
    if (self.noDataView)
    {
        [self.noDataView removeFromSuperview];
    }
}

#pragma mark - getter and setter
- (XBPrivateListAPIManager *)listAPIManager
{
    if (!_listAPIManager)
    {
        _listAPIManager = [[XBPrivateListAPIManager alloc] init];
        _listAPIManager.delegate = self;
        _listAPIManager.paramSource = self;
    }
    return _listAPIManager;
}

- (XBPrivateListReformer *)listReformer
{
    if (!_listReformer)
    {
        _listReformer = [[XBPrivateListReformer alloc] init];
    }
    return _listReformer;
}
@end
