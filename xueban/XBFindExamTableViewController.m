//
//  XBFindExamTableViewController.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindExamTableViewController.h"
#import "XBFindExamTableViewCell.h"
#import "XBFindExamAPIManager.h"
#import "XBFindExamReformer.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBProgressHUD.h"
#import "XBRefreshHeader.h"

@interface XBFindExamTableViewController ()<CTAPIManagerCallBackDelegate>
@property (nonatomic, strong) XBFindExamAPIManager *examAPIManager;
@property (nonatomic, strong) XBFindExamReformer *examReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *examListArray;
@property (nonatomic, assign) NetworkLoadType loadType;

@end

@implementation XBFindExamTableViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationItem];
    [self setupTableView];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self.examAPIManager loadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"考场安排"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.examAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"考场安排"];
}

- (void)didReceiveMemoryWarning
{
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
    return self.examListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBFindExamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindExamTableViewCell class])];
    [cell configWithDict:self.examListArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindExamTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindExamTableViewCell * cell) {
        [cell configWithDict:self.examListArray[indexPath.row]];
    }];
    return height;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.examAPIManager)
    {
        self.examListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.examReformer]];
        if ([self.examListArray count] > 0)
            self.loadType = NetworkLoadTypeGetData;
        else
            self.loadType = NetworkLoadTypeGetNull;
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.examAPIManager)
    {
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        NSNumber *code = responseDict[@"code"];
        if ([code intValue] == -13)
        {
            self.loadType = NetworkLoadTypeCustom;
        }
        else
        {
            self.loadType = NetworkLoadTypeGetFail;
        }
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
    self.title = @"考场安排";
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
    [self.tableView registerClass:[XBFindExamTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindExamTableViewCell class])];
}

- (void)notifyNoDataView
{
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"最近没有考试哦～"];
    else if (self.loadType == NetworkLoadTypeCustom)
        [self setNoDataViewImageName:@"data_empty" withTitle:@"没有完成教学评估"];
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

#pragma mark - getters and setters
- (XBFindExamAPIManager *)examAPIManager
{
    if (_examAPIManager == nil)
    {
        _examAPIManager = [[XBFindExamAPIManager alloc] init];
        _examAPIManager.delegate = self;
    }
    return _examAPIManager;
}

- (XBFindExamReformer *)examReformer
{
    if (_examReformer == nil)
    {
        _examReformer = [[XBFindExamReformer alloc] init];
    }
    return _examReformer;
}

@end
