//
//  XBFindLibraryViewController.m
//  xueban
//
//  Created by dang on 2016/10/21.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibraryViewController.h"
#import "XBFindLibrarySearchViewController.h"
#import "XBSetLibraryPasswordViewController.h"
#import "XBEmptyTableViewCell.h"
#import "XBFindLibraryHeaderTableViewCell.h"
#import "XBFindLibraryTableViewCell.h"
#import "XBFindLibraryPasswordAlertView.h"
#import "XBFindLibraryBorrowInfoAPIManager.h"
#import "XBFindLibrarySearchAPIManager.h"
#import "XBFindLibraryBorrowInfoReformer.h"
#import "XBFindLibrarySearchReformer.h"
#import "MJRefresh.h"
#import <IQKeyboardManager.h>
#import "PYSearch.h"

NSString *const kDidSetLibraryPasswordNotification = @"kDidSetLibraryPasswordNotification";

@interface XBFindLibraryViewController ()<CTAPIManagerCallBackDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XBFindLibraryPasswordAlertView *alertView;
@property (nonatomic, strong) XBFindLibraryBorrowInfoAPIManager *borrowInfoAPIManager;
@property (nonatomic, strong) XBFindLibrarySearchAPIManager *searchAPIManager;
@property (nonatomic, strong) XBFindLibraryBorrowInfoReformer *borrowInfoReformer;
@property (nonatomic, strong) XBFindLibrarySearchReformer *searchReformer;
@property (nonatomic, strong) XBFindLibrarySearchViewController *searchResultViewController;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, assign) NetworkLoadType loadType;
@property (nonatomic, strong) NSArray *borrowInfoArray;
@property (nonatomic, strong) NSMutableArray *searchMArray;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation XBFindLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self initNavigationItem];
    [self.view addSubview:self.tableView];
    [self initSearchController];
    [XBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow];
    [self.borrowInfoAPIManager loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetLibraryPasswordNotificationAction) name:kDidSetLibraryPasswordNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [MobClick beginLogPageView:@"图书馆"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
    [MobClick endLogPageView:@"图书馆"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.borrowInfoArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        XBFindLibraryHeaderTableViewCell *cell = [[XBFindLibraryHeaderTableViewCell alloc] init];
        return cell;
    }
    else
    {
        XBFindLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindLibraryTableViewCell class])];
        [cell configWithDict:self.borrowInfoArray[indexPath.section-1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0)
    {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 40.0f;
    }
    return 170.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [XBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
    if (manager == self.borrowInfoAPIManager)
    {
        self.borrowInfoArray = [manager fetchDataWithReformer:self.borrowInfoReformer];
        [self.tableView reloadData];
    }
    else if (manager == self.searchAPIManager)
    {
        if (self.searchAPIManager.isNullData)
        {
            self.loadType = NetworkLoadTypeGetNull;
            [self notifyNoDataView];
        }
        else
        {
            self.loadType = NetworkLoadTypeGetData;
            if (self.searchAPIManager.isLastPage)
            {
                [self.searchResultViewController.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.searchResultViewController.tableView.mj_footer endRefreshing];
            }
            if (self.searchAPIManager.isFirstPage)
            {
                [self.searchMArray removeAllObjects];
            }
            
            [self.searchMArray addObjectsFromArray:[manager fetchDataWithReformer:self.searchReformer]];
            self.searchResultViewController.searchMArray = self.searchMArray;
            [self.searchResultViewController.tableView reloadData];
        }
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [self.searchResultViewController.tableView.mj_footer endRefreshing];
    [XBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
    
    if (manager == self.borrowInfoAPIManager) {
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        NSNumber *code = responseDict[@"code"];
        if ([code intValue] == -3)
    {
            self.alertView = [[XBFindLibraryPasswordAlertView alloc] init];
            [self.alertView show];
            __weak typeof(self.alertView) weakAlertView = self.alertView;
            self.alertView.cancelHandler = ^(){
                [weakAlertView close];
            };
            self.alertView.confirmHandler = ^(){
                [weakAlertView close];
                XBSetLibraryPasswordViewController *viewController = [[XBSetLibraryPasswordViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            };
        }
        else if (code != nil)
        {
            [MBProgressHUD showMessage:@"网络连接失败" view:self.view];
        }
    }
    else if (manager == self.searchAPIManager)
    {
        [MBProgressHUD showMessage:@"网络连接失败" view:self.searchResultViewController.tableView];
    }
}

#pragma mark - UISearchDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0)
    {
        [self.searchResultViewController.navigationController popToRootViewControllerAnimated:NO];
        [self.searchResultViewController.searchMArray removeAllObjects];
        [self.searchResultViewController.tableView reloadData];
        [self clearNoDataView];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [XBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow];
    self.searchAPIManager.searchText = searchBar.text;
    [self.searchAPIManager loadFirstPage];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResultViewController.searchMArray removeAllObjects];
    [self.searchResultViewController.tableView reloadData];
    [self clearNoDataView];
    [XBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
    [self.searchAPIManager cancelAllRequests];//取消这次搜索操作
}

#pragma mark - UISearchResultsUpdating
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController.searchBar setShowsCancelButton:YES animated:NO];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [searchController.searchBar setShowsCancelButton:YES animated:YES];
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (id searchbuttons in [[searchController.searchBar subviews][0]subviews]) //只需在此处修改即可
    {
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitle:@"返回"forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [cancelButton setTitleColor:[UIColorwhiteColor] forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSetLibraryPasswordNotificationAction
{
    [self.borrowInfoAPIManager loadData];
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"图书馆";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)initSearchController
{
    self.searchResultViewController = [[XBFindLibrarySearchViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.searchResultViewController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:navigation];
    self.searchController.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.searchController.searchResultsUpdater = self;
    self.searchResultViewController.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.searchAPIManager loadNextPage];
    }];

    self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.obscuresBackgroundDuringPresentation = NO;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.searchBar.delegate = self;
    
    self.searchResultViewController.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    //去掉灰色背景
    [[[[self.searchController.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    [self.searchController.searchBar setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    //    self.searchController.searchBar.layer.cornerRadius = 15.0f;
    self.searchController.searchBar.layer.masksToBounds = YES;
    //    [self.searchController.searchBar.layer setBorderWidth:5];
    //设置边框为白色
    [self.searchController.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.searchController.searchBar setPlaceholder:@"输入您想查找的书籍"];

}

- (void)notifyNoDataView
{
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"search_empty" withTitle:@"没有搜索结果"];
    else
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
}

- (void)setNoDataViewImageName:(NSString *)imageName withTitle:(NSString *)title
{
    if (self.noDataView == nil)
    {
        self.noDataView = [XBNoDataView configImageName:imageName withTitle:title];
    }
    [self.searchResultViewController.tableView addSubview:self.noDataView];
}

- (void)clearNoDataView
{
    if (self.noDataView)
    {
        [self.noDataView removeFromSuperview];
    }
}

#pragma mark - getter and setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XBFindLibraryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindLibraryTableViewCell class])];
    }
    return _tableView;
}

- (XBFindLibraryBorrowInfoAPIManager *)borrowInfoAPIManager
{
    if (_borrowInfoAPIManager == nil)
    {
        _borrowInfoAPIManager = [[XBFindLibraryBorrowInfoAPIManager alloc] init];
        _borrowInfoAPIManager.delegate = self;
    }
    return _borrowInfoAPIManager;
}

- (XBFindLibrarySearchAPIManager *)searchAPIManager
{
    if (_searchAPIManager == nil)
    {
        _searchAPIManager = [[XBFindLibrarySearchAPIManager alloc] init];
        _searchAPIManager.delegate = self;
    }
    return _searchAPIManager;
}

- (XBFindLibraryBorrowInfoReformer *)borrowInfoReformer
{
    if (_borrowInfoReformer == nil)
    {
        _borrowInfoReformer = [[XBFindLibraryBorrowInfoReformer alloc] init];
    }
    return _borrowInfoReformer;
}

- (XBFindLibrarySearchReformer *)searchReformer
{
    if (_searchReformer == nil)
    {
        _searchReformer = [[XBFindLibrarySearchReformer alloc] init];
    }
    return _searchReformer;
}

- (NSMutableArray *)searchMArray
{
    if (_searchMArray == nil)
    {
        _searchMArray = [[NSMutableArray alloc] init];
    }
    return _searchMArray;
}

@end
