//
//  XBPrivateContentViewController.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateContentViewController.h"

#import "XBPrivateListCellDataKey.h"
#import "XBPrivateContentCellDataKey.h"

#import "XBPrivateContentAPIManager.h"
#import "XBPrivateSendAPIManager.h"

#import "XBPrivateContentReformer.h"

#import "XBInputToolBar.h"
#import <IQKeyboardManager.h>
#import "XBPersonInfoDataCenter.h"
//temp
#import "NSString+Extension.h"

#import "MJRefresh.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

extern NSString *const kPrivateDidRecieveNotification;
extern NSString *const kChatDidEnterNotification;

@interface XBPrivateContentViewController ()<UITableViewDataSource, UITableViewDelegate, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    CGFloat keyboardHeight;
    BOOL isShow;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XBPrivateContentAPIManager *contentAPIManager;
@property (nonatomic, strong) XBPrivateSendAPIManager *sendAPIManager;
@property (nonatomic, strong) XBPrivateContentReformer *contentReformer;
@property (nonatomic, strong) NSMutableArray *contentListArray;
@property (nonatomic, strong) XBInputToolBar *inputToolBar;
@property (nonatomic) NSNumber *lastId;

@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic) NSNumber *shouldShowDate;
@property (nonatomic, copy) NSString *previousDate;

@end

@implementation XBPrivateContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self initNavigationItem];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateDidRecieveNotificationAction:) name:kPrivateDidRecieveNotification object:nil];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:mainQuene
                                                  usingBlock:^(NSNotification *note){
                                                      [self keyboardWillChangeFrameNotification:note];
                                                      [self.view addGestureRecognizer:tap];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:mainQuene
                                                  usingBlock:^(NSNotification *note){
                                                      [self keyboardWillHideNotification:note];
                                                      [self.view removeGestureRecognizer:tap];
                                                  }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(SCREENHEIGHT-64-XBInputToolBarHeight);
        make.bottom.offset(-XBInputToolBarHeight);
    }];
    [self.view addSubview:self.inputToolBar];
    [_inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset(0);
        make.height.mas_equalTo(XBInputToolBarHeight);
    }];
    __weak typeof(self) weakSelf = self;
    __weak typeof(_inputToolBar) weakInputToolBar = _inputToolBar;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    _inputToolBar.inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个block，修改底部View的高度
        // 设置底部条的高度 = 文字高度 + textView距离上下间距高度（10 = 上（5）下（5）间距总和）
        [weakInputToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.offset(0);
            make.height.mas_equalTo(textHeight+10);
            make.bottom.offset(-keyboardHeight);
        }];
        [_inputToolBar layoutIfNeeded];
    };
    
    _inputToolBar.sendHandler = ^(){
        [weakSelf.sendAPIManager loadData];
        
        //需要先判断是否为空 ！ 再发送请求
        [weakSelf calculateDate];
        NSNumber *fromId = [[[XBPersonInfoDataCenter sharedInstance] loadUser] objectForKey:MyStudentId_Key];
        [weakSelf.contentListArray insertObject:@{
                                              @"fromId": fromId,
                                              @"toId": weakSelf.userId,
                                              @"content": weakSelf.inputToolBar.inputView.text,
                                              @"createdAt": weakSelf.createdAt,
                                              @"shouldShowDate": weakSelf.shouldShowDate,
                                              @"previousDate": weakSelf.previousDate
                                              } atIndex:weakSelf.contentListArray.count];
        weakInputToolBar.inputView.text = @"";
        //恢复到XBInputToolBarHeight的状态
        [weakInputToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.offset(0);
            make.height.mas_equalTo(XBInputToolBarHeight);
            make.bottom.offset(-keyboardHeight);
        }];
        [_inputToolBar layoutIfNeeded];
        [self.tableView reloadData];
        [self tableViewResetPosition];
    };
#pragma clang diagnostic pop
    [self.contentAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [MobClick beginLogPageView:@"聊天页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    if (self.contentListArray.count > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kChatDidEnterNotification object:nil userInfo:@{@"lastContent":@{
                                       @"fromId": [self.contentListArray lastObject][@"fromId"],
                                       @"toId": [self.contentListArray lastObject][@"toId"],
                                       @"content": [self.contentListArray lastObject][@"content"]
                                       }}];
        NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
        NSMutableArray *unreadListArray = [[NSMutableArray alloc] initWithArray:unreadArray];
        for (NSInteger i = 0; i < unreadListArray.count; i++)
        {
            NSDictionary *unreadDict = [unreadListArray objectAtIndex:i];
            if ([unreadDict[@"fromId"] isEqual: [self.contentListArray lastObject][@"fromId"]] || [unreadDict[@"fromId"] isEqual: [self.contentListArray lastObject][@"toId"]] )
            {
                NSInteger unreadNum = [[unreadListArray objectAtIndex:i][@"unreadNum"] integerValue];
                
                [UIApplication sharedApplication].applicationIconBadgeNumber -= unreadNum;
                [unreadListArray removeObjectAtIndex:i];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:[unreadListArray copy] forKey:MyUnreadArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:3];
        if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
        {
            item.badgeValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
        }
        else
        {
            item.badgeValue = nil;
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MobClick endLogPageView:@"聊天页面"];
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

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UUMessageCell class])];
    cell.headImg = self.avatarUrl;
    [cell configWithDict:[self.contentListArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *shouldShowDate = [self.contentListArray objectAtIndex:indexPath.row][kPrivateContentCellDataKeyShowDate];
    
    CGFloat originY = 0;
    if ([shouldShowDate isEqualToNumber:@1])
    {
        originY = 30;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CGSize contentSize = [[self.contentListArray objectAtIndex:indexPath.row][kPrivateContentCellDataKeyContent] sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    return originY +ChatMargin + contentSize.height + ChatContentTop + ChatContentBottom + ChatMargin;
    
    
    //NSString *content = [self.contentListArray objectAtIndex:indexPath.row][kPrivateContentCellDataKeyContent];
    //return [content getHeightWithFontSize:16 Width:SCREENWIDTH - 132] + 80;
//    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([UUMessageCell class]) cacheByIndexPath:indexPath configuration:^(UUMessageCell * cell) {
//        [cell configWithDict:[self.contentListArray objectAtIndex:indexPath.row]];
//    }];
//    return height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    //把它抽象出来
    self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-XBInputToolBarHeight);
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *params = @{};
    if (manager == self.contentAPIManager)
    {
        params = @{
                   
                   };
    }
    else if (manager == self.sendAPIManager)
    {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [self.tableView.mj_header endRefreshing];
    //[self.xbRefreshControl endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    if (manager == self.contentAPIManager)
    {
        if ([self.lastId isEqual:@0])
        {
            //下拉刷新
            self.contentListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.contentReformer]];
            
            [self.tableView reloadData];
            [self tableViewScrollToBottom];
        }
        else
        {
            NSArray *newContentArray = [manager fetchDataWithReformer:self.contentReformer];
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[newContentArray count])];
            [self.contentListArray insertObjects:newContentArray atIndexes:indexes];
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newContentArray.count inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

        }
        self.lastId = [self.contentListArray firstObject][kPrivateContentCellDataKeyId];
    }
    else if (manager == self.sendAPIManager)
    {
        //TODO:无网络情况
        
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [self.tableView.mj_header endRefreshing];
    [XBProgressHUD hideHUDForView:self.tableView];
    if (manager == self.contentAPIManager)
    {
    
    }
    else if (manager == self.sendAPIManager)
    {
        
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)privateDidRecieveNotificationAction:(NSNotification *)notify
{
    [self calculateDate];
    NSDictionary *messageDict = notify.userInfo[@"messageDict"];
    NSNumber *toId = [[[XBPersonInfoDataCenter sharedInstance] loadUser] objectForKey:MyStudentId_Key];
    [self.contentListArray insertObject:@{
                                          @"fromId": messageDict[@"fromId"],
                                          @"toId": toId,
                                          @"content": messageDict[@"content"],
                                          @"createdAt": self.createdAt,
                                          @"shouldShowDate": self.shouldShowDate,
                                          @"previousDate": self.previousDate
                                          } atIndex:self.contentListArray.count];
    [self.tableView reloadData];
    [self tableViewResetPosition];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    isShow = YES;
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight-XBInputToolBarHeight);
    }];
    [self tableViewResetPosition];
            //}

    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    isShow = NO;
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardHeight = 0;
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-XBInputToolBarHeight);
    }];
    [_inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    if (self.tableView.contentSize.height <= SCREENHEIGHT-64-XBInputToolBarHeight)
    {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
    [self.tableView setNeedsUpdateConstraints];
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        // 修改为以前的约束
//        [_inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(0);
//        }];
//        if (self.tableView.frame.origin.y != 0)
//        {
//            CGRect rect = self.tableView.frame;
//            rect.origin.y += keyboardHeight;
//            self.tableView.frame = rect;
//        }

        
        [self.view layoutIfNeeded];
    }];
}

- (void)tableViewScrollToBottom
{
    if (self.contentListArray.count == 0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.contentListArray count] - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)tableViewResetPosition
{
    if (self.tableView.contentSize.height <= SCREENHEIGHT-64-XBInputToolBarHeight-keyboardHeight)
    {
        self.tableView.contentOffset = CGPointMake(0, -keyboardHeight);
    }
    else if (self.tableView.contentSize.height <= SCREENHEIGHT-64-XBInputToolBarHeight)
    {
        self.tableView.contentOffset = CGPointMake(0, -(SCREENHEIGHT-64-XBInputToolBarHeight-self.tableView.contentSize.height));
    }
    else
    {
        [self tableViewScrollToBottom];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //[self.view endEditing:YES];
    //self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-XBInputToolBarHeight);
}

#pragma mark - private method
- (void)initNavigationItem
{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    //    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBarButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    //    [rightBarButton setImage:[UIImage imageNamed:@"find_social_sex"] forState:UIControlStateNormal];
    //    [rightBarButton addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    //    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)calculateDate
{
    NSString *start = [self.contentListArray lastObject][@"previousDate"];
    NSDate *startDate = [NSDate dateFromString:start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    self.previousDate = [dateFormatter stringFromDate:nowDate];
    NSDate *endDate = [NSDate dateFromString:self.previousDate withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    self.createdAt = [NSString formateDate:self.previousDate withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@1];
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.shouldShowDate = @1;
    }else{
        self.shouldShowDate = @0;
    }
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView)
    {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-XBInputToolBarHeight-64) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        //temp
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *identifier = @"WhiteMessageTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"WhiteMessageTableViewCell" bundle:bundle];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        
        identifier = @"BlueMessageTableViewCell";
        nib = [UINib nibWithNibName:@"BlueMessageTableViewCell" bundle:bundle];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        
        
        [_tableView registerClass:[UUMessageCell class] forCellReuseIdentifier:NSStringFromClass([UUMessageCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.contentAPIManager loadData];
        }];
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        // 马上进入刷新状态
        //[header beginRefreshing];
        
        // 设置header
        _tableView.mj_header = header;

    }
    return _tableView;
}

- (XBPrivateContentAPIManager *)contentAPIManager
{
    if (!_contentAPIManager)
    {
        _contentAPIManager = [[XBPrivateContentAPIManager alloc] init];
        _contentAPIManager.paramSource = self;
        _contentAPIManager.delegate = self;
    }
    return _contentAPIManager;
}

- (XBPrivateSendAPIManager *)sendAPIManager
{
    if (!_sendAPIManager)
    {
        _sendAPIManager = [[XBPrivateSendAPIManager alloc] init];
        _sendAPIManager.paramSource = self;
        _sendAPIManager.delegate = self;
    }
    return _sendAPIManager;
}

- (XBPrivateContentReformer *)contentReformer
{
    if (!_contentReformer)
    {
        _contentReformer = [[XBPrivateContentReformer alloc] init];
    }
    return _contentReformer;
}

- (XBInputToolBar *)inputToolBar
{
    if (!_inputToolBar)
    {
        _inputToolBar = [[XBInputToolBar alloc] init];
        _inputToolBar.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _inputToolBar;
}

- (NSNumber *)lastId
{
    if (!_lastId)
    {
        _lastId = @0;
    }
    return _lastId;
}

- (NSNumber *)shouldShowDate
{
    if (!_shouldShowDate)
    {
        _shouldShowDate = @1;
    }
    return _shouldShowDate;
}

- (NSMutableArray *)contentListArray
{
    if (_contentListArray == nil)
    {
        _contentListArray = [[NSMutableArray alloc] init];
    }
    return _contentListArray;
};
@end
