//
//  CenterTableView.h
//  BanTang
//
//  Created by liaoyp on 15/4/13.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollCell.h"
#import "HorizontalScrollCellDeleagte.h"
@class HorizonScrollTableView;
@protocol HorizontalTableViewDelegate <NSObject>

- (void)horizontalTableView:(HorizonScrollTableView *)tableView didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath;

@end

@interface HorizonScrollTableView : UIView<UITableViewDataSource,UITableViewDelegate,HorizontalScrollCellDeleagte>
{

}
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) id<HorizontalTableViewDelegate> delegate;

@end
