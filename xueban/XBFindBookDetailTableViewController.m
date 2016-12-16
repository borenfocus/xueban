//
//  XBFindBookDetailTableViewController.m
//  xueban
//
//  Created by dang on 2016/11/6.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindBookDetailTableViewController.h"
#import "XBFindBookDetailAPIManager.h"
#import "XBFindLibrarySearchTableViewCell.h"
#import "XBFindBookDetailTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBFindBookDetailReformer.h"

@interface XBFindBookDetailTableViewController ()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBFindBookDetailAPIManager *detailAPIManager;
@property (nonatomic) NetworkLoadType loadType;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSArray *detailArray;

@end


@implementation XBFindBookDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self.tableView registerClass:[XBFindLibrarySearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindLibrarySearchTableViewCell class])];
    [self.tableView registerClass:[XBFindBookDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindBookDetailTableViewCell class])];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self.detailAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图书详情"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图书详情"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.loadType == NetworkLoadTypeGetData || self.loadType == NetworkLoadTypeGetNull) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.detailArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XBFindLibrarySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindLibrarySearchTableViewCell class])];
        //    cell.selectionStyle = selen
        [cell configWithDict:self.configDict];
        return cell;
    } else {
        XBFindBookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindBookDetailTableViewCell class])];
        cell.titleLabel.text = [self.detailArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 170.0f;
    } else {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindBookDetailTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindBookDetailTableViewCell * cell) {
            cell.titleLabel.text = [self.detailArray objectAtIndex:indexPath.row];
        }];
        return height;
    }
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    [XBProgressHUD hideHUDForView:self.tableView];
    XBFindBookDetailReformer *detailReformer = [[XBFindBookDetailReformer alloc] init];
    self.detailArray = [manager fetchDataWithReformer:detailReformer];
    if (self.detailArray.count > 0) {
        self.loadType = NetworkLoadTypeGetData;
    } else {
        self.loadType = NetworkLoadTypeGetNull;
    }
    [self.tableView reloadData];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    [XBProgressHUD hideHUDForView:self.tableView];
    self.loadType = NetworkLoadTypeGetFail;
    [self notifyNoDataView];
}

#pragma mark - private method
- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
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

#pragma mark - getter and setter
- (XBFindBookDetailAPIManager *)detailAPIManager {
    if (_detailAPIManager == nil) {
        _detailAPIManager = [[XBFindBookDetailAPIManager alloc] init];
        _detailAPIManager.delegate = self;
        _detailAPIManager.bookId = self.bookId;
    }
    return _detailAPIManager;
}

@end
