//
//  XBFindSocialTableViewController.m
//  xueban
//
//  Created by dang on 16/9/22.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindSocialTableViewController.h"
#import "XBSocialInfoViewController.h"
#import "XBFindSocialCellDataKey.h"
#import "XBFindSocialTableViewCell.h"
#import "XBFindSocialAPIManager.h"
#import "XBFindSocialReformer.h"
#import "XBRefreshHeader.h"

typedef NS_ENUM(NSInteger, SocialRightBarButtonType) {
    SocialRightBarButtonTypeAll,
    SocialRightBarButtonTypeMale,
    SocialRightBarButtonTypeFemale
};

@interface XBFindSocialTableViewController ()<CTAPIManagerParamSource ,CTAPIManagerCallBackDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) XBFindSocialAPIManager *socialAPIManager;
@property (nonatomic, strong) XBFindSocialReformer *socialReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *socialMArray;
@property (nonatomic) SocialRightBarButtonType rightBarButtonType;
@property (nonatomic, assign) NetworkLoadType loadType;
@property (nonatomic, copy) NSString *sexType;

@end

@implementation XBFindSocialTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self setupTableView];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    if (self.type == SocialTypeClassmate) {
        self.title = @"我的同学";
        self.socialAPIManager.type = SocialTypeClassmate;
    } else {
        self.title = @"我的同乡";
        self.socialAPIManager.type = SocialTypeTownee;
    }
    [self.socialAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现-社交"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.socialAPIManager loadData];
    }];
    
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现-社交"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.socialMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBFindSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindSocialTableViewCell class])];
    [cell configWithDict:self.socialMArray[indexPath.section]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBSocialInfoViewController *viewController = [[XBSocialInfoViewController alloc] init];
    viewController.configDict = [self.socialMArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            self.sexType = @"1";
            [self.socialAPIManager loadData];
            self.rightBarButtonType = SocialRightBarButtonTypeMale;
            
            break;
        case 2:
            self.sexType = @"0";
            [self.socialAPIManager loadData];
            self.rightBarButtonType = SocialRightBarButtonTypeFemale;
            break;
        case 3:
            self.sexType = @"2";
            [self.socialAPIManager loadData];
            self.rightBarButtonType = SocialRightBarButtonTypeFemale;
            break;

        default:
            break;
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{
                             
                             };
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    self.socialMArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.socialReformer]];
    if ([self.socialMArray count] > 0)
        self.loadType = NetworkLoadTypeGetData;
    else
        self.loadType = NetworkLoadTypeGetNull;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    self.loadType = NetworkLoadTypeGetFail;
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self notifyNoDataView];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBarButton {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"筛选条件 ≖‿≖✧" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"只看男生",@"只看女生",@"全部", nil];
    [alertView show];
}

#pragma mark - private method
- (void)initNavigationItem {
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [rightBarButton setImage:[UIImage imageNamed:@"find_social_sex"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBFindSocialTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindSocialTableViewCell class])];
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"同学们都去哪啦～"];
    else
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
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
- (XBFindSocialAPIManager *)socialAPIManager {
    if (_socialAPIManager == nil) {
        _socialAPIManager = [[XBFindSocialAPIManager alloc] init];
        _socialAPIManager.paramSource = self;
        _socialAPIManager.delegate = self;
    }
    return _socialAPIManager;
}

- (XBFindSocialReformer *)socialReformer {
    if (_socialReformer == nil) {
        _socialReformer = [[XBFindSocialReformer alloc] init];
    }
    return _socialReformer;
}

- (NSString *)sexType {
    if (_sexType == nil) {
        _sexType = @"2";
    }
    return _sexType;
}

@end
