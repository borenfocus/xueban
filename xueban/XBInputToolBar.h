//
//  XBInputToolBar.h
//  xueban
//
//  Created by dang on 16/8/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBInputView.h"
@interface XBInputToolBar : UIView
@property (nonatomic, strong) XBInputView *inputView;
@property (nonatomic, copy) void (^sendHandler)();
//@property (nonatomic, strong) void(^yz_textHeightChangeBlock)(NSString *text,CGFloat textHeight, CGFloat );
@end
