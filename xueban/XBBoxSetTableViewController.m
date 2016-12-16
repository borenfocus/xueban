//
//  XBBoxSetTableViewController.m
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSetTableViewController.h"
#import "XBBoxCenterTableViewController.h"
#import "XBBoxToolWebViewController.h"
#import "XBBoxSetNameTableViewCell.h"
#import "XBBoxSetInfoTableViewCell.h"
#import "XBBoxSetButtonTableViewCell.h"
#import "XBBoxSetInfoModel.h"
#import "XBBoxContentCellDataKey.h"
#import "UIImageView+WebCache.h"
#import "XBBoxCenterUnfollowAlertView.h"
#import "XBBoxCenterConcernAPIManager.h"
#import "XBBoxCenterNotifyAPIManager.h"
#import "XBBoxCenterInfoAPIManager.h"
#import "XBBoxCenterInfoKey.h"
#import "XBBoxCenterInfoReformer.h"

@interface XBBoxSetTableViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>

extern NSString *const BoxContentDidChangeNotification;

@property (nonatomic, strong) NSMutableArray *infoListArray;
@property (nonatomic, strong) XBBoxCenterConcernAPIManager *concernAPIManager;
@property (nonatomic, strong) XBBoxCenterNotifyAPIManager *notifyAPIManager;
@property (nonatomic, strong) XBBoxCenterInfoAPIManager *infoAPIManager;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, assign) NetworkLoadType loadType;
@property (nonatomic, strong) NSDictionary *infoConfigDict;
@end

@implementation XBBoxSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.infoAPIManager.officialId = self.officialId;
    [self.infoAPIManager loadData];
    [self initNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"公众号设置"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"公众号设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.loadType == NetworkLoadTypeGetData) {
        if (self.setType == XBBoxSetTypeDidConcern) {
            return 5;
        }
        return 4;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return 2;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XBBoxSetNameTableViewCell *cell = [[XBBoxSetNameTableViewCell alloc] init];
        cell.titleLabel.text = self.infoConfigDict[kBoxContentCellDataKeyTitle];
        [cell.circleImageView sd_setImageWithURL:[NSURL URLWithString:self.infoConfigDict[kBoxContentCellDataKeyImageUrl]]];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        XBBoxSetInfoTableViewCell *cell = [[XBBoxSetInfoTableViewCell alloc] init];
        cell.model = [self.infoListArray objectAtIndex:0];
        cell.lineView.hidden = NO;
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        XBBoxSetInfoTableViewCell *cell = [[XBBoxSetInfoTableViewCell alloc] init];
        cell.model = [self.infoListArray objectAtIndex:1];
        return cell;
    } else if (indexPath.section == 2) {
        XBBoxSetInfoTableViewCell *cell = [[XBBoxSetInfoTableViewCell alloc] init];
        cell.model = [self.infoListArray objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    } else if (indexPath.section == 3 && self.setType == XBBoxSetTypeDidConcern) {
        XBBoxSetInfoTableViewCell *cell = [[XBBoxSetInfoTableViewCell alloc] init];
        cell.model = [self.infoListArray objectAtIndex:3];
        cell.switchOffHandler = ^(){
            [self.notifyAPIManager loadData];
        };
        cell.switchOnHandler = ^(){
            [self.notifyAPIManager loadData];
        };
        return cell;
    } else {
        XBBoxSetButtonTableViewCell *cell = [[XBBoxSetButtonTableViewCell alloc] init];
        if (self.setType == XBBoxSetTypeDidConcern) {
            [cell.button setTitle:@"取消关注" forState:UIControlStateNormal];
            cell.button.backgroundColor = [UIColor colorWithHexString:RedColor];
        } else {
            [cell.button setTitle:@"关注" forState:UIControlStateNormal];
            cell.button.backgroundColor = [UIColor colorWithHexString:GreenColor];
        }
        cell.followHandler = ^(){
            [self.concernAPIManager loadData];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.0f;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100.0f;
    }
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self pushToOfficialViewController];
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.concernAPIManager) {
        params = @{
                   
                   };
    } else if (manager == self.notifyAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.concernAPIManager) {
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:BoxContentDidChangeNotification object:nil];
        if ([responseDict[@"msg"][@"action"] isEqualToString:@"del"]) {
            //取消关注了订阅号
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            //关注了订阅号
            [self pushToOfficialViewController];
        }
    } else if (manager == self.infoAPIManager) {
        self.loadType = NetworkLoadTypeGetData;
        XBBoxCenterInfoReformer *infoReformer = [[XBBoxCenterInfoReformer alloc] init];
        self.infoConfigDict = [manager fetchDataWithReformer:infoReformer];
        if ([self.infoConfigDict[kBoxCenterInfoKeyIsConcern] isEqual:@0])
        {
            self.setType = XBBoxSetTypeNotConcern;
        }
        else
        {
            self.setType = XBBoxSetTypeDidConcern;
        }
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.concernAPIManager) {
        
    }
    [self notifyNoDataView];
}

#pragma mark - private method
- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)initNavigationItem {
    self.title = self.infoConfigDict[kBoxContentCellDataKeyTitle];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)pushToOfficialViewController {
    if ([self.infoConfigDict[kBoxContentCellDataKeyType]  isEqual: @0])
    {
        //tool
        XBBoxToolWebViewController *webViewController = [[XBBoxToolWebViewController alloc] init];
        webViewController.urlStr = self.infoConfigDict[kBoxContentCellDataKeyUrl];
        webViewController.officialId = self.infoConfigDict[kBoxContentCellDataKeyId];
        webViewController.configDict = self.infoConfigDict;
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else {
        XBBoxCenterTableViewController *centerTableViewController = [[XBBoxCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        NSMutableDictionary *tempMDict = [[NSMutableDictionary alloc] initWithDictionary:self.infoConfigDict];
        [tempMDict setValue:@1 forKey:kBoxContentCellDataKeyIsConcern];
        centerTableViewController.configDict = [tempMDict copy];
        centerTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:centerTableViewController animated:YES];
    }
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else {
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
    }
}

- (void)setNoDataViewImageName:(NSString *)imageName withTitle:(NSString *)title {
    if (self.noDataView == nil) {
        self.noDataView = [XBNoDataView configImageName:imageName withTitle:title];
    }
    [self.tableView addSubview:self.noDataView];
}

- (void)clearNoDataView {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
    }
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter and setter
- (NSMutableArray *)infoListArray {
    if (_infoListArray == nil) {
        XBBoxSetInfoModel *aModel = [[XBBoxSetInfoModel alloc] init];
        aModel.title = self.infoConfigDict[kBoxContentCellDataKeyExtraKey];
        aModel.detail = self.infoConfigDict[kBoxContentCellDataKeyExtraValue];
        aModel.type = XBBoxSetInfoNull;
        
        XBBoxSetInfoModel *bModel = [[XBBoxSetInfoModel alloc] init];
        bModel.title = @"账号主体";
        bModel.detail = self.infoConfigDict[kBoxContentCellDataKeyBelongsTo];
        bModel.type = XBBoxSetInfoNull;
        
        XBBoxSetInfoModel *cModel = [[XBBoxSetInfoModel alloc] init];
        cModel.title = @"进入公众号";
        cModel.detail = @"";
        cModel.type = XBBoxSetInfoDisclosureIndicator;
        _infoListArray = [[NSMutableArray alloc] initWithObjects:aModel, bModel, cModel, nil];
        
        if (self.setType == XBBoxSetTypeDidConcern) {
            XBBoxSetInfoModel *dModel = [[XBBoxSetInfoModel alloc] init];
            dModel.title = @"接收推送";
            if ([self.infoConfigDict[kBoxContentCellDataKeyNotifySetting] isEqual:@"none"] || [self.infoConfigDict[kBoxContentCellDataKeyNotifySetting] isEqual:@"false"]) {
                dModel.isNotify = NO;
            } else {
                dModel.isNotify = YES;
            }
            dModel.detail = @"";
            dModel.type = XBBoxSetInfoSwitch;
            [_infoListArray addObject:dModel];
        }
    }
    return _infoListArray;
}

#pragma mark - getter and setter
- (XBBoxCenterConcernAPIManager *)concernAPIManager {
    if (!_concernAPIManager) {
        _concernAPIManager = [[XBBoxCenterConcernAPIManager alloc] init];
        _concernAPIManager.paramSource = self;
        _concernAPIManager.delegate = self;
    }
    return _concernAPIManager;
}

- (XBBoxCenterNotifyAPIManager *)notifyAPIManager {
    if (!_notifyAPIManager) {
        _notifyAPIManager = [[XBBoxCenterNotifyAPIManager alloc] init];
        _notifyAPIManager.paramSource = self;
        _notifyAPIManager.delegate = self;
    }
    return _notifyAPIManager;
}

- (XBBoxCenterInfoAPIManager *)infoAPIManager {
    if (!_infoAPIManager) {
        _infoAPIManager = [[XBBoxCenterInfoAPIManager alloc] init];
        _infoAPIManager.delegate = self;
    }
    return _infoAPIManager;
}
@end
