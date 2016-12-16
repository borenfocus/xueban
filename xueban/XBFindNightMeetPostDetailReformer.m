//
//  XBFindNightMeetPostDetailReformer.m
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetPostDetailReformer.h"
#import "XBFindNightMeetTableViewCellDataKey.h"
#import "XBFindNightMeetDetailTableViewCellDataKey.h"

NSString * const kFindNightMeetDetailTableViewCellDataKeyAvatarUrl = @"head_img";
NSString * const kFindNightMeetDetailTableViewCellDataKeyName = @"real_name";
NSString * const kFindNightMeetDetailTableViewCellDataKeyContent = @"content";
NSString * const kFindNightMeetDetailTableViewCellDataKeyTime = @"createdAt";
NSString * const kFindNightMeetDetailTableViewCellDataKeyCommentList = @"commentList";

@implementation XBFindNightMeetPostDetailReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *msgDict = data[@"msg"];
    NSMutableArray *resultArr = [NSMutableArray array];
    NSString *nameStr;
    if ([msgDict[kFindNightMeetTableViewCellDataKeyIsAnonymous]  isEqual: @1])
        nameStr = @"某同学";
    else
        nameStr = msgDict[kFindNightMeetTableViewCellDataKeyName];
    NSString *timeStr = msgDict[kFindNightMeetTableViewCellDataKeyTime];
    timeStr = [NSString formateDate:timeStr withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@0];
    
    NSArray *commentList = data[@"msg"][@"Comments"];
    [resultArr addObject:@{
                           kFindNightMeetTableViewCellDataKeyContent : msgDict[kFindNightMeetTableViewCellDataKeyContent],
                           kFindNightMeetTableViewCellDataKeySex : msgDict[kFindNightMeetTableViewCellDataKeySex],
                           kFindNightMeetTableViewCellDataKeyScanCount : [NSString stringWithFormat:@"%@次浏览", msgDict[kFindNightMeetTableViewCellDataKeyScanCount]],
                           kFindNightMeetTableViewCellDataKeyZanCount : [NSString stringWithFormat:@"%@", msgDict[kFindNightMeetTableViewCellDataKeyZanCount]],
                           kFindNightMeetTableViewCellDataKeyIsZan : msgDict[kFindNightMeetTableViewCellDataKeyIsZan],
                           kFindNightMeetTableViewCellDataKeyCommentCount : [NSString stringWithFormat:@"%@", msgDict[kFindNightMeetTableViewCellDataKeyCommentCount]],
                           kFindNightMeetTableViewCellDataKeyName : nameStr,
                           kFindNightMeetTableViewCellDataKeyId : msgDict[kFindNightMeetTableViewCellDataKeyId],
                           kFindNightMeetTableViewCellDataKeyAvatarUrl : msgDict[kFindNightMeetTableViewCellDataKeyAvatarUrl],
                           kFindNightMeetTableViewCellDataKeyTime : timeStr,
                           }];
    [commentList enumerateObjectsUsingBlock:^(NSDictionary *commentItemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = commentItemDict[kFindNightMeetDetailTableViewCellDataKeyTime];
        timeStr = [NSString formateDate:timeStr withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@0];
        NSDictionary *resultDict = @{
                                     kFindNightMeetDetailTableViewCellDataKeyAvatarUrl : commentItemDict[@"Student"][kFindNightMeetDetailTableViewCellDataKeyAvatarUrl],
                                     kFindNightMeetDetailTableViewCellDataKeyContent :
                                         commentItemDict[kFindNightMeetDetailTableViewCellDataKeyContent],
                                     kFindNightMeetDetailTableViewCellDataKeyName :
                                         commentItemDict[@"Student"][kFindNightMeetDetailTableViewCellDataKeyName],
                                     kFindNightMeetDetailTableViewCellDataKeyTime :
                                         timeStr
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
