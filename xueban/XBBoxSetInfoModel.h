//
//  XBBoxSetInfoModel.h
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBBoxSetInfoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic) XBBoxSetInfoType type;
@property (nonatomic) BOOL isNotify;

@end
