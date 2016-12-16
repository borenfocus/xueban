//
//  XBLoginContainerView.m
//  xueban
//
//  Created by dang on 16/8/5.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBLoginContainerView.h"

@interface XBLoginContainerView ()<UITextFieldDelegate>
{
    BOOL isExistUsername;
    BOOL isExistPassword;
}
@property (nonatomic, strong) UIButton    *closeButton;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UIView      *usernameBgView;
@property (nonatomic, strong) UIImageView *usernameImageView;
@property (nonatomic, strong) UIView      *usernameSepView;

@property (nonatomic, strong) UIView      *passwordBgView;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UIView      *passwordSepView;
@property (nonatomic, strong) XBTextField *passwordTextField;

@property (nonatomic, strong) UIButton    *loginButton;

@end

@implementation XBLoginContainerView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event response
- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField == _usernameTextField) {
        if ([textField.text length] > 0) {
            isExistUsername = YES;
        } else {
            isExistUsername = NO;
        }
    }
    if (textField == _passwordTextField) {
        if ([textField.text length] > 0) {
            isExistPassword = YES;
        } else {
            isExistPassword = NO;
        }
    }
    if (isExistUsername && isExistPassword) {
        _loginButton.enabled = YES;
         [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"62c1e9"]];
    } else {
        _loginButton.enabled = NO;
         [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
    }
}

- (void)clickCloseButton {
    if (self.closeHandler) {
        self.closeHandler();
    }
}

- (void)clickLoginButton {
    if (self.loginHandler) {
        self.loginHandler(_usernameTextField.text, _passwordTextField.text);
    }
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self addSubview:self.closeButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.logoImageView];
    [self addSubview:self.usernameBgView];
    [self.usernameBgView addSubview:self.usernameImageView];
    [self.usernameBgView addSubview:self.usernameSepView];
    [self.usernameBgView addSubview:self.usernameTextField];
    [self addSubview:self.passwordBgView];
    [self.passwordBgView addSubview:self.passwordImageView];
    [self.passwordBgView addSubview:self.passwordSepView];
    [self.passwordBgView addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.offset(30.0f);
        make.height.equalTo(_titleLabel);
        make.width.equalTo(_closeButton.mas_height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(30.0f);
        make.height.mas_equalTo(30.0f);
    }];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(60.0f);
        make.bottom.equalTo(_usernameBgView.mas_top).offset(-60.0f);
        make.width.mas_equalTo(_logoImageView.mas_height);
    }];
    [_usernameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40.0f);
        make.right.offset(-40.0f);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(40.0f);
    }];
    [_usernameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10.0f);
        make.centerY.equalTo(_usernameBgView);
        make.size.mas_equalTo(CGSizeMake(22.0f, 22.0f));
    }];
    [_usernameSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.mas_equalTo(2.0f);
        make.left.mas_equalTo(40.0f);
    }];
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(_usernameSepView.mas_right).offset(15.0f);
        make.centerY.equalTo(_usernameBgView);
        make.right.equalTo(_usernameBgView.mas_right).offset(-5.0f);
    }];
    
    [_passwordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_usernameBgView.mas_left);
        make.right.equalTo(_usernameBgView.mas_right);
        make.height.equalTo(_usernameBgView);
        make.top.equalTo(_usernameBgView.mas_bottom).offset(15.0f);
    }];
    [_passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10.0f);
        make.centerY.equalTo(_passwordBgView);
        make.size.equalTo(_usernameImageView);
    }];
    [_passwordSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.mas_equalTo(2.0f);
        make.left.mas_equalTo(40.0f);
    }];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(_passwordSepView.mas_right).offset(15.0f);
        make.centerY.equalTo(_passwordBgView);
        make.right.equalTo(_passwordBgView.mas_right).offset(-5.0f);
    }];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_usernameBgView.mas_left);
        make.right.equalTo(_usernameBgView.mas_right);
        make.height.equalTo(_usernameBgView);
        make.top.equalTo(_passwordBgView.mas_bottom).offset(20.0f);
    }];
}

#pragma mark - getter and setter
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        //没有登录的话隐藏closeButton
        //if (![[NSUserDefaults standardUserDefaults] boolForKey:IF_Login])
        //{
            _closeButton.hidden = YES;
        //}
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"登录";
        _titleLabel.font = [UIFont systemFontOfSize:20.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _logoImageView;
}

- (UIView *)usernameBgView {
    if (!_usernameBgView) {
        _usernameBgView = [[UIView alloc] init];
        _usernameBgView.backgroundColor = [UIColor whiteColor];
        _usernameBgView.layer.cornerRadius = 5.0f;
        _usernameBgView.clipsToBounds = YES;
    }
    return _usernameBgView;
}

- (UIImageView *)usernameImageView {
    if (!_usernameImageView) {
        _usernameImageView = [[UIImageView alloc] init];
        _usernameImageView.image = [UIImage imageNamed:@"login_account"];
        _usernameImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _usernameImageView;
}

- (UIView *)usernameSepView {
    if (!_usernameSepView) {
        _usernameSepView = [[UIView alloc] init];
        _usernameSepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return  _usernameSepView;
}

- (XBTextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[XBTextField alloc] init];
        _usernameTextField.placeholder = @"请输入学号";
        _usernameTextField.font = [UIFont systemFontOfSize:15.0f];
        _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameTextField.tintColor = [UIColor colorWithHexString:@"969696"];
        _usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _usernameTextField;
}

- (UIView *)passwordBgView {
    if (!_passwordBgView) {
        _passwordBgView = [[UIView alloc] init];
        _passwordBgView.backgroundColor = [UIColor whiteColor];
        _passwordBgView.layer.cornerRadius = 5.0f;
        _passwordBgView.clipsToBounds = YES;
    }
    return _passwordBgView;
}

- (UIImageView *)passwordImageView {
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc] init];
        _passwordImageView.image = [UIImage imageNamed:@"login_password"];
        _passwordImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _passwordImageView;
}

- (UIView *)passwordSepView {
    if (!_passwordSepView) {
        _passwordSepView = [[UIView alloc] init];
        _passwordSepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _passwordSepView;
}

- (XBTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[XBTextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.font = [UIFont systemFontOfSize:15.0f];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.tintColor = [UIColor colorWithHexString:@"969696"];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.enabled = NO;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.clipsToBounds = YES;
        [_loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
