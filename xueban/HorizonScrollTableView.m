//
//  CenterTableView.m
//  BanTang
//
//  Created by liaoyp on 15/4/13.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import "HorizonScrollTableView.h"
#import "HorzonItemCell.h"
#import "CollectModel.h"
 NSString *const cellIdentifier = @"HorzonItemCell";

@interface HorizonScrollTableView()

@end

@implementation HorizonScrollTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpTableView];
    }
    return self;
}

- (void)setUpTableView
{
    CGRect rect  =self.bounds;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [_tableView registerClass:[HorizontalScrollCell class] forCellReuseIdentifier:cellIdentifier];
    [self addSubview:_tableView];
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
     _dataSource = dataSource;
    [_tableView removeFromSuperview];
    [self setUpTableView];
    
    if ([_dataSource count] == 0) {
//        CenterEmptyView *emptyView = [[CenterEmptyView alloc] initWithFrame:CGRectZero];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableFooterView = emptyView;
    }else
    {
        _tableView.tableFooterView = nil;
    }
}

#pragma mark -
#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 120;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalScrollCell *_centerCell;
    _centerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    _centerCell.delegate =self;
    _centerCell.tableViewIndexPath = indexPath;
    return _centerCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HorizontalScrollCell class]]) {
        
        [(HorizontalScrollCell *)cell reloadData];
    }
}

#pragma mark - ASOXScrollTableViewCellDelegate

- (NSInteger)horizontalCellContentsView:(UICollectionView *)horizontalCellContentsView numberOfItemsInTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    NSInteger count = _dataSource.count;
    return count +1;
}

- (UICollectionViewCell *)horizontalCellContentsView:(UICollectionView *)horizontalCellContentsView cellForItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    
    HorzonItemCell *cell;
    {
        cell = (HorzonItemCell *)[horizontalCellContentsView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:contentIndexPath];
    }
    if (contentIndexPath.row == _dataSource.count) {
        [cell isLastTypeCell];
    }else
    {
        if (_dataSource.count > 0) {
            if ((contentIndexPath.row) < _dataSource.count) {
                CollectModel *item = [_dataSource objectAtIndex:contentIndexPath.row];
                if (item) {
                    [cell isNormalCell:item];
                }
                [cell isNormalCell:item];

            }
        }
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  =[UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (CGFloat)tableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 120;
}

- (CGSize)horizontalCellContentsView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(70, 120);
    itemSize.width = 70;
    if (indexPath.row == 0 ||indexPath.row == 6) {
        return CGSizeMake(70, itemSize.height);
    }
    return itemSize;
}

- (void)horizontalCellContentsView:(UICollectionView *)horizontalCellContentsView didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath
{
    [horizontalCellContentsView deselectItemAtIndexPath:contentIndexPath animated:YES];     // 跳转界面
    if ([_delegate respondsToSelector:@selector(horizontalTableView:didSelectItemAtContentIndexPath:inTableViewIndexPath:)]) {
        [_delegate horizontalTableView:self didSelectItemAtContentIndexPath:contentIndexPath inTableViewIndexPath:tableViewIndexPath];
    }
}

@end
