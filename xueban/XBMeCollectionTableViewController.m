//
//  XBMeCollectionTableViewController.m
//  xueban
//
//  Created by dang on 2016/10/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeCollectionTableViewController.h"
#import "XBMeCollectionWebViewController.h"
#import "XBMeCollectionTableViewCell.h"
#import "XBMeCollectionAPIManager.h"
#import "XBMeCollectionReformer.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBRefreshHeader.h"

@interface XBMeCollectionTableViewController ()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBMeCollectionAPIManager *collectionAPIManager;
@property (nonatomic, strong) XBMeCollectionReformer *collectionReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *collectionListArray;
@property (nonatomic, assign) NetworkLoadType loadType;
@end

@implementation XBMeCollectionTableViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self initNavigationItem];
    [self setupTableView];
    [self.collectionAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-收藏"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.collectionAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-收藏"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.collectionListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBMeCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBMeCollectionTableViewCell class])];
    [cell configWithDict:[self.collectionListArray objectAtIndex:indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBMeCollectionWebViewController *webViewController = [[XBMeCollectionWebViewController alloc] init];
    webViewController.configDict = [self.collectionListArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.collectionAPIManager)
    {
        self.collectionListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.collectionReformer]];
        if ([self.collectionListArray count] > 0)
            self.loadType = NetworkLoadTypeGetData;
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
    if (manager == self.collectionAPIManager)
    {
        self.loadType = NetworkLoadTypeGetFail;
        [self.tableView.mj_header endRefreshing];
        [XBProgressHUD hideHUDForView:self.tableView];
        [self notifyNoDataView];
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"我的收藏";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBMeCollectionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBMeCollectionTableViewCell class])];
}

- (void)notifyNoDataView
{
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"还没有收藏过文章哦～"];
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

#pragma mark - getters and setter
- (XBMeCollectionAPIManager *)collectionAPIManager
{
    if (_collectionAPIManager == nil)
    {
        _collectionAPIManager = [[XBMeCollectionAPIManager alloc] init];
        _collectionAPIManager.delegate = self;
    }
    return _collectionAPIManager;
}

- (XBMeCollectionReformer *)collectionReformer
{
    
    if (_collectionReformer == nil)
    {
        _collectionReformer = [[XBMeCollectionReformer alloc] init];
    }
    return _collectionReformer;
}

@end
