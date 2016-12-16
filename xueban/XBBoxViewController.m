 //
//  XBBoxViewController.m
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxViewController.h"
#import "XBBoxBannerTableViewCell.h"
#import "XBBoxToolHeaderTableViewCell.h"
#import "XBBoxCenterHeaderTableViewCell.h"
#import "XBBoxContentTableViewCell.h"

//#import "XBBoxBannerViewController.h"
#import "XBBoxMoreSuggestWebViewController.h"
#import "XBBoxSetTableViewController.h"
#import "XBBoxSearchTableViewController.h"
#import "XBBoxCenterTableViewController.h"
#import "XBBoxToolWebViewController.h"

#import "XBBoxSuggestAPIManager.h"
#import "XBBoxListAPIManager.h"
#import "XBBoxSuggestReformer.h"
#import "XBBoxListReformer.h"

#import "HorizonScrollTableView.h"
#import "XBBoxCenterCellDataKey.h"
#import "XBBoxContentCellDataKey.h"

#import "PYSearch.h"
#import "PYSearchConst.h"

extern NSString * const XBDidSignOutNotification;

@interface XBBoxViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, HorizontalTableViewDelegate, PYSearchViewControllerDelegate>
{
    PYSearchViewController *searchViewControllerCopy;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *suggestListArray;
@property (nonatomic, strong) NSMutableArray *toolListArray;
@property (nonatomic, strong) NSMutableArray *centerListArray;

@property (nonatomic, strong) UIView *toolBottomLineView;
@property (nonatomic, strong) UIView *centerBottomLineView;

@property (nonatomic, strong) XBBoxSuggestAPIManager *suggestAPIManager;
@property (nonatomic, strong) XBBoxListAPIManager *listAPIManager;
@property (nonatomic, strong) XBBoxSuggestReformer *suggestReformer;
@property (nonatomic, strong) XBBoxListReformer *listReformer;

@end

NSString *const BoxContentDidChangeNotification = @"BoxContentDidChangeNotification";

@implementation XBBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self initNavigationItem];
    self.suggestListArray = [[NSUserDefaults standardUserDefaults] objectForKey:MySuggestOfficial_Key];
    self.toolListArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyToolOfficial_Key];
    self.centerListArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyCenterOfficial_Key];
    if (self.suggestListArray == nil) {
        [self.suggestAPIManager loadData];
        [self.listAPIManager loadData];
    } else {
        //2s后刷新页面
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
    }
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boxContentDidChangeNotificationAction:) name:BoxContentDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOutNotificationAction) name:XBDidSignOutNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [MobClick beginLogPageView:@"动态"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"动态"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.centerListArray.count + 1;
    } else if(section == 2) {
        //第三方公众号 我的通知 我的私信
        return self.toolListArray.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XBBoxBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxBannerTableViewCell class])];
        cell.horizonTableView.delegate = self;
        [cell configWithArray:self.suggestListArray];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        XBBoxCenterHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxCenterHeaderTableViewCell class])];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row != 0) {
        XBBoxContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxContentTableViewCell class])];
        [cell setCellType:XBBoxContentTableViewCellTypeCenter];
        [cell configWithDict:[self.centerListArray objectAtIndex:indexPath.row-1] AtIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        XBBoxToolHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxToolHeaderTableViewCell class])];
        
        return cell;
    } else if (indexPath.section == 2 && indexPath.row != 0) {
        XBBoxContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxContentTableViewCell class])];
        [cell setCellType:XBBoxContentTableViewCellTypeTool];
        [cell configWithDict:[self.toolListArray objectAtIndex:indexPath.row-1] AtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row != 0) {
        XBBoxCenterTableViewController *centerTableViewController = [[XBBoxCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        centerTableViewController.configDict = [self.centerListArray objectAtIndex:indexPath.row-1];
        centerTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:centerTableViewController animated:YES];
    } else if (indexPath.section == 2 && indexPath.row != 0) {
        XBBoxToolWebViewController *webViewController = [[XBBoxToolWebViewController alloc] init];
        webViewController.urlStr = [self.toolListArray objectAtIndex:indexPath.row-1][kBoxContentCellDataKeyUrl];
        webViewController.officialId = [self.toolListArray objectAtIndex:indexPath.row-1][kBoxContentCellDataKeyId];
        webViewController.configDict = [self.toolListArray objectAtIndex:indexPath.row-1];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section ==2) {
        return 10.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //BannerView
        return 130.0f;
    } else if (indexPath.row != 0) {
        //ContentView
        return 70;
    } else {
        //HeaderView
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从数据源中删除
    [_centerListArray removeObjectAtIndex:indexPath.row-1];
    if ([_centerListArray count] == 0) {
        [_centerBottomLineView removeFromSuperview];
//        _centerBottomLineView = nil;
    }
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索课程/同学/订阅号/文章" didSearchBlock:nil];
    // 3. 设置风格
        searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default

        searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认

    searchViewController.searchSuggestionHidden = YES;
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
    return NO;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.listAPIManager) {
        params = @{
                   
                   };
    } else if (manager == self.suggestAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.suggestAPIManager) {
        self.suggestListArray = [NSMutableArray arrayWithArray:[manager fetchDataWithReformer:self.suggestReformer]];
        [[NSUserDefaults standardUserDefaults] setObject:self.suggestListArray forKey:MySuggestOfficial_Key];
        [self.tableView reloadData];
    } else if (manager == self.listAPIManager) {
        NSDictionary *dict = [manager fetchDataWithReformer:self.listReformer];
        self.toolListArray = [NSMutableArray arrayWithArray:dict[@"toolListArray"]];
        self.centerListArray = [NSMutableArray arrayWithArray:dict[@"centerListArray"]];
        [[NSUserDefaults standardUserDefaults] setObject:self.toolListArray forKey:MyToolOfficial_Key];
        [[NSUserDefaults standardUserDefaults] setObject:self.centerListArray forKey:MyCenterOfficial_Key];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.listAPIManager) {
        
    }
}

#pragma mark - HorizontalTableViewDelegate
- (void)horizontalTableView:(HorizonScrollTableView *)tableView didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath {
    if (contentIndexPath.row == self.suggestListArray.count) {
        //点击更多
        XBBoxMoreSuggestWebViewController *webViewController = [[XBBoxMoreSuggestWebViewController alloc] init];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else {
        XBBoxSetTableViewController *tableViewController = [[XBBoxSetTableViewController alloc] init];
        NSDictionary *configDict = [self.suggestListArray objectAtIndex:contentIndexPath.row];
        tableViewController.officialId = configDict[kBoxCenterCellDataKeyId];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    if (searchText.length) {
        searchViewControllerCopy = searchViewController;
    }
}

#pragma mark - event response
- (void)boxContentDidChangeNotificationAction:(NSNotification *)notify {
    [self.suggestAPIManager loadData];
    [self.listAPIManager loadData];
}

- (void)didSignOutNotificationAction {
    [self.suggestAPIManager loadData];
    [self.listAPIManager loadData];
}

- (void)delayMethod {
    [self.suggestAPIManager loadData];
    [self.listAPIManager loadData];
}

#pragma mark - private method
- (void)initNavigationItem {
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.py_x = PYMargin * 0.5;
    titleView.py_y = 7;
    titleView.py_width = self.view.py_width - 64 - titleView.py_x * 2;
    titleView.py_height = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.tintColor = [UIColor colorWithHexString:@"969696"];
    //去掉灰色背景
    [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    [searchBar setBackgroundColor:[UIColor clearColor]];
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 15.0f;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:5];
    //设置边框为白色
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [searchBar setPlaceholder:@"搜索课程/同学/订阅号/文章"];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XBBoxBannerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxBannerTableViewCell class])];
        [_tableView registerClass:[XBBoxToolHeaderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxToolHeaderTableViewCell class])];
        [_tableView registerClass:[XBBoxCenterHeaderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxCenterHeaderTableViewCell class])];
        [_tableView registerClass:[XBBoxContentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxContentTableViewCell class])];
    }
    return _tableView;
}

- (UIView *)toolBottomLineView {
    if (_toolBottomLineView) {
        _toolBottomLineView = [[UIView alloc] init];
        _toolBottomLineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _toolBottomLineView;
}

- (UIView *)centerBottomLineView {
    if (!_centerBottomLineView) {
        _centerBottomLineView = [[UIView alloc] init];
        _centerBottomLineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _centerBottomLineView;
}

- (XBBoxSuggestAPIManager *)suggestAPIManager {
    if (!_suggestAPIManager) {
        _suggestAPIManager = [[XBBoxSuggestAPIManager alloc] init];
        _suggestAPIManager.paramSource = self;
        _suggestAPIManager.delegate = self;
    }
    return _suggestAPIManager;
}

- (XBBoxListAPIManager *)listAPIManager {
    if (!_listAPIManager) {
        _listAPIManager = [[XBBoxListAPIManager alloc] init];
        _listAPIManager.paramSource = self;
        _listAPIManager.delegate = self;
    }
    return _listAPIManager;
}

- (XBBoxSuggestReformer *)suggestReformer {
    if (!_suggestReformer) {
        _suggestReformer = [[XBBoxSuggestReformer alloc] init];
    }
    return _suggestReformer;
}

- (XBBoxListReformer *)listReformer {
    if (!_listReformer) {
        _listReformer = [[XBBoxListReformer alloc] init];
    }
    return _listReformer;
}
@end
