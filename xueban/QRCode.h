//
//  QRCode.h
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCode : NSObject
/**
 *  生成二维码图片
 *
 *  @param QRString  二维码内容
 *  @param sizeWidth 图片size(正方形)
 *
 *  @return  二维码图片
 */
+ (UIImage *)createQRImageWithString:(NSString *)QRString size:(CGFloat)sizeWidth;

@end
