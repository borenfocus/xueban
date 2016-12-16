//
//  XBFindNightMeetDetailViewController.m
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetDetailViewController.h"
#import "XBSocialInfoViewController.h"
#import "XBFindNightMeetTableViewCellDataKey.h"
#import "XBFindNightMeetDetailTableViewCellDataKey.h"
#import "XBFindNightMeetTableViewCell.h"
#import "XBFindNightMeetDetailTableViewCell.h"
#import "XBFindChatCommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XBFindNightMeetZanPostAPIManager.h"
#import "XBFindNightMeetPostDetailAPIManager.h"
#import "XBFindNightMeetCommentPostAPIManager.h"
#import "XBFindNightMeetPostDetailReformer.h"
#import "XBInputToolBar.h"
#import <IQKeyboardManager.h>
#import "XBPersonInfoDataCenter.h"
#import "XBRefreshHeader.h"

extern NSString *const kNightMeetDidChangePostNotification;

@interface XBFindNightMeetDetailViewController ()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CGFloat keyboardHeight;
    XBFindNightMeetTableViewCell *zanPostCell;
}
@property (nonatomic, strong) XBFindNightMeetPostDetailAPIManager *postDetailAPIManager;
@property (nonatomic, strong) XBFindNightMeetZanPostAPIManager *zanPostAPIManager;
@property (nonatomic, strong) XBFindNightMeetCommentPostAPIManager *commentPostAPIManager;
@property (nonatomic, strong) XBFindNightMeetPostDetailReformer *postDetailReformer;
@property (nonatomic, strong) XBInputToolBar *inputToolBar;
@property (nonatomic, strong) NSMutableArray *commentListArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NetworkLoadType loadType;

@end

@implementation XBFindNightMeetDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputToolBar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
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
    
    [_inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset(0);
        make.height.mas_equalTo(XBInputToolBarHeight);
    }];
    [self.postDetailAPIManager loadData];
    
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
        [weakInputToolBar layoutIfNeeded];
    };
    
    _inputToolBar.sendHandler = ^(){
        NSDictionary *personInfo = [[XBPersonInfoDataCenter sharedInstance] loadUser];
        NSString *headImage = personInfo[@"head_img"];
        NSString *realName = personInfo[@"real_name"];
        [weakSelf.commentListArray insertObject:@{
                                                  @"head_img": headImage,
                                                  @"content": weakInputToolBar.inputView.text,
                                                  @"real_name": realName,
                                                  @"createdAt": @"刚刚"
                                                  } atIndex:1];
        if (weakSelf.commentListArray.count == 2) {
            weakSelf.loadType = NetworkLoadTypeGetData;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic]; 
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade];
        }
        //恢复到XBInputToolBarHeight的状态
        [weakInputToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.offset(0);
            make.height.mas_equalTo(XBInputToolBarHeight);
            make.bottom.offset(-keyboardHeight);
        }];
        [self.commentPostAPIManager loadData];
        self.inputToolBar.inputView.text = @"";
        [self.inputToolBar.inputView resignFirstResponder];
    };
#pragma clang diagnostic pop
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [MobClick beginLogPageView:@"卧谈会详情"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XBRefreshHeader *header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self.postDetailAPIManager loadData];
    }];
    self.tableView.mj_header = header;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"卧谈会详情"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.loadType == NetworkLoadTypeGetData && section == 1) {
        return self.commentListArray.count-1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XBFindNightMeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindNightMeetTableViewCell class])];
        [cell configWithDict:self.configDict];
        __weak typeof(cell) weakCell = cell;
        if ([self.configDict[kFindNightMeetTableViewCellDataKeyIsAnonymous] isEqual:@0]) {
            cell.avatarHandler = ^(){
                XBSocialInfoViewController *viewController = [[XBSocialInfoViewController alloc] init];
                viewController.configDict = self.configDict;
                [self.navigationController pushViewController:viewController animated:YES];
            };
        }
        cell.zanHandler = ^(){
            zanPostCell = weakCell;
            [self.zanPostAPIManager loadData];
            if ([zanPostCell.zanButton isSelected]) {
                zanPostCell.zanLabel.text = [NSString stringWithFormat:@"%ld", [zanPostCell.zanLabel.text integerValue]-1];
                [zanPostCell.zanButton setSelected:NO];
            } else {
                zanPostCell.zanLabel.text = [NSString stringWithFormat:@"%ld", [zanPostCell.zanLabel.text integerValue]+1];
                [zanPostCell.zanButton setSelected:YES];
            }
            NSMutableDictionary *postMDict = [[NSMutableDictionary alloc] initWithDictionary:self.configDict];
            [postMDict setValue:zanPostCell.zanLabel.text forKey:@"starCount"];
            [postMDict setValue:[NSNumber numberWithBool:[zanPostCell.zanButton isSelected]] forKey:@"isLiked"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNightMeetDidChangePostNotification object:nil userInfo:@{@"configDict": [postMDict copy], @"indexPath": self.indexPath}];
        };
        return cell;
    } else if (self.loadType == NetworkLoadTypeGetData) {
        XBFindNightMeetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBFindNightMeetDetailTableViewCell class])];
        [cell configWithDict:self.commentListArray[indexPath.row+1]];
        return cell;
    } else {
        XBFindChatCommentTableViewCell *cell = [[XBFindChatCommentTableViewCell alloc] init];
        if (self.loadType == NetworkLoadTypeGetNull) {
            [cell.activityView stopAnimating];
            cell.alertLabel.text = @"快来发表你的评论吧";
        } else if (self.loadType == NetworkLoadTypeGetFail) {
            [cell.activityView stopAnimating];
            cell.alertLabel.text = @"网络连接出错了";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    //去掉headerView的默认颜色
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindNightMeetTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindNightMeetTableViewCell * cell) {
            [cell configWithDict:self.configDict];
        }];
        return height;
    } else if (self.loadType == NetworkLoadTypeGetData) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([XBFindNightMeetDetailTableViewCell class]) cacheByIndexPath:indexPath configuration:^(XBFindNightMeetDetailTableViewCell * cell) {
            [cell configWithDict:self.commentListArray[indexPath.row+1]];
        }];
        return height;
    } else {
        return 130;
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.postDetailAPIManager) {
        params = @{
                   
                   };
    } else if (manager == self.commentPostAPIManager) {
        params = @{
                   
                   };
    } else if (manager == self.zanPostAPIManager) {
        if ([zanPostCell.zanButton isSelected]) {
            params = @{
                       
                       };
        } else {
            params = @{
                       
                       };
        }
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.postDetailAPIManager) {
        self.commentListArray = [[NSMutableArray alloc] initWithArray:[manager fetchDataWithReformer:self.postDetailReformer]];
        if ([self.commentListArray count] > 1) {
            self.loadType = NetworkLoadTypeGetData;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            self.loadType = NetworkLoadTypeGetNull;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else if (manager == self.commentPostAPIManager) {
        
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.postDetailAPIManager) {
        self.loadType = NetworkLoadTypeGetFail;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (manager == self.commentPostAPIManager) {
        
    }
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"帖子详情";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardHeight = 0;
    
    // 修改为以前的约束
    [_inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-XBInputToolBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XBFindNightMeetTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindNightMeetTableViewCell class])];
        [_tableView registerClass:[XBFindNightMeetDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBFindNightMeetDetailTableViewCell class])];
    }
    return _tableView;
}

- (XBFindNightMeetPostDetailAPIManager *)postDetailAPIManager {
    if (_postDetailAPIManager == nil) {
        _postDetailAPIManager = [[XBFindNightMeetPostDetailAPIManager alloc] init];
        _postDetailAPIManager.delegate = self;
        _postDetailAPIManager.paramSource = self;
    }
    return _postDetailAPIManager;
}

- (XBFindNightMeetCommentPostAPIManager *)commentPostAPIManager {
    if (_commentPostAPIManager == nil) {
        _commentPostAPIManager = [[XBFindNightMeetCommentPostAPIManager alloc] init];
        _commentPostAPIManager.delegate = self;
        _commentPostAPIManager.paramSource = self;
    }
    return _commentPostAPIManager;
}

- (XBFindNightMeetZanPostAPIManager *)zanPostAPIManager {
    if (_zanPostAPIManager == nil) {
        _zanPostAPIManager = [[XBFindNightMeetZanPostAPIManager alloc] init];
        _zanPostAPIManager.delegate = self;
        _zanPostAPIManager.paramSource = self;
    }
    return _zanPostAPIManager;
}

- (XBFindNightMeetPostDetailReformer *)postDetailReformer {
    if (_postDetailReformer == nil) {
        _postDetailReformer = [[XBFindNightMeetPostDetailReformer alloc] init];
    }
    return _postDetailReformer;
}

- (XBInputToolBar *)inputToolBar {
    if (!_inputToolBar) {
        _inputToolBar = [[XBInputToolBar alloc] init];
        _inputToolBar.inputView.placeholder = @"请输入评论内容";
        _inputToolBar.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _inputToolBar;
}

@end
