//
//  XBZoomPictureTool.h
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBGrantAlertView.h"

//放大图片
@interface XBZoomPictureTool : UIView<XBGrantAlertViewDelegate>

- (void)showImage:(UIImageView*)avatarImageView;
+ (id)sharedInstance;
@end
