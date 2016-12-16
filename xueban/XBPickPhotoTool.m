//
//  XBPickPhotoTool.m
//  xueban
//
//  Created by dang on 16/8/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPickPhotoTool.h"
#import "XBGrantAlertView.h"
#import "XBSettingGranteView.h"
#import "XBCheckGrantTool.h"
#import "WFTailoringViewController.h"
@import Photos;

@interface XBPickPhotoTool ()<XBGrantAlertViewDelegate>
{
    UIViewController *controllerCopy;
    XBPickPhotoType typeCopy;
}
@end

@implementation XBPickPhotoTool
- (instancetype)initWithType:(XBPickPhotoType) type {
    if (self = [super init]) {
        _pickerController = [[UIImagePickerController alloc] init];
        typeCopy = type;
    }
    return self;
}

- (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize {
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (void)showCameraWithController:(UIViewController *)controller andWithBlock:(myblock)block {
    controllerCopy = controller;
    _myblock = block;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 应用第一次申请权限调用这里
        if ([XBCheckGrantTool isCameraNotDetermined]) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBGrantAlertView *grantAlertView = [[XBGrantAlertView alloc] initWithFrame:window.frame];
            grantAlertView.delegate = self;
            grantAlertView.alertViewType = XBGrantAlertViewTypeCamera;
            [window addSubview:grantAlertView];
            [UIView animateWithDuration:0.2f animations:^{
                grantAlertView.alpha = 1.0f;
            }];
        }
        // 用户已经拒绝访问摄像头
        else if ([XBCheckGrantTool isCameraDenied]) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBSettingGranteView *settingGranteView = [[XBSettingGranteView alloc] initWithFrame:window.frame];
            settingGranteView.settingType = XBSettingGranteViewTypeCamera;
            [window addSubview:settingGranteView];
            [UIView animateWithDuration:0.2f animations:^{
                settingGranteView.alpha = 1.0f;
            }];
        }
        // 用户允许访问摄像头
        else {
            [self openCamera];
        }
    } else {
        NSLog(@"当前设备不支持摄像头，比如模拟器");
    }
}

- (void)showPhotoLibraryWithController:(UIViewController *)controller andWithBlock:(myblock)block {
    controllerCopy = controller;
    _myblock = block;
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
            // 已经授权，跳转到相册页面
            [self openPhotoLibrary];
        }
    } else {
        // 当前设备不支持打开相册
        NSLog(@"当前设备不支持相册");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image;
        if (typeCopy == XBPickPhotoTypeAvatar) {
            image = info[UIImagePickerControllerEditedImage];
            if (_myblock) {
                _myblock(image);
                [_pickerController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            image = info[UIImagePickerControllerOriginalImage];
            WFTailoringViewController *tailoringVC = [[WFTailoringViewController alloc] init];
            tailoringVC.image = image;
            tailoringVC.tailoredImage = ^ (UIImage *image){
                if (_myblock)
                {
                    _myblock(image);
                }
            };
            picker.navigationBarHidden = YES;
            [picker pushViewController:tailoringVC animated:YES];
        }
    }
}

// 取消选择照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XBCameraGranteViewDelegate
- (void)didClickGranteConfirmButton:(XBGrantAlertViewType)type {
    if (type == XBGrantAlertViewTypeCamera) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户授权
                    [self openCamera];
                } else {
                    // 用户拒绝授权
                    // DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                    //[self presentViewController:vc animated:YES completion:nil];
                }
            });
        }];
    } else if (type == XBGrantAlertViewTypePhotoLibrary) {
        // 系统弹出授权对话框
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    // 用户拒绝，跳转到自定义提示页面
                    //   DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                    //  [self presentViewController:vc animated:YES completion:nil];
                } else if (status == PHAuthorizationStatusAuthorized) {
                    // 用户授权，弹出相册对话
                    [self openPhotoLibrary];
                }
            });
        }];
    }
}

- (void)openPhotoLibrary {
    _pickerController.navigationBar.tintColor = [UIColor blackColor];
    _pickerController.delegate = self;
    if (typeCopy == XBPickPhotoTypeAvatar) {
        _pickerController.allowsEditing = YES;
    } else {
        _pickerController.allowsEditing = NO;
    }
    _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _pickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [controllerCopy presentViewController:_pickerController animated:YES completion:nil];
}

- (void)openCamera {
    _pickerController.navigationBar.tintColor = [UIColor blackColor];
    _pickerController.delegate = self;
    if (typeCopy == XBPickPhotoTypeAvatar) {
        _pickerController.allowsEditing = YES;
    } else {
        _pickerController.allowsEditing = NO;
    }
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _pickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [controllerCopy presentViewController:_pickerController animated:YES completion:nil];
}

@end
