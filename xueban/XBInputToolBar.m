//
//  XBInputToolBar.m
//  xueban
//
//  Created by dang on 16/8/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBInputToolBar.h"

@interface XBInputToolBar ()
{
    CGFloat keyboardHeight;
}
@property (nonatomic ,strong) UIView *topLineView;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation XBInputToolBar

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.topLineView];
        [self addSubview:self.inputView];
        [self addSubview:self.sendButton];
        // 注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.mas_equalTo(1.0f);
        }];
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.centerY.equalTo(self);
            make.top.offset(5.0f);
            make.bottom.offset(-5.0f);
            make.left.offset(20.0f);
            make.right.equalTo(_sendButton.mas_left).offset(-15.0f);
        }];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15.0f);
            make.bottom.offset(-5.0f);
            make.size.mas_equalTo(CGSizeMake(40.0f, 25.0f));
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改为以前的约束（距下边距0）
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - event response
- (void)clickSendButton
{
    if (self.sendHandler && ![_inputView.text isEqualToString:@""])
    {
        self.sendHandler();
    }
}

#pragma mark - getter and setter
//- (UIView *)bottomView {
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc] init];
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, SCREENWIDTH, 1)];
//        lineView.backgroundColor = UIColorFromRGB(0xdddddd);
//        [_bottomView addSubview:lineView];
//    }
//    return _bottomView;
//}

- (void)test {
    
}

- (UIView *)topLineView
{
    if (!_topLineView)
    {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    }
    return _topLineView;
}

- (XBInputView *)inputView {
    if (!_inputView) {
        _inputView = [[XBInputView alloc] init];
        // 设置文本框最大行数
        _inputView.maxNumberOfLines = 4;
    }
    return _inputView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithHexString:BlueColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
