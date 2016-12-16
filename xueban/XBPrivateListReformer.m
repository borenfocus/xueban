//
//  XBPrivateListReformer.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateListReformer.h"
#import "XBPrivateListCellDataKey.h"

NSString * const kPrivateListCellDataKeyUserId = @"id";
NSString * const kPrivateListCellDataKeyHeadImg = @"head_img";
NSString * const kPrivateListCellDataKeyRealName = @"real_name";
NSString * const kPrivateListCellDataKeyTime = @"createdAt";
NSString * const kPrivateListCellDataKeyContent = @"content";
NSString * const kPrivateListCellDataKeyLastId = @"lastId";//这个不是服务器返回参数
NSString * const kPrivateListCellDataKeyUnreadNum = @"unreadNum";

@implementation XBPrivateListReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *peopleList = data[@"msg"][@"users"];
    [peopleList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
        NSNumber *unreadNum = @0;
        if (unreadArray) {
            for (NSDictionary *unreadDict in unreadArray) {
                if (unreadDict[@"fromId"] == dict[kPrivateListCellDataKeyUserId]) {
                    unreadNum = unreadDict[@"unreadNum"];
                }
            }
        }
        NSString *timeStr = dict[@"lastChatContent"][kPrivateListCellDataKeyTime];
        timeStr = [NSString formateDate:timeStr withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@0];
        NSDictionary *resultDict = @{
                                     kPrivateListCellDataKeyUserId: dict[kPrivateListCellDataKeyUserId],
                                     kPrivateListCellDataKeyHeadImg: dict[kPrivateListCellDataKeyHeadImg],
                                     kPrivateListCellDataKeyRealName: dict[kPrivateListCellDataKeyRealName],
                                     kPrivateListCellDataKeyTime: timeStr,
                                     kPrivateListCellDataKeyContent: dict[@"lastChatContent"][kPrivateListCellDataKeyContent],
                                     kPrivateListCellDataKeyLastId: dict[@"lastChatContent"][@"id"],
                                     kPrivateListCellDataKeyUnreadNum: unreadNum
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}
@end
