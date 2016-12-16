//
//  NSString+Extension.h
//  xueban
//
//  Created by dang on 16/9/14.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  日期字符串格式化函数 2016-01-01T02:16:53.602Z
 *
 *  @return 01-01 02:16
 */
- (NSString *)reformDateStringWithDateFormat:(NSString *)dateFormat;

//TODO: 删除这个方法
- (CGFloat)getHeightWithFontSize:(CGFloat)size Width:(CGFloat)width;

//只有聊天列表使用这个
- (NSString *)changeTheDateString;

- (NSString *)changeDateString;

//type: 0缩略 1详细
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate dateType:(NSNumber *)type;
@end
