//
//  XBMeAboutReformer.m
//  xueban
//
//  Created by dang on 2016/10/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeAboutReformer.h"
#import "XBMeAboutCellDataKey.h"

NSString * const kMeAboutCellDataKeyType = @"meType";//1是评论 2是点赞
NSString * const kMeAboutCellDataKeyHeadImg = @"head_img";
NSString * const kMeAboutCellDataKeyRealName = @"real_name";
NSString * const kMeAboutCellDataKeyCommentContent = @"CommentContent";
NSString * const kMeAboutCellDataKeyPostContent = @"ForumContent";
NSString * const kMeAboutCellDataKeyPostId = @"ForumId";
NSString * const kMeAboutCellDataKeyRawTime = @"createdAt";
NSString * const kMeAboutCellDataKeyTime = @"time";

@implementation XBMeAboutReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"aboutMe"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        long time = [dict[kMeAboutCellDataKeyRawTime] longValue]/1000.0;
        NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *timeStr = [dateFormatter stringFromDate:createdDate];
        
        NSDictionary *resultDict;
        if ([dict[kMeAboutCellDataKeyType] isEqualToNumber:@1]) {
            resultDict = @{
                           kMeAboutCellDataKeyType: dict[kMeAboutCellDataKeyType],
                           kMeAboutCellDataKeyHeadImg: dict[kMeAboutCellDataKeyHeadImg],
                           kMeAboutCellDataKeyRealName: dict[kMeAboutCellDataKeyRealName],
                           kMeAboutCellDataKeyCommentContent: dict[kMeAboutCellDataKeyCommentContent],
                           kMeAboutCellDataKeyPostContent: dict[kMeAboutCellDataKeyPostContent],
                           kMeAboutCellDataKeyPostId: dict[kMeAboutCellDataKeyPostId],
                           kMeAboutCellDataKeyRawTime: [NSString stringWithFormat:@"%@", dict[kMeAboutCellDataKeyRawTime]],
                           kMeAboutCellDataKeyTime: timeStr
                           };
        } else {
            resultDict = @{
                             kMeAboutCellDataKeyType: dict[kMeAboutCellDataKeyType],
                             kMeAboutCellDataKeyHeadImg: dict[kMeAboutCellDataKeyHeadImg],
                             kMeAboutCellDataKeyRealName: dict[kMeAboutCellDataKeyRealName],
                             kMeAboutCellDataKeyPostContent: dict[kMeAboutCellDataKeyPostContent],
                             kMeAboutCellDataKeyPostId: dict[kMeAboutCellDataKeyPostId],
                             kMeAboutCellDataKeyRawTime: [NSString stringWithFormat:@"%@", dict[kMeAboutCellDataKeyRawTime]],
                             kMeAboutCellDataKeyTime: timeStr
                           };

        }
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
