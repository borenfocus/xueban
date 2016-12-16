//
//  XBFindNightMeetTableViewController.m
//  xueban
//
//  Created by dang on 16/8/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetTableViewController.h"
#import "XBFindNightMeetDetailViewController.h"
#import "XBFindNightMeetWritePostViewController.h"
#import "XBFindNightMeetTableViewCell.h"
#import "XBFindNightMeetTableViewCellDataKey.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBFindNightMeetPostAPIManager.h"
#import "XBFindNightMeetZanPostAPIManager.h"
#import "XBFindNightMeetPostReformer.h"
#import "XBSocialInfoViewController.h"
#import "XBInputView.h"
#import "MJRefresh.h"
#import "XBRefreshHeader.h"

//temp
#import "CTAppContext.h"

NSString *const kNightMeetDidChangePostNotification = @"kNightMeetDidChangePostNotification";
NSString *const kNightMeetDidWritePostNotification = @"kNightMeetDidWritePostNotification";

@interface XBFindNightMeetTableViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    XBFindNightMeetTableViewCell *zanPostCell;
}
@property (nonatomic, strong) XBFindNightMeetPostAPIManager *postAPIManager;
@property (nonatomic, strong) XBFindNightMeetZanPostAPIManager *zanPostAPIManager;
@property (nonatomic, strong) XBFindNightMeetPostReformer *postReformer;
@property (nonatomic, strong) XBNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *postListArray;

@end

@implementation XBFindNightMeetTableViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCellNotificationAction:) name:kNightMeetDidChangePostNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewNotificationAtion) name:kNightMeetDidWritePostNotification object:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    //[self.tableView registerClass:[XBFindNightMeetHeaderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindNightMeetHeaderTableViewCell class])];
    [self.tableView registerClass:[XBFindNightMeetTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindNightMeetTableViewCell class])];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.postAPIManager loadNextPage];
    }];
    [self initNavigationItem];
    [XBProgressHUD showHUDAddedTo:self.tableView];
    [self.postAPIManager loadFirstPage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    [MobClick beginLogPageView:@"卧谈会"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.postAPIManager loadFirstPage];
    }];
    self.tableView.mj_header = header;
}
//
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"卧谈会"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.postListArray count])
    {
        return self.postListArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBFindNightMeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindNightMeetTableViewCell class])];
    UIImageView *disclosureIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enter"]];
    [cell.contentView addSubview:disclosureIndicator];
    [disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15.0f);
        make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
        make.right.offset(-20.0f);
    }];
    __weak typeof(cell) weakCell = cell;
    NSDictionary *postDict = [self.postListArray objectAtIndex:indexPath.section];
    if ([postDict[kFindNightMeetTableViewCellDataKeyIsAnonymous] isEqual:@0])
    {
        cell.avatarHandler = ^(){
            XBSocialInfoViewController *viewController = [[XBSocialInfoViewController alloc] init];
            viewController.configDict = self.postListArray[indexPath.section];
            [self.navigationController pushViewController:viewController animated:YES];
        };
    }
    cell.zanHandler = ^(){
        zanPostCell = weakCell;
        [self.zanPostAPIManager loadData];
        if ([zanPostCell.zanButton isSelected])
        {
            zanPostCell.zanLabel.text = [NSString stringWithFormat:@"%ld", [zanPostCell.zanLabel.text integerValue]-1];
            [zanPostCell.zanButton setSelected:NO];
        }
        else
        {
            zanPostCell.zanLabel.text = [NSString stringWithFormat:@"%ld", [zanPostCell.zanLabel.text integerValue]+1];
            [zanPostCell.zanButton setSelected:YES];
        }
        NSMutableDictionary *postMDict = [[NSMutableDictionary alloc] initWithDictionary:[_postListArray objectAtIndex:indexPath.section]];
        [postMDict setValue:zanPostCell.zanLabel.text forKey:@"starCount"];
        [postMDict setValue:[NSNumber numberWithBool:[zanPostCell.zanButton isSelected]] forKey:@"isLiked"];
        [_postListArray replaceObjectAtIndex:indexPath.section withObject:[postMDict copy]];
    };
    cell.commentHandler = ^(){
        XBFindNightMeetDetailViewController *viewController = [[XBFindNightMeetDetailViewController alloc] init];
        viewController.configDict = _postListArray[indexPath.section];
        XBFindNightMeetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        viewController.postId = cell.postId;
        viewController.shouldShowKeyboard = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    };
    [cell configWithDict:self.postListArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //去掉headerView的默认颜色
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindNightMeetTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindNightMeetTableViewCell * cell) {
        [cell configWithDict:self.postListArray[indexPath.section]];
    }];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBFindNightMeetDetailViewController *viewController = [[XBFindNightMeetDetailViewController alloc] init];
    viewController.configDict = _postListArray[indexPath.section];
    XBFindNightMeetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    viewController.postId = cell.postId;
    viewController.shouldShowKeyboard = NO;
    viewController.indexPath = indexPath;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *params = @{};
    if (manager == self.postAPIManager)
    {
        params = @{
                   
                   };
    }
    else if (manager == self.zanPostAPIManager)
    {
        if ([zanPostCell.zanButton isSelected])
        {
            params = @{
                       
                     };
        }
        else
        {
            params = @{
                       
                      };
        }
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.postAPIManager)
    {
        if (self.postAPIManager.isLastPage)
        {
            //self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.postAPIManager.isFirstPage)
        {
            [self.postListArray removeAllObjects];
        }
        [self.postListArray addObjectsFromArray:[manager fetchDataWithReformer:self.postReformer]];
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self.tableView reloadData];
    [self notifyNoDataView];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.postAPIManager)
    {
        
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    [self.tableView reloadData];
    [self notifyNoDataView];
    
}


#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"卧谈会";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(10.0f, 0.0f, 22.0f, 22.0f);
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"find_nightmeet_writepost"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)notifyNoDataView
{
    if (self.postListArray.count > 0)
        [self clearNoDataView];
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

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBarButton
{
    XBFindNightMeetWritePostViewController *nightMeetWritePostViewController = [[XBFindNightMeetWritePostViewController alloc] init];
    [self.navigationController pushViewController:nightMeetWritePostViewController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)reloadCellNotificationAction:(NSNotification *)notify
{
    NSIndexPath *indexPath = notify.userInfo[@"indexPath"];
    [_postListArray replaceObjectAtIndex:indexPath.section withObject:notify.userInfo[@"configDict"]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTableViewNotificationAtion
{
    [self.postAPIManager loadFirstPage];
}

#pragma mark - getter and setter
- (XBFindNightMeetPostAPIManager *)postAPIManager
{
    if (_postAPIManager == nil)
    {
        _postAPIManager = [[XBFindNightMeetPostAPIManager alloc] init];
        _postAPIManager.delegate = self;
        _postAPIManager.paramSource = self;
    }
    return _postAPIManager;
}

- (XBFindNightMeetZanPostAPIManager *)zanPostAPIManager
{
    if (_zanPostAPIManager == nil)
    {
        _zanPostAPIManager = [[XBFindNightMeetZanPostAPIManager alloc] init];
        _zanPostAPIManager.delegate = self;
        _zanPostAPIManager.paramSource = self;
    }
    return _zanPostAPIManager;
}

- (XBFindNightMeetPostReformer *)postReformer
{
    if (_postReformer == nil)
    {
        _postReformer = [[XBFindNightMeetPostReformer alloc] init];
    }
    return _postReformer;
}

- (NSMutableArray *)postListArray
{
    if (!_postListArray)
    {
        _postListArray = [[NSMutableArray alloc] init];
    }
    return _postListArray;
}

@end
