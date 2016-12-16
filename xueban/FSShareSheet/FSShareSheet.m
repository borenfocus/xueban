//
//  FSShareSheet.m
//  FSActionSheet
//
//  Created by lifution on 15/10/19.
//  Copyright © 2015年 lifution. All rights reserved.
//

#import "FSShareSheet.h"
#import "FSShareCell.h"
#import "FSShareModel.h"

#define kFSShareSheetTitleH 30
#define kFSShareSheetBtnH   44

#define kFSShareSheetHeight (kFSShareCellHeight*2+kFSShareSheetBtnH)

@interface FSShareSheet() <UITableViewDelegate, UITableViewDataSource, FSShareCellDelegate>
{
@private
    NSString *_title;
    NSString *_cancelTitle;
    UIView   *_backgroundView;
}

@property (nonatomic, retain) UITableView *tableView;

@end

NSString * const kFSShareTableCellIdentifier = @"kFSShareTableCellIdentifier";

@implementation FSShareSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<FSShareSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    if (!(self = super.init)) return nil;
    
    self.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    
    if (title && title.length > 0) _title = title; else _title = @"分享";
    if (delegate) self.delegate = delegate;
    if (cancelButtonTitle && cancelButtonTitle.length > 0) _cancelTitle = cancelButtonTitle; else _cancelTitle = @"取消";
    
    [self addSubview:self.tableView];
    
    return self;
}

// resetTableView.frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

#pragma mark -- getter

- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    
    // 初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    // 代理 && 数据源
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    // 透明背景
    _tableView.backgroundColor = [UIColor clearColor];
    // 禁止滑动
    _tableView.scrollEnabled = NO;
    // 注册缓存
    [_tableView registerClass:[FSShareCell class] forCellReuseIdentifier:kFSShareTableCellIdentifier];
    // header
    //_tableView.tableHeaderView = [self headerView];
    // footerView
    _tableView.tableFooterView = [self footerView];
    return _tableView;
}

// headerView
- (UILabel *)headerView
{
    UILabel *headerLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, kFSShareSheetTitleH)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment   = NSTextAlignmentCenter;
    headerLabel.font            = [UIFont systemFontOfSize:14.f];
    headerLabel.text            = _title;
    return headerLabel;
}
// footerView
- (UIButton *)footerView
{
    UIButton *cancelBtn       = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kFSShareSheetBtnH)];
    cancelBtn.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    return cancelBtn;
}

#pragma mark -- public
// 弹出
- (void)show
{
    UIWindow *window      = [UIApplication sharedApplication].keyWindow;
    _backgroundView       = [[UIView alloc] initWithFrame:window.bounds];
    _backgroundView.alpha = 0;
    _backgroundView.backgroundColor        = [UIColor blackColor];
    _backgroundView.userInteractionEnabled = YES;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [window addSubview:_backgroundView];
    
    self.frame = CGRectMake(0, window.bounds.size.height, window.bounds.size.width, kFSShareSheetHeight);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.5;
        self.frame = CGRectMake(0, window.bounds.size.height-kFSShareSheetHeight, window.bounds.size.width, kFSShareSheetHeight);
    }];
}

#pragma mark -- private
// 隐藏
- (void)hide
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect newRect   = self.frame;
    newRect.origin.y = window.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        self.frame = newRect;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        [self removeFromSuperview];
    }];
}


#pragma mark -- delegate

#pragma mark -- UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFSShareCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSShareCell *cell = (FSShareCell *)[tableView dequeueReusableCellWithIdentifier:kFSShareTableCellIdentifier];
    
    NSArray *models;
    if (indexPath.row == 0) {
        FSShareModel *model1 = FSShareModel.new;
        FSShareModel *model2 = FSShareModel.new;
        FSShareModel *model3 = FSShareModel.new;
        FSShareModel *model4 = FSShareModel.new;
        
        model1.imgName   = @"box_center_more_qq";
        model1.title     = @"QQ";
        model1.tagNumber = 1;
        model2.imgName   = @"box_center_more_qzone";
        model2.title     = @"QQ空间";
        model2.tagNumber = 2;
        model3.imgName   = @"box_center_more_wechat";
        model3.title     = @"微信";
        model3.tagNumber = 3;
        model4.imgName   = @"box_center_more_circlefriend";
        model4.title     = @"朋友圈";
        model4.tagNumber = 4;
        models = @[model1, model2, model3, model4];
    } else {
        FSShareModel *model1 = FSShareModel.new;
        FSShareModel *model2 = FSShareModel.new;
        FSShareModel *model3 = FSShareModel.new;
        FSShareModel *model4 = FSShareModel.new;
        model1.imgName   = @"box_center_more_pasteboard";
        model1.title     = @"复制链接";
        model1.tagNumber = 5;
        model2.imgName   = @"box_center_more_about";
        model2.title     = @"关于";
        model2.tagNumber = 6;
        model3.imgName   = @"box_center_more_collection";
        model3.title     = @"收藏";
        model3.tagNumber = 7;
        model4.imgName   = @"box_center_more_file";
        model4.title     = @"文件夹";
        model4.tagNumber = 8;
        models = @[model1, model2, model3, model4];
    }
    
    cell.models   = models;
    cell.delegate = self;
    return cell;
}

// 点击回调
- (void)selectedButton:(UIButton *)button tag:(NSInteger)tagNumber
{
    __weak __typeof(&*self)weakSelf = self;
    [self hide];
    if ([weakSelf.delegate respondsToSelector:@selector(shareSheet:clickedButtonAtIndex:)]) {
        [weakSelf.delegate shareSheet:weakSelf clickedButtonAtIndex:tagNumber];
    }
}

@end
