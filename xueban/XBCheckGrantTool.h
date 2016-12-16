//
//  XBCheckGrantTool.h
//  xueban
//
//  Created by dang on 16/8/4.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBCheckGrantTool : NSObject
+ (BOOL)isCameraDenied;
+ (BOOL)isCameraNotDetermined;

+ (BOOL)isPhotoLibraryDenied;
+ (BOOL)isPhotoLibraryNotDetermined;
@end
