//
//  XBFindLibrarySearchViewController.m
//  xueban
//
//  Created by dang on 2016/11/8.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibrarySearchViewController.h"
#import "XBFindLibrarySearchCellDataKey.h"
#import "XBFindLibrarySearchTableViewCell.h"
#import "XBFindBookDetailTableViewController.h"

@interface XBFindLibrarySearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation XBFindLibrarySearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图书馆-搜索结果"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图书馆-搜索结果"];
}

- (void)viewDidDisappear:(BOOL)animated
{
   // [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBFindLibrarySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindLibrarySearchTableViewCell class])];
    [cell configWithDict:self.searchMArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBFindBookDetailTableViewController *tableViewController = [[XBFindBookDetailTableViewController alloc] init];
    tableViewController.bookId = self.searchMArray[indexPath.section][kFindLibraryCellDataKeyBookId];
    tableViewController.configDict = self.searchMArray[indexPath.section];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0f;
}

- (void)popViewController
{
    //[self.searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter and setter
- (NSMutableArray *)searchMArray
{
    if (_searchMArray == nil)
    {
        _searchMArray = [[NSMutableArray alloc] init];
    }
    return _searchMArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREENWIDTH, SCREENHEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XBFindLibrarySearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindLibrarySearchTableViewCell class])];
    }
    return _tableView;
}
@end
