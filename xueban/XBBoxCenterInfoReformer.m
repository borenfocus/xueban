//
//  XBBoxCenterInfoReformer.m
//  xueban
//
//  Created by dang on 2016/11/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterInfoReformer.h"
#import "XBBoxCenterInfoKey.h"

NSString *const kBoxCenterInfoKeyId = @"id";
NSString *const kBoxCenterInfoKeyType = @"type";
NSString *const kBoxCenterInfoKeyUrl = @"redirect_url";
NSString *const kBoxCenterInfoKeyImageUrl = @"head_img";
NSString *const kBoxCenterInfoKeyTitle = @"title";
NSString *const kBoxCenterInfoKeySubTitle = @"description";
NSString *const kBoxCenterInfoKeyIsConcern = @"isConcerned";
NSString *const kBoxCenterInfoKeyExtraKey = @"kBoxContentCellDataKeyExtraKey";
NSString *const kBoxCenterInfoKeyExtraValue = @"kBoxContentCellDataKeyExtraValue";
NSString *const kBoxCenterInfoKeyBelongsTo = @"belongsTo";
NSString *const kBoxCenterInfoKeyNotifySetting = @"notifySettings";

@implementation XBBoxCenterInfoReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *dict = data[@"msg"][@"official"];
        NSString *extraKey = [dict[@"extra"][@"keys"] firstObject];
        NSString *extraValue = [dict[@"extra"][@"vals"] firstObject];
        return @{
                 kBoxCenterInfoKeyId: dict[kBoxCenterInfoKeyId],
                 kBoxCenterInfoKeyUrl: dict[kBoxCenterInfoKeyUrl],
                 kBoxCenterInfoKeyImageUrl: dict[kBoxCenterInfoKeyImageUrl],
                 kBoxCenterInfoKeyTitle: dict[kBoxCenterInfoKeyTitle],
                 kBoxCenterInfoKeySubTitle: dict[kBoxCenterInfoKeySubTitle],
                 kBoxCenterInfoKeyIsConcern: dict[kBoxCenterInfoKeyIsConcern],
                 kBoxCenterInfoKeyType: dict[kBoxCenterInfoKeyType],
                 kBoxCenterInfoKeyExtraKey: extraKey,
                 kBoxCenterInfoKeyExtraValue: extraValue,
                 kBoxCenterInfoKeyBelongsTo: dict[kBoxCenterInfoKeyBelongsTo],
                 kBoxCenterInfoKeyNotifySetting: dict[kBoxCenterInfoKeyNotifySetting]
                 };
}

@end
