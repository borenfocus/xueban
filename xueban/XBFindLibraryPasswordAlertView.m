//
//  XBFindLibraryPasswordAlertView.m
//  xueban
//
//  Created by dang on 16/9/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibraryPasswordAlertView.h"

static CGFloat const kLibraryPasswordAlertViewHeight = 320.0f;

@interface XBFindLibraryPasswordAlertView ()

@property (nonatomic, retain) UIView   *dialogView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel  *alertLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation XBFindLibraryPasswordAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.dialogView];
        [self.dialogView addSubview:self.titleLabel];
        [self.dialogView addSubview:self.alertLabel];
        [self.dialogView addSubview:self.imageView];
        [self.dialogView addSubview:self.cancelButton];
        [self.dialogView addSubview:self.confirmButton];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dialogView).offset(30.0f);
            make.centerX.equalTo(_dialogView);
        }];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_dialogView);
            make.top.equalTo(_titleLabel.mas_bottom).offset(30.0f);
            make.size.mas_equalTo(CGSizeMake(55, 80));
        }];
        [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(15.0f);
            make.centerX.equalTo(_dialogView);
            make.left.offset(40.0f);
            make.right.offset(-40.0f);
        }];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_dialogView.mas_bottom).offset(-20.0f);
            make.centerX.equalTo(_dialogView).offset(-(SCREENWIDTH-30-30)/4.0f);
        }];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cancelButton);
            make.centerX.equalTo(_dialogView).offset((SCREENWIDTH-30-30)/4.0f);
        }];
    }
    return self;
}

- (void)show {
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
}

- (void)doNothing {
    
}

- (void)close {
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self.dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}


#pragma mark - event response
- (void)clickCancelButton {
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (void)clickConfirmButton {
    if (self.confirmHandler) {
        self.confirmHandler();
    }
}

#pragma mark - getter and setter
- (UIView *)dialogView {
    if (!_dialogView) {
        _dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-35-35, kLibraryPasswordAlertViewHeight)];
        //_dialogView.userInteractionEnabled = NO;
        _dialogView.center = self.center;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _dialogView.bounds;
        CGFloat cornerRadius = 7;
        gradient.cornerRadius = cornerRadius;
        [_dialogView.layer insertSublayer:gradient atIndex:0];
        _dialogView.layer.cornerRadius = cornerRadius;
        _dialogView.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
        _dialogView.layer.borderWidth = 1;
        _dialogView.layer.shadowRadius = cornerRadius + 5;
        _dialogView.layer.shadowOpacity = 0.1f;
        _dialogView.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
        //dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _dialogView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.dialogView.bounds cornerRadius:self.dialogView.layer.cornerRadius].CGPath;
        
        _dialogView.clipsToBounds = YES;
        _dialogView.layer.shouldRasterize = YES;
        _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _dialogView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_dialogView.layer addAnimation:popAnimation forKey:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
        [_dialogView addGestureRecognizer:tap];
    }
    return _dialogView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"图书馆密码未提供或错误";
        _titleLabel.font = [UIFont systemFontOfSize:19.0f];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"find_library_password_alert"];
    }
    return _imageView;
}

- (UILabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"只有输入图书馆密码才能正常使用图书馆功能，请问您要输入密码么？";
        _alertLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _alertLabel.numberOfLines = 0;
        _alertLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _alertLabel;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHexString:BlueColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
