//
//  XBMeAboutTableViewController.m
//  xueban
//
//  Created by dang on 2016/10/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeAboutTableViewController.h"
#import "XBMeAboutDetailViewController.h"
#import "XBMeAboutCellDataKey.h"
#import "XBMeAboutZanTableViewCell.h"
#import "XBMeAboutCommentTableViewCell.h"
#import "XBMeAboutReformer.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBProgressHUD.h"
#import "MJRefresh.h"
#import "XBRefreshHeader.h"

@interface XBMeAboutTableViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBMeAboutReformer *aboutReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *aboutListArray;
@property (nonatomic, assign) NetworkLoadType loadType;
@property (nonatomic, copy)   NSString *lastCreatedAt;

@end

@implementation XBMeAboutTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self initNavigationItem];
    [self setupTableView];
    [self.aboutAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-与我相关"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        self.lastCreatedAt = @"0";
        [self.aboutAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-与我相关"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.aboutListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.aboutListArray objectAtIndex:indexPath.section][kMeAboutCellDataKeyType] isEqualToNumber:@2]) {
        XBMeAboutZanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBMeAboutZanTableViewCell class])];
        [cell configWithDict:[self.aboutListArray objectAtIndex:indexPath.section]];
        cell.contentDetailHandler = ^(){
            XBMeAboutDetailViewController *viewController = [[XBMeAboutDetailViewController alloc] init];
            viewController.postId = [[self.aboutListArray objectAtIndex:indexPath.section][kMeAboutCellDataKeyPostId] integerValue];
            [self.navigationController pushViewController:viewController animated:YES];
        };
        return cell;
    } else {
        XBMeAboutCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBMeAboutCommentTableViewCell class])];
        [cell configWithDict:[self.aboutListArray objectAtIndex:indexPath.section]];
        cell.contentDetailHandler = ^(){
            XBMeAboutDetailViewController *viewController = [[XBMeAboutDetailViewController alloc] init];
            viewController.postId = [[self.aboutListArray objectAtIndex:indexPath.section][kMeAboutCellDataKeyPostId] integerValue];
            [self.navigationController pushViewController:viewController animated:YES];
        };
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.aboutListArray objectAtIndex:indexPath.section][kMeAboutCellDataKeyType] isEqualToNumber:@2]) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBMeAboutZanTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBMeAboutZanTableViewCell * cell) {
            [cell configWithDict:[self.aboutListArray objectAtIndex:indexPath.section]];
        }];
        return height;
    } else {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBMeAboutCommentTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBMeAboutCommentTableViewCell * cell) {
            [cell configWithDict:[self.aboutListArray objectAtIndex:indexPath.section]];
        }];
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.aboutAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.aboutAPIManager) {
        if ([self.lastCreatedAt isEqualToString:@"0"]) {
            //下拉刷新
            self.aboutListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.aboutReformer]];
        } else {
            [self.aboutListArray addObjectsFromArray:[manager fetchDataWithReformer:self.aboutReformer]];
        }
        self.lastCreatedAt = [self.aboutListArray lastObject][kMeAboutCellDataKeyRawTime];
        if ([self.aboutListArray count] > 0)
            self.loadType = NetworkLoadTypeGetData;
        else
            self.loadType = NetworkLoadTypeGetNull;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if  (self.aboutAPIManager.isLastPage == YES) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    if (manager == self.aboutAPIManager) {
        self.loadType = NetworkLoadTypeGetFail;
    }
    [XBProgressHUD hideHUDForView:self.tableView];
    [self notifyNoDataView];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"与我相关";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.aboutAPIManager loadData];
    }];
    [self.tableView registerClass:[XBMeAboutZanTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBMeAboutZanTableViewCell class])];
    [self.tableView registerClass:[XBMeAboutCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBMeAboutCommentTableViewCell class])];
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"没有与我相关的内容～"];
    else if (self.loadType == NetworkLoadTypeGetFail) {
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

#pragma mark - getters and setter
- (NSString *)lastCreatedAt {
    if (!_lastCreatedAt) {
        _lastCreatedAt = @"0";
    }
    return _lastCreatedAt;
}

- (XBMeAboutAPIManager *)aboutAPIManager {
    if (_aboutAPIManager == nil) {
        _aboutAPIManager = [[XBMeAboutAPIManager alloc] init];
        _aboutAPIManager.delegate = self;
        _aboutAPIManager.paramSource = self;
    }
    return _aboutAPIManager;
}

- (XBMeAboutReformer *)aboutReformer {
    if (_aboutReformer == nil) {
        _aboutReformer = [[XBMeAboutReformer alloc] init];
    }
    return _aboutReformer;
}

@end
