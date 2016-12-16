//
//  XBFilePreviewController.h
//  xueban
//
//  Created by dang on 2016/11/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface XBFilePreviewController : QLPreviewController<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) NSString *filePath;

@end
