//
//  XBFindScoreTableViewController.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindScoreTableViewController.h"
#import "XBFindScoreTableViewCell.h"
#import "XBFindScoreAPIManager.h"
#import "XBFindScoreReformer.h"

@interface XBFindScoreTableViewController ()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBFindScoreAPIManager *scoreAPIManager;
@property (nonatomic, strong) XBFindScoreReformer   *scoreReformer;
@property (nonatomic, strong) XBNoDataView          *noDataView;
@property (nonatomic, assign) NetworkLoadType       loadType;
@property (nonatomic, strong) NSMutableArray        *scoreListArray;

@end

@implementation XBFindScoreTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self setupTableView];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self.scoreAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"考试成绩"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.scoreAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"考试成绩"];
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
    return self.scoreListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBFindScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindScoreTableViewCell class])];
    [cell configWithDict:self.scoreListArray[indexPath.row]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindScoreTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindScoreTableViewCell * cell) {
        [cell configWithDict:self.scoreListArray[indexPath.row]];
    }];
    return height;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    self.scoreListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.scoreReformer]];
    if ([self.scoreListArray count] > 0)
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

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"考试成绩";
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
    [self.tableView registerClass:[XBFindScoreTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindScoreTableViewCell class])];
}

#pragma mark - getters and setters
- (XBFindScoreAPIManager *)scoreAPIManager {
    if (_scoreAPIManager == nil) {
        _scoreAPIManager = [[XBFindScoreAPIManager alloc] init];
        _scoreAPIManager.delegate = self;
    }
    return _scoreAPIManager;
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"最近没有考试哦～"];
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

- (XBFindScoreReformer *)scoreReformer {
    if (_scoreReformer == nil) {
        _scoreReformer = [[XBFindScoreReformer alloc] init];
    }
    return _scoreReformer;
}

@end
