//
//  XBSetLibraryPasswordContainerView.h
//  xueban
//
//  Created by dang on 16/9/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBSetLibraryPasswordContainerView : UIView

@property (nonatomic, copy) void (^confirmHandler)(NSString *libPassword);

@end
