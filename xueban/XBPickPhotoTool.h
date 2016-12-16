//
//  XBPickPhotoTool.h
//  xueban
//
//  Created by dang on 16/8/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XBPickPhotoType) {
    XBPickPhotoTypeAvatar,
    XBPickPhotoTypeBackground
};

typedef void(^myblock)(UIImage * Data);

@interface XBPickPhotoTool : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWithType:(XBPickPhotoType) type;

/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片image
 */
- (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;

/**
 *  相册选择器
 */
@property (nonatomic,strong) UIImagePickerController *pickerController;

@property (nonatomic,strong) myblock  myblock;

/**
 *  打开相机：
 *
 *  @param object 控制器对象
 */
- (void)showCameraWithController: (UIViewController *)controller
                       andWithBlock: (myblock)block;

/**
 *  选择相册
 *
 *  @param Controller 控制器对象
 */

- (void)showPhotoLibraryWithController: (UIViewController *)controller
                        andWithBlock: (myblock)block;

@end
