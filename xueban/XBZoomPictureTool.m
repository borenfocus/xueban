//
//  XBZoomPictureTool.m
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBZoomPictureTool.h"
#import "XBCheckGrantTool.h"
#import "XBSettingGranteView.h"
@import Photos;

static CGRect oldframe;
static UIImage *savaImage;

@implementation XBZoomPictureTool

+ (id)sharedInstance
{
    static XBZoomPictureTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[XBZoomPictureTool alloc] init];
    });
    return tool;
}

- (void)showImage:(UIImageView *)avatarImageView {
    UIImage *image = avatarImageView.image;
    savaImage = image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 100;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    UITapGestureRecognizer *savePhoneTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savePhotoToAblum:)];
    UIImageView *savePhoneView = [[UIImageView alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 50, 30, 30)];
    savePhoneView.userInteractionEnabled = YES;
    savePhoneView.image = [UIImage imageNamed:@"save_image"];
    [savePhoneView addGestureRecognizer:savePhoneTap];
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:savePhoneView];
    [window addSubview:backgroundView];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:100];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//保存图片到相册
- (void)savePhotoToAblum:(UITapGestureRecognizer *)tap {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 第一次安装App，还未确定权限，调用这里
        if ([XBCheckGrantTool isPhotoLibraryNotDetermined]) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBGrantAlertView *grantAlertView = [[XBGrantAlertView alloc] initWithFrame:window.frame];
            grantAlertView.delegate = self;
            grantAlertView.alertViewType = XBGrantAlertViewTypePhotoLibrary;
            [window addSubview:grantAlertView];
            [UIView animateWithDuration:0.2f animations:^{
                grantAlertView.alpha = 1.0f;
            }];
        } else if ([XBCheckGrantTool isPhotoLibraryDenied]) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBSettingGranteView *settingGranteView = [[XBSettingGranteView alloc] initWithFrame:window.frame];
            settingGranteView.settingType = XBSettingGranteViewTypePhotoLibrary;
            [window addSubview:settingGranteView];
            [UIView animateWithDuration:0.2f animations:^{
                settingGranteView.alpha = 1.0f;
            }];
        } else {
            // 已经授权
            UIImageWriteToSavedPhotosAlbum(savaImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
    } else {
        // 当前设备不支持打开相册
        NSLog(@"当前设备不支持相册");
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"";
    if (!error) {
        message = @"图片已成功保存到相册";
        kShowHUD(message, nil);
    } else {
        message = [error description];
    }
}

#pragma mark - XBCameraGranteViewDelegate
- (void)didClickGranteConfirmButton:(XBGrantAlertViewType)type {
    if (type == XBGrantAlertViewTypePhotoLibrary) {
        // 系统弹出授权对话框
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    // 用户拒绝，跳转到自定义提示页面
                    //   DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                    //  [self presentViewController:vc animated:YES completion:nil];
                } else if (status == PHAuthorizationStatusAuthorized) {
                    // 用户授权
                    UIImageWriteToSavedPhotosAlbum(savaImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                }
            });
        }];
    }
}

@end
