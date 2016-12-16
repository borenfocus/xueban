//
//  XBFindNightMeetTableViewCell.h
//  xueban
//
//  Created by dang on 16/8/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBZanButton.h"

@interface XBFindNightMeetTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) XBZanButton *zanButton;
@property (nonatomic, strong) UILabel     *zanLabel;
@property (nonatomic) NSInteger postId;

@property (nonatomic, copy) void (^avatarHandler)();
@property (nonatomic, copy) void (^zanHandler)();
@property (nonatomic, copy) void (^commentHandler)();

- (void)configWithDict:(NSDictionary *)dict;
@end
