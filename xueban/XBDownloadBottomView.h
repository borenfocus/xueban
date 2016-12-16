//
//  XBDownloadBottomView.h
//  xueban
//
//  Created by dang on 2016/11/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBDownloadBottomView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *progressButton;

@property (nonatomic, copy) void (^closeHandler)();
@property (nonatomic, copy) void (^progressHandler)();

@end
