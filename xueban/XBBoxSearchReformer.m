//
//  XBBoxSearchReformer.m
//  xueban
//
//  Created by dang on 16/7/12.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSearchReformer.h"
#import "XBBoxContentCellDataKey.h"
#import "XBBoxSearchTableViewCellDataKey.h"
#import "XBFindSocialCellDataKey.h"
#import "XBCourseCellDataKey.h"
#import "XBMeCollectionCellDataKey.h"

NSString * const kSearchCellDataKeyImageUrl = @"imageUrl";
NSString * const kSearchCellDataKeyTitle = @"title";
NSString * const kSearchCellDataKeySubTitle = @"subTitle";

NSString * const kCourseCellDataKeyName = @"Name";
NSString * const kCourseCellDataKeyTime = @"Time";
NSString * const kCourseCellDataKeyWeek = @"Week";
NSString * const kCourseCellDataKeyLocation = @"Location";
NSString * const kCourseCellDataKeyTeacher = @"Teacher";
NSString * const kCourseCellDataKeyCredit = @"Credit";
NSString * const kCourseCellDataKeyLesson = @"kCourseCellDataKeyLesson";

@implementation XBBoxSearchReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *msgDict = data[@"msg"];
    NSArray *officialArr = msgDict[@"officials"];
    NSArray *studentArr = msgDict[@"students"];
    NSArray *courseArr = msgDict[@"courses"];
    NSArray *newsArr = msgDict[@"news"];
    NSMutableArray *officialResultArr = [NSMutableArray array];
    NSMutableArray *studentResultArr = [NSMutableArray array];
    NSMutableArray *courseResultArr = [NSMutableArray array];
    NSMutableArray *newsResultArr = [NSMutableArray array];
    if (officialArr) {
        [officialArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *extraKey = [dict[@"extra"][@"keys"] firstObject];
            NSString *extraValue = [dict[@"extra"][@"vals"] firstObject];
            NSDictionary *resultDict = @{
                                         kBoxContentCellDataKeyId: dict[kBoxContentCellDataKeyId],
                                         kBoxContentCellDataKeyUrl: dict[kBoxContentCellDataKeyUrl],
                                         kBoxContentCellDataKeyImageUrl: dict[kBoxContentCellDataKeyImageUrl],
                                         kBoxContentCellDataKeyTitle: dict[kBoxContentCellDataKeyTitle],
                                         kBoxContentCellDataKeySubTitle: dict[kBoxContentCellDataKeySubTitle],
                                         kBoxContentCellDataKeyIsConcern: dict[kBoxContentCellDataKeyIsConcern],
                                         kBoxContentCellDataKeyType: dict[kBoxContentCellDataKeyType],
                                         kBoxContentCellDataKeyExtraKey: extraKey,
                                         kBoxContentCellDataKeyExtraValue: extraValue,
                                         kBoxContentCellDataKeyBelongsTo: dict[kBoxContentCellDataKeyBelongsTo],
                                         kSearchCellDataKeyImageUrl: dict[@"head_img"],
                                         kSearchCellDataKeyTitle: dict[@"title"],
                                         kSearchCellDataKeySubTitle: dict[@"description"]
                                         };
            [officialResultArr addObject:resultDict];
        }];
    }
    if (studentArr) {
        [studentArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *resultDict = @{
                                         kFindSocialCellDataKeyUserId : dict[@"id"],
                                         kFindSocialCellDataKeyAvatarUrl : dict[kFindSocialCellDataKeyAvatarUrl],
                                         kFindSocialCellDataKeyRealName : dict[kFindSocialCellDataKeyRealName],
                                         kFindSocialCellDataKeySex : dict[kFindSocialCellDataKeySex],
                                         kFindSocialCellDataKeyHeadImg : dict[kFindSocialCellDataKeyHeadImg],
                                         kFindSocialCellDataKeyUniversity : dict[kFindSocialCellDataKeyUniversity],
                                         kFindSocialCellDataKeyProvince : dict[kFindSocialCellDataKeyProvince],
                                         kFindSocialCellDataKeyDepartment : dict[kFindSocialCellDataKeyDepartment],
                                         kFindSocialCellDataKeyMajor : dict[kFindSocialCellDataKeyMajor],
                                         kSearchCellDataKeyImageUrl: dict[@"head_img"],
                                         kSearchCellDataKeyTitle: dict[@"real_name"],
                                         kSearchCellDataKeySubTitle: dict[@"major"]
                                         };
            [studentResultArr addObject:resultDict];
        }];
    }
    if (courseArr) {
        [courseArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * credit = dict[@"Credit"];
            NSString * name = dict[@"Name"];
            NSString * teacher = dict[@"Teacher"];
            NSString * type = dict[@"Type"];
            
            NSArray * lessonArr = dict[@"Lesson"];
            NSMutableArray *lessonResultArr = [NSMutableArray array];
            [lessonArr enumerateObjectsUsingBlock:^(NSDictionary *lessonDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray * weekArray = lessonDict[@"Week"];
                NSString * duration = lessonDict[@"Duration"];
                NSString * section = lessonDict[@"Section"];
                NSString * weekDay = lessonDict[@"WeekDay"];
                NSString *location = lessonDict[@"Location"];
                
                NSString *weekStr = [weekArray componentsJoinedByString:@","];
                
                NSString * creditStr = [NSString stringWithFormat:@"%@课-%@学分",type,credit];
                NSString * nextSection = [NSString stringWithFormat:@"%ld",([section integerValue] + [duration integerValue] - 1)];
                NSArray *weekDayArr = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
                weekDay = [weekDayArr objectAtIndex:[weekDay integerValue]-1];
                NSString * dayStr = [NSString stringWithFormat:@"星期%@ %@-%@节",weekDay,section,nextSection];
                [lessonResultArr addObject:@{
                                             kCourseCellDataKeyLocation: location,
                                             kCourseCellDataKeyTime: dayStr,
                                             kCourseCellDataKeyWeek: weekStr,
                                             kCourseCellDataKeyCredit: creditStr,
                                             kCourseCellDataKeyName: name,
                                             kCourseCellDataKeyTeacher: teacher
                                             }];
            }];
            NSDictionary *resultDict = @{
                                         kSearchCellDataKeyTitle: dict[@"name"],
                                         kSearchCellDataKeySubTitle: dict[@"teacher"],
                                         kCourseCellDataKeyLesson: [lessonResultArr copy]
                                         };
            [courseResultArr addObject:resultDict];
        }];
    }
    if (newsArr) {
        [newsArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *resultDict = @{
                                         kSearchCellDataKeyImageUrl: dict[@"img"],
                                         kSearchCellDataKeyTitle: dict[@"title"],
                                         kSearchCellDataKeySubTitle: dict[@"description"],
                                         kMeCollectionCellDataKeyUrl: dict[@"url"]
                                         };
            [newsResultArr addObject:resultDict];
        }];
    }
    return @{
             @"official": [officialResultArr copy],
             @"student": [studentResultArr copy],
             @"course": [courseResultArr copy],
             @"news": [newsResultArr copy],
             };
}
@end
