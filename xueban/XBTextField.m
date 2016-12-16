//
//  XBTextField.m
//  xueban
//
//  Created by dang on 16/8/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBTextField.h"

@implementation XBTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
