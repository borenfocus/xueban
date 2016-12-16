//
//  XBBoxBannerTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxBannerTableViewCell.h"
#import "CollectModel.h"
#import "XBBoxContentCellDataKey.h"

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define AFTER(time, block)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), block);

static CGFloat const BannerCellHeight = 130.0f;

@interface XBBoxBannerTableViewCell ()<UIScrollViewDelegate>
{
    NSInteger itemNum;
    NSMutableArray *_dataSource;
    NSMutableArray *itemArray;
}
@end

@implementation XBBoxBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpHorizontalScrollView];
    }
    return self;
}

- (void)configWithArray:(NSMutableArray *)array {
    itemArray = array;
    self.horizonTableView.dataSource = [self loadData];
}

- (NSMutableArray *)loadData {
    NSMutableArray *horizonItemArray = [[NSMutableArray alloc] init];
    [itemArray enumerateObjectsUsingBlock:^(NSDictionary *itemDict, NSUInteger idx, BOOL *stop) {
        CollectModel *item = [[CollectModel alloc] init];
        item.title = itemDict[kBoxContentCellDataKeyTitle];
        item.imageUrl = itemDict[kBoxContentCellDataKeyImageUrl];
        [horizonItemArray addObject:item];
    }];
    return horizonItemArray;
}
- (void)setUpHorizontalScrollView {
    _horizonTableView = [[HorizonScrollTableView alloc] initWithFrame: CGRectMake(0, 0, SCREENWIDTH, BannerCellHeight)];
    [self.contentView addSubview:_horizonTableView];
}

@end
