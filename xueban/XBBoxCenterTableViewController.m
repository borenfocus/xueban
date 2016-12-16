//
//  XBBoxCenterTableViewController.m
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterTableViewController.h"
#import "XBBoxSetTableViewController.h"
#import "XBBoxCenterNewsWebViewController.h"
#import "XBBoxCenterTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "XBBoxCenterAPIManager.h"
#import "XBBoxCenterReformer.h"
#import "XBBoxContentCellDataKey.h"
#import "XBBoxCenterCellDataKey.h"
#import "MJRefresh.h"
#import "XBRefreshHeader.h"
#import "UIImageView+WebCache.h"

@interface XBBoxCenterTableViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    CGFloat oldOffset;
    BOOL isScrollToBottom;
}
@property (nonatomic, strong) NSNumber *lastId;
@property (nonatomic, strong) NSMutableArray *newsListArray;
@property (nonatomic, strong) NSMutableArray *imageViewHeightArray;
@property (nonatomic, strong) XBBoxCenterAPIManager *centerAPIManager;
@property (nonatomic, strong) XBBoxCenterReformer *centerReformer;
@end

@implementation XBBoxCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    oldOffset = 0;
    isScrollToBottom = NO;
    [self initNavigationItem];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBBoxCenterTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxCenterTableViewCell class])];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.centerAPIManager loadData];
    }];
    [self initNavigationItem];
    self.centerAPIManager.officialId = self.configDict[kBoxContentCellDataKeyId];
    [self.centerAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订阅号列表"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        self.lastId = @0;
        [self.centerAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订阅号列表"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDateSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.newsListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBBoxCenterTableViewCell *cell;
    //    [self configureCell:cell atIndexPath:indexPath];
    cell.imageViewHeight = [self.imageViewHeightArray objectAtIndex:indexPath.section];
    [cell configWithDict:[self.newsListArray objectAtIndex:indexPath.section]];
    //TODO: 这个应该写一个type 0 1 2 的枚举
    if ([[self.newsListArray objectAtIndex:indexPath.section][kBoxCenterCellDataKeyType] isEqual:@1]) {
        //cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxCenterTableViewCell class]) forIndexPath:indexPath];
        cell = [[XBBoxCenterTableViewCell alloc] init];
        cell.imageViewHeight = [self.imageViewHeightArray objectAtIndex:indexPath.section];
        [cell configWithDict:[self.newsListArray objectAtIndex:indexPath.section]];
        [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[self.newsListArray objectAtIndex:indexPath.section][kBoxCenterCellDataKeyImageUrl]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // ------12.4 添加&& 因为出现了负的行高 原因未知
            if ([[self.imageViewHeightArray objectAtIndex:indexPath.section]  isEqual: @((SCREENWIDTH-15-15)*3.2/5.2)] && (image.size.height/image.size.width) > 0) {
                [self.imageViewHeightArray replaceObjectAtIndex:indexPath.section withObject:@((image.size.height/image.size.width) * (SCREENWIDTH-15-15))];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxCenterTableViewCell class])];
        [cell configWithDict:[self.newsListArray objectAtIndex:indexPath.section]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.newsListArray objectAtIndex:indexPath.section][kBoxCenterCellDataKeyType] isEqual:@1])
    {
        return 130 + [[self.imageViewHeightArray objectAtIndex:indexPath.section] floatValue];
    }
    else
    {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBBoxCenterTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBBoxCenterTableViewCell * cell) {
            [cell configWithDict:[self.newsListArray objectAtIndex:indexPath.section]];
        }];
        return height;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBBoxCenterNewsWebViewController *webViewController = [[XBBoxCenterNewsWebViewController alloc] init];
    webViewController.urlStr = [self.newsListArray objectAtIndex:indexPath.section][kBoxCenterCellDataKeyUrl];
    webViewController.fileArray = [self.newsListArray objectAtIndex:indexPath.section][kBoxCenterCellDataKeyFiles];
    webViewController.officialId = self.configDict[kBoxContentCellDataKeyId];
    webViewController.newsDict = [self.newsListArray objectAtIndex:indexPath.section];
    webViewController.officialTitle = self.configDict[kBoxContentCellDataKeyTitle];
    webViewController.officialImageUrl = self.configDict[kBoxContentCellDataKeyImageUrl];
    webViewController.officialConfigDict = self.configDict;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < oldOffset)
    {
        isScrollToBottom = YES;
    }
    else
    {
        isScrollToBottom = NO;
    }
    oldOffset = scrollView.contentOffset.y;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *params = @{};
    if (manager == self.centerAPIManager)
    {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.centerAPIManager) {
        NSArray *resArray = [manager fetchDataWithReformer:self.centerReformer];
        if ([self.lastId isEqual:@0]) {
            //下拉刷新
            self.newsListArray = [[NSMutableArray alloc] initWithArray:resArray];
            self.imageViewHeightArray = nil;
            self.imageViewHeightArray = [[NSMutableArray alloc] init];
        } else {
            [self.newsListArray addObjectsFromArray:resArray];
        }
        for (NSInteger i = 0; i < resArray.count; i++) {
            [self.imageViewHeightArray addObject:@((SCREENWIDTH-15-15)*3.2/5.2)];
        }
        self.lastId = [self.newsListArray lastObject][kBoxContentCellDataKeyId];
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.centerAPIManager)
    {
        
    }
    if  (self.centerAPIManager.isLastPage == YES)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
}

#pragma mark - event response
//- (void)pushToCenterDetailViewController
//{
//    XBBoxCenterDetailTableViewController *centerDetailTableViewController = [[XBBoxCenterDetailTableViewController alloc] init];
//    [self.navigationController pushViewController:centerDetailTableViewController animated:YES];
//}

- (void)popViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushToSetViewController
{
    XBBoxSetTableViewController *tableViewController = [[XBBoxSetTableViewController alloc] init];
    tableViewController.officialId = self.configDict[kBoxCenterCellDataKeyId];
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
- (NSNumber *)lastId
{
    if (!_lastId)
    {
        _lastId = @0;
    }
    return _lastId;
}

- (XBBoxCenterReformer *)centerReformer
{
    if (!_centerReformer)
    {
        _centerReformer = [[XBBoxCenterReformer alloc] init];
    }
    return _centerReformer;
}

- (XBBoxCenterAPIManager *)centerAPIManager
{
    if (!_centerAPIManager)
    {
        _centerAPIManager = [[XBBoxCenterAPIManager alloc] init];
        _centerAPIManager.paramSource = self;
        _centerAPIManager.delegate = self;
    }
    return _centerAPIManager;
}

@end
