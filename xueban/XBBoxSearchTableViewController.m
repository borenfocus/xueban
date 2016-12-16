//
//  XBBoxSearchTableViewController.m
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSearchTableViewController.h"
#import "XBBoxSetTableViewController.h"
#import "XBSocialInfoViewController.h"
#import "XBClassDetailViewController.h"
#import "XBMeCollectionWebViewController.h"
#import "XBCourseTableViewController.h"
#import "PYSearch.h"
#import "XBBoxSearchAPIManager.h"
#import "XBBoxSearchReformer.h"
#import "XBBoxToolHeaderTableViewCell.h"
#import "XBBoxSearchHeaderTableViewCell.h"
#import "XBBoxSearchTableViewCell.h"
#import "XBBoxContentCellDataKey.h"

NSString * const kSearchTextDidChangeNotification = @"kSearchTextDidChangeNotification";

@interface XBBoxSearchTableViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, PYSearchViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSArray *officialArray;
@property (nonatomic, strong) NSArray *studentArray;
@property (nonatomic, strong) NSArray *courseArray;
@property (nonatomic, strong) NSArray *newsArray;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, assign) NetworkLoadType loadType;
@property (nonatomic, strong) XBBoxSearchReformer *searchReformer;

@end

@implementation XBBoxSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextDidChangeNotificationAction) name:kSearchTextDidChangeNotification object:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBBoxSearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBBoxSearchTableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"全搜-结果"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"全搜-结果"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultDict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.officialArray.count + 1;
    } else if (section == 1) {
        return self.studentArray.count + 1;
    } else if (section == 2) {
        return self.courseArray.count + 1;
    } else {
        return self.newsArray.count + 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view  =[UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.officialArray.count > 0) {
            if (indexPath.row == 0) {
                XBBoxSearchHeaderTableViewCell *cell = [[XBBoxSearchHeaderTableViewCell alloc] init];
                cell.titleLabel.text = @"订阅号";
                return cell;
            } else {
                XBBoxSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxSearchTableViewCell class])];
                [cell configWithDict:[self.officialArray objectAtIndex:indexPath.row-1]];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (self.studentArray.count > 0) {
            if (indexPath.row == 0) {
                XBBoxSearchHeaderTableViewCell *cell = [[XBBoxSearchHeaderTableViewCell alloc] init];
                cell.titleLabel.text = @"同学";
                return cell;
            } else {
                XBBoxSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxSearchTableViewCell class])];
                [cell configWithDict:[self.studentArray objectAtIndex:indexPath.row-1]];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else if (indexPath.section == 2) {
        if (self.courseArray.count > 0) {
            if (indexPath.row == 0) {
                XBBoxSearchHeaderTableViewCell *cell = [[XBBoxSearchHeaderTableViewCell alloc] init];
                cell.titleLabel.text = @"课程";
                return cell;
            } else {
                XBBoxSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxSearchTableViewCell class])];
                [cell configWithDict:[self.courseArray objectAtIndex:indexPath.row-1]];
                cell.circleImageView.image = [UIImage imageNamed:@"box_search_class"];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else {
        if (self.newsArray.count > 0)
        {
            if (indexPath.row == 0)
            {
                XBBoxSearchHeaderTableViewCell *cell = [[XBBoxSearchHeaderTableViewCell alloc] init];
                cell.titleLabel.text = @"相关文章";
                return cell;
            }
            else
            {
                XBBoxSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBBoxSearchTableViewCell class])];
                [cell configWithDict:[self.newsArray objectAtIndex:indexPath.row-1]];
                return cell;
            }
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row != 0) {
        XBBoxSetTableViewController *tableViewController = [[XBBoxSetTableViewController alloc] init];
        NSDictionary *configDict = [self.officialArray objectAtIndex:indexPath.row-1];
        tableViewController.officialId = configDict[kBoxContentCellDataKeyId];
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else if (indexPath.section == 1 && indexPath.row != 0) {
        XBSocialInfoViewController *viewController = [[XBSocialInfoViewController alloc] init];
        viewController.configDict = [self.studentArray objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 2 && indexPath.row != 0) {
        XBCourseTableViewController *tableViewController = [[XBCourseTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        tableViewController.configDict = [self.courseArray objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else if (indexPath.section == 3 && indexPath.row != 0) {
        XBMeCollectionWebViewController *webViewController = [[XBMeCollectionWebViewController alloc] init];
        webViewController.configDict = [self.newsArray objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.officialArray.count > 0) {
            return 15.0f;
        } else {
            return 0.001f;
        }
    } else if (section == 1) {
        if (self.studentArray.count > 0) {
            return 15.0f;
        } else {
            return 0.001f;
        }
    } else if (section == 2) {
        if (self.courseArray.count > 0) {
            return 15.0f;
        } else {
            return 0.001f;
        }
    } else {
        if (self.newsArray.count > 0) {
            return 15.0f;
        } else {
            return 0.001f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.officialArray.count > 0) {
            if (indexPath.row == 0) {
                return 40.0f;
            } else {
                return 70.0f;
            }
        } else {
            return 0.001f;
        }
    } else if (indexPath.section == 1) {
        if (self.studentArray.count > 0) {
            if (indexPath.row == 0) {
                return 40.0f;
            } else {
                return 70.0f;
            }
        } else {
            return 0.001f;
        }
    }
    else if (indexPath.section == 2) {
        if (self.courseArray.count > 0) {
            if (indexPath.row == 0) {
                return 40.0f;
            } else {
                return 70.0f;
            }
        } else {
            return 0.001f;
        }
    } else {
        if (self.newsArray.count > 0) {
            if (indexPath.row == 0) {
                return 40.0f;
            } else {
                return 70.0f;
            }
        } else {
            return 0.001f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mari - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.delegate didScroll];
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.searchAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.searchAPIManager) {
        self.resultDict = [manager fetchDataWithReformer:self.searchReformer];
        self.officialArray = self.resultDict[@"official"];
        self.studentArray = self.resultDict[@"student"];
        self.courseArray = self.resultDict[@"course"];
        self.newsArray = self.resultDict[@"news"];
        if ([self.officialArray count] > 0 || [self.studentArray count] > 0 || [self.courseArray count] > 0 || [self.newsArray count] > 0)
            self.loadType = NetworkLoadTypeGetData;
        else
            self.loadType = NetworkLoadTypeGetNull;
        [self.tableView reloadData];
    }
    [self.delegate didFinishSearch];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.searchAPIManager) {
        
    }
    [self.delegate didFinishSearch];
    [self notifyNoDataView];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchTextDidChangeNotificationAction {
    self.resultDict = nil;
    [self.tableView reloadData];
}

#pragma mark - private method
- (void)notifyNoDataView {
    if (self.loadType == NetworkLoadTypeGetData)
        [self clearNoDataView];
    else if (self.loadType == NetworkLoadTypeGetNull)
        [self setNoDataViewImageName:@"search_empty" withTitle:@"没有搜索结果"];
    else
        [self setNoDataViewImageName:@"web_error" withTitle:@"网络连接失败"];
}

- (void)setNoDataViewImageName:(NSString *)imageName withTitle:(NSString *)title {
    if (self.noDataView == nil)
    {
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
- (XBBoxSearchAPIManager *)searchAPIManager {
    if (_searchAPIManager == nil) {
        _searchAPIManager = [[XBBoxSearchAPIManager alloc] init];
        _searchAPIManager.delegate = self;
        _searchAPIManager.paramSource = self;
    }
    return _searchAPIManager;
}

- (XBBoxSearchReformer *)searchReformer {
    if (_searchReformer == nil) {
        _searchReformer = [[XBBoxSearchReformer alloc] init];
    }
    return _searchReformer;
}

@end
