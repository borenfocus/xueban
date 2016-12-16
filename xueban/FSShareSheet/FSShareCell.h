//
//  FSShareCell.h
//  FSActionSheet
//
//  Created by lifution on 15/10/19.
//  Copyright © 2015年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFSShareCellHeight  115

@protocol FSShareCellDelegate <NSObject>

@optional
- (void)selectedButton:(UIButton *)button tag:(NSInteger)tagNumber;

@end

@interface FSShareCell : UITableViewCell

@property (nonatomic, assign) id<FSShareCellDelegate> delegate;
@property (nonatomic, copy)   NSArray *models;

@property (nonatomic, retain) UIScrollView *scrollView;

@end
