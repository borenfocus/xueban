//
//  FSShareCell.m
//  FSActionSheet
//
//  Created by lifution on 15/10/19.
//  Copyright © 2015年 lifution. All rights reserved.
//

#import "FSShareCell.h"
#import "FSShareItem.h"
#import "FSShareModel.h"

#define kFSShareCellBaseTag 59999

@implementation FSShareCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.backgroundColor             = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.scrollView = UIScrollView.new;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    [self.contentView addSubview:self.scrollView];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.scrollView) self.scrollView.frame = self.contentView.bounds;
}

- (void)setModels:(NSArray *)models
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    FSShareItem *tempItem;
    
    for (int i = 0; i < models.count; i ++) {
        FSShareModel *model = (FSShareModel *)models[i];
        FSShareItem *item   = FSShareItem.new;
        item.imgName        = model.imgName;
        item.title          = model.title;
        item.button.tag     = model.tagNumber+kFSShareCellBaseTag;
        item.button.exclusiveTouch = YES;
        [item.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:item];
        
        item.frame = CGRectMake(tempItem?CGRectGetMaxX(tempItem.frame)+15:15, 20, 60, kFSShareCellHeight-20);
        tempItem   = item;
        
        if (i == models.count-1) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(tempItem.frame)+15, CGRectGetHeight(tempItem.frame));
        }
    }
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger btnTag = button.tag-kFSShareCellBaseTag;
    if ([self.delegate respondsToSelector:@selector(selectedButton:tag:)]) {
        [self.delegate selectedButton:button tag:btnTag];
    }
}

@end
