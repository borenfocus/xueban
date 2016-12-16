//
//  XBFindSocialReformer.m
//  xueban
//
//  Created by dang on 16/9/28.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindSocialReformer.h"
#import "XBFindSocialCellDataKey.h"
#import "XBFindSocialAPIManager.h"

NSString * const kFindSocialCellDataKeyUserId = @"StudentId";
NSString * const kFindSocialCellDataKeyAvatarUrl = @"head_img";
NSString * const kFindSocialCellDataKeyRealName = @"real_name";
NSString * const kFindSocialCellDataKeySex = @"sex";
NSString * const kFindSocialCellDataKeyHeadImg = @"head_img";
NSString * const kFindSocialCellDataKeyUniversity = @"university";
NSString * const kFindSocialCellDataKeyProvince = @"province";
NSString * const kFindSocialCellDataKeyDepartment = @"department";
NSString * const kFindSocialCellDataKeyMajor = @"major";

@implementation XBFindSocialReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[XBFindSocialAPIManager class]]) {
        NSMutableArray *resultArr = [NSMutableArray array];
        NSArray *peopleList = data[@"msg"][@"people"];
        [peopleList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *resultDict = @{
                                         kFindSocialCellDataKeyUserId : dict[@"id"],
                                         kFindSocialCellDataKeyAvatarUrl : dict[kFindSocialCellDataKeyAvatarUrl],
                                         kFindSocialCellDataKeyRealName : dict[kFindSocialCellDataKeyRealName],
                                         kFindSocialCellDataKeySex : dict[kFindSocialCellDataKeySex],
                                         kFindSocialCellDataKeyHeadImg : dict[kFindSocialCellDataKeyHeadImg],
                                         kFindSocialCellDataKeyUniversity : @"大连理工大学",
                                         kFindSocialCellDataKeyProvince : dict[kFindSocialCellDataKeyProvince],
                                         kFindSocialCellDataKeyDepartment : dict[kFindSocialCellDataKeyDepartment],
                                         kFindSocialCellDataKeyMajor : dict[kFindSocialCellDataKeyMajor],
                                         };
            [resultArr addObject:resultDict];
        }];
        return [resultArr copy];
    }
    return nil;
}

@end
