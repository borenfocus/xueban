//
//  XBSetLibraryPasswordContainerView.m
//  xueban
//
//  Created by dang on 16/9/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBSetLibraryPasswordContainerView.h"
#import "XBTextField.h"

@interface XBSetLibraryPasswordContainerView ()
{
    BOOL isExistTFText;
}
@property (nonatomic, strong) UIView      *textFieldBgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView      *sepView;
@property (nonatomic, strong) XBTextField *textField;

@property (nonatomic, strong) UIButton    *loginButton;
@end

@implementation XBSetLibraryPasswordContainerView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
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
- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if(textField == _textField)
    {
        if ([textField.text length] > 0)
        {
            isExistTFText = YES;
        }
        else
        {
            isExistTFText = NO;
        }
    }
    if (isExistTFText)
    {
        _loginButton.enabled = YES;
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"62c1e9"]];
    }
    else
    {
        _loginButton.enabled = NO;
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
    }
  }


- (void)clickConfirmButton
{
    if (self.confirmHandler)
    {
        self.confirmHandler(_textField.text);
    }
}


- (void)initView
{
    self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self addSubview:self.textFieldBgView];
    [self.textFieldBgView addSubview:self.imageView];
    [self.textFieldBgView addSubview:self.sepView];
    [self.textFieldBgView addSubview:self.textField];
    [self addSubview:self.loginButton];
    [_textFieldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(30.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10.0f);
        make.centerY.equalTo(_textFieldBgView);
        make.size.mas_equalTo(CGSizeMake(22.0f, 22.0f));
    }];
    [_sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.mas_equalTo(2.0f);
        make.left.mas_equalTo(40.0f);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(_sepView.mas_right).offset(15.0f);
        make.centerY.equalTo(_textFieldBgView);
        make.right.equalTo(_textFieldBgView.mas_right).offset(-5.0f);
    }];

    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(_firstBgView.mas_left);
        //        make.right.equalTo(_firstBgView.mas_right);
        //        make.height.equalTo(_firstBgView);
        //        make.top.equalTo(_thirdBgView.mas_bottom).offset(20.0f);
        
        make.left.equalTo(_textFieldBgView.mas_left);
        make.right.equalTo(_textFieldBgView.mas_right);
        make.height.equalTo(_textFieldBgView);
        make.top.equalTo(_textFieldBgView.mas_bottom).offset(20.0f);
    }];
}

#pragma mark - getter and setter

- (UIView *)textFieldBgView
{
    if (!_textFieldBgView)
    {
        _textFieldBgView = [[UIView alloc] init];
        _textFieldBgView.backgroundColor = [UIColor whiteColor];
        _textFieldBgView.clipsToBounds = YES;
    }
    return _textFieldBgView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"login_password"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIView *)sepView
{
    if (!_sepView)
    {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return  _sepView;
}

- (XBTextField *)textField
{
    if (!_textField)
    {
        _textField = [[XBTextField alloc] init];
        _textField.placeholder = @"请输入图书馆密码";
        _textField.font = [UIFont systemFontOfSize:15.0f];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.tintColor = [UIColor colorWithHexString:@"969696"];
    }
    return _textField;
}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [[UIButton alloc] init];
        _loginButton.enabled = NO;
        [_loginButton setTitle:@"确认" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
