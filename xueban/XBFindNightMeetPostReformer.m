//
//  XBFindNightMeetPostReformer.m
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetPostReformer.h"
#import "XBFindNightMeetTableViewCellDataKey.h"

NSString * const kFindNightMeetTableViewCellDataKeyContent = @"content";
NSString * const kFindNightMeetTableViewCellDataKeySex = @"sex";
NSString * const kFindNightMeetTableViewCellDataKeyIsAnonymous = @"isAnonymous";
NSString * const kFindNightMeetTableViewCellDataKeyScanCount = @"clickCount";
NSString * const kFindNightMeetTableViewCellDataKeyZanCount = @"starCount";
NSString * const kFindNightMeetTableViewCellDataKeyIsZan = @"isLiked";
NSString * const kFindNightMeetTableViewCellDataKeyCommentCount = @"commentsCount";
NSString * const kFindNightMeetTableViewCellDataKeyName = @"real_name";
NSString * const kFindNightMeetTableViewCellDataKeyId = @"id";
NSString * const kFindNightMeetTableViewCellDataKeyStudentId = @"StudentId";
NSString * const kFindNightMeetTableViewCellDataKeyAvatarUrl = @"head_img";
NSString * const kFindNightMeetTableViewCellDataKeyTime = @"createdAt";
NSString * const kFindNightMeetTableViewCellDataKeyUniversity = @"university";
NSString * const kFindNightMeetTableViewCellDataKeyDepartment = @"department";
NSString * const kFindNightMeetTableViewCellDataKeyProvince = @"province";

@implementation XBFindNightMeetPostReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"posts"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *postItemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *nameStr;
        if ([postItemDict[kFindNightMeetTableViewCellDataKeyIsAnonymous]  isEqual: @1])
            nameStr = @"某同学";
        else
            nameStr = postItemDict[kFindNightMeetTableViewCellDataKeyName];
        NSString *timeStr = postItemDict[kFindNightMeetTableViewCellDataKeyTime];
        timeStr = [NSString formateDate:timeStr withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@0];
        NSDictionary *resultDict = @{
                                     kFindNightMeetTableViewCellDataKeyContent : postItemDict[kFindNightMeetTableViewCellDataKeyContent],
                                     kFindNightMeetTableViewCellDataKeySex : postItemDict[kFindNightMeetTableViewCellDataKeySex],
                                     kFindNightMeetTableViewCellDataKeyScanCount : [NSString stringWithFormat:@"%@次浏览", postItemDict[kFindNightMeetTableViewCellDataKeyScanCount]],
                                     kFindNightMeetTableViewCellDataKeyZanCount : [NSString stringWithFormat:@"%@", postItemDict[kFindNightMeetTableViewCellDataKeyZanCount]],
                                     kFindNightMeetTableViewCellDataKeyIsZan : postItemDict[kFindNightMeetTableViewCellDataKeyIsZan],
                                     kFindNightMeetTableViewCellDataKeyCommentCount : [NSString stringWithFormat:@"%@", postItemDict[kFindNightMeetTableViewCellDataKeyCommentCount]],
                                     kFindNightMeetTableViewCellDataKeyName : nameStr,
                                     kFindNightMeetTableViewCellDataKeyId : postItemDict[kFindNightMeetTableViewCellDataKeyId],
                                     kFindNightMeetTableViewCellDataKeyStudentId: postItemDict[kFindNightMeetTableViewCellDataKeyStudentId],
                                     kFindNightMeetTableViewCellDataKeyAvatarUrl : postItemDict[kFindNightMeetTableViewCellDataKeyAvatarUrl],
                                     kFindNightMeetTableViewCellDataKeyTime : timeStr,
//                                     kFindNightMeetTableViewCellDataKeyUniversity: postItemDict[kFindNightMeetTableViewCellDataKeyUniversity],
                                     kFindNightMeetTableViewCellDataKeyDepartment: postItemDict[kFindNightMeetTableViewCellDataKeyDepartment],
                                     kFindNightMeetTableViewCellDataKeyProvince: postItemDict[kFindNightMeetTableViewCellDataKeyProvince],
                                     kFindNightMeetTableViewCellDataKeyIsAnonymous: postItemDict[kFindNightMeetTableViewCellDataKeyIsAnonymous]
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
