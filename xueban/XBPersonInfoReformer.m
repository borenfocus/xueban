//
//  XBPersonInfoReformer.m
//  xueban
//
//  Created by dang on 16/9/20.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPersonInfoReformer.h"

NSString *const kPersonInfoStudentId = @"id";
NSString *const kPersonInfoStudentUserId = @"user_id";
NSString *const kPersonInfoRealName = @"real_name";
NSString *const kPersonInfoAvatarUrl = @"head_img";
NSString *const kPersonInfoStudentNumber = @"student_number";
NSString *const kPersonInfoCompus = @"compus";
NSString *const kPersonInfoDepartment = @"department";
NSString *const kPersonInfoProvince = @"province";
NSString *const kPersonInfoSex = @"sex";

@implementation XBPersonInfoReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *msg = data[@"msg"][@"personInfo"];
    NSString *sexStr;
    if ([msg[kPersonInfoSex] isEqual:@1])
        sexStr = @"男";
    else
        sexStr = @"女";
    return @{
             kPersonInfoStudentId: msg[kPersonInfoStudentId],
             kPersonInfoStudentUserId: msg[kPersonInfoStudentUserId],
             kPersonInfoRealName : msg[kPersonInfoRealName],
             kPersonInfoAvatarUrl : msg[kPersonInfoAvatarUrl],
             kPersonInfoStudentNumber : msg[kPersonInfoStudentNumber],
//             kPersonInfoCompus: msg[kPersonInfoCompus],
             kPersonInfoCompus: @"大连理工大学",
             kPersonInfoDepartment: msg[kPersonInfoDepartment],
             kPersonInfoProvince: msg[kPersonInfoProvince],
             kPersonInfoSex: sexStr,
             };
}

@end
