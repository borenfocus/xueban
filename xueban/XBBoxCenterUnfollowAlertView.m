//
//  XBBoxCenterUnfollowAlertView.m
//  xueban
//
//  Created by dang on 16/8/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterUnfollowAlertView.h"
#import <QuartzCore/QuartzCore.h>
@interface XBBoxCenterUnfollowAlertView ()
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, strong) UILabel *importLabel;
@property (nonatomic, strong) UIImageView *importCurImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation XBBoxCenterUnfollowAlertView

- (id)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    self.dialogView = [self createContainerView];
    
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:self.dialogView];
    
    // Attached to the top most window
    CGSize dialogSize = [self countDialogSize];
    self.dialogView.frame = CGRectMake((SCREENWIDTH - dialogSize.width) / 2, (SCREENHEIGHT - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
    self.dialogView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    //两种动画效果
    
    //    dialogView.layer.opacity = 0.5f;
    //    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    //
    //    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn
    //					 animations:^{
    //						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    //                         dialogView.layer.opacity = 1.0f;
    //                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    //					 }
    //					 completion:NULL
    //     ];
    //self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    //    self.backgroundColor = [UIColor clearColor];
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
    [self.dialogView.layer addAnimation:popAnimation forKey:nil];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
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

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - dialogSize.width) / 2, (SCREENHEIGHT - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    CGFloat cornerRadius = 7;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    //dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    // Add the custom container if there is any
    [dialogContainer addSubview:self.containerView];
    
    return dialogContainer;
}


// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = self.containerView.frame.size.width;
    CGFloat dialogHeight = self.containerView.frame.size.height;
    return CGSizeMake(dialogWidth, dialogHeight);
}

#pragma mark - event response
- (void)clickCancelButton
{
    if (self.cancelHandler)
    {
        self.cancelHandler();
    }
}

- (void)clickConfirmButton
{
    if (self.confirmHandler)
    {
        self.confirmHandler();
    }
}

#pragma mark - getter and setter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-30-30, 320)];
        _containerView.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:self.importLabel];
        [_containerView addSubview:self.importCurImageView];
        [_containerView addSubview:self.tipLabel];
        [_containerView addSubview:self.cancelButton];
        [_containerView addSubview:self.confirmButton];
        [_importLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_containerView).offset(20.0f);
            make.centerX.equalTo(_containerView);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        [_importCurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_importLabel.mas_bottom).offset(20.0f);
            make.centerX.equalTo(_containerView);
            make.size.mas_equalTo(CGSizeMake(75.5, 62));
        }];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_importCurImageView.mas_bottom).offset(20.0f);
            make.centerX.equalTo(_containerView);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).offset(30.0f);
            make.centerX.equalTo(_containerView).offset(-(SCREENWIDTH-30-30)/4.0f);
        }];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cancelButton);
            make.centerX.equalTo(_containerView).offset((SCREENWIDTH-30-30)/4.0f);
        }];
    }
    return _containerView;
}

- (UILabel *)importLabel {
    if (!_importLabel) {
        _importLabel = [[UILabel alloc] init];
        _importLabel.text = @"取消关注此订阅号";
        _importLabel.font = [UIFont systemFontOfSize:20.0f];
        _importLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _importLabel;
}

- (UIImageView *)importCurImageView {
    if (!_importCurImageView) {
        _importCurImageView = [[UIImageView alloc] init];
        _importCurImageView.image = [UIImage imageNamed:@"erp_set_autoadd_hint"];
    }
    return _importCurImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 2;
        _tipLabel.textColor = [UIColor colorWithHexString:@"969696"];
        NSString *tipLabelText = @"取消关注此订阅号后\n将不再接收其推送的消息";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: tipLabelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing: 4];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipLabelText length])];
        _tipLabel.attributedText = attributedString;
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
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
        [_confirmButton setTitleColor:[UIColor colorWithHexString:BlueColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
