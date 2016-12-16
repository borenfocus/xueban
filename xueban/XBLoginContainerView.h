//
//  XBLoginContainerView.h
//  xueban
//
//  Created by dang on 16/8/5.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTextField.h"

@interface XBLoginContainerView : UIView

//account是学号
//@property (nonatomic, copy) void (^loginHandler)(NSString *school, NSString *account, NSString *password);

@property (nonatomic, strong) XBTextField *usernameTextField;

@property (nonatomic, copy) void (^loginHandler)(NSString *account, NSString *password);
@property (nonatomic, copy) void (^closeHandler)();

@end
