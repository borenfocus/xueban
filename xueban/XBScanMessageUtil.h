//
//  XBScanMessageUtil.h
//  xueban
//
//  Created by dang on 2016/11/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XBScanMessageType) {
    XBScanMessageTypeSubscribe,
    XBScanMessageTypePerson,
    XBScanMessageTypeWeb,
    XBScanMessageTypeClass,
    XBScanMessageTypeOthers
};

@interface XBScanMessageUtil : NSObject

+ (XBScanMessageType)getType:(NSString *)message;

@end
