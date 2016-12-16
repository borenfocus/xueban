//
//  XBFindExamReformer.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindExamReformer.h"
#import "XBFindScoreTableViewCellDataKey.h"

NSString * const kFindExamTableViewCellDataKeyName = @"kFindExamTableViewCellDataKeyName";
NSString *const kFindExamTableViewCellDataKeyCountDown = @"kFindExamTableViewCellDataKeyCountDown";
//传入数组没什么用 只是为了在这里进行排序
NSString *const kFindExamTableViewCellDataKeyCountDownNum = @"kFindExamTableViewCellDataKeyCountDownNum";
NSString *const kFindExamTableViewCellDataKeyLocation = @"kFindExamTableViewCellDataKeyLocation";
NSString *const kFindExamTableViewCellDataKeyTime = @"kFindExamTableViewCellDataKeyTime";
NSString *const kFindExamTableViewCellDataKeyExpire = @"kFindExamTableViewCellDataKeyExpire";

@implementation XBFindExamReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSInteger countDownNum;
    NSArray *msgList = data[@"msg"][@"exam"];
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *weekDayArr = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    for (NSDictionary *examItemDict in msgList) {
        NSMutableDictionary *examItemMDict = [[NSMutableDictionary alloc] initWithDictionary:examItemDict];
        NSString *examDateStr = examItemDict[@"Day"];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *examDate = [dateFormatter dateFromString:examDateStr];
        NSString *semesterStartDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"semesterStartDateStr"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * startDate = [dateFormatter dateFromString:semesterStartDateStr];
        NSTimeInterval timeInterval = [examDate timeIntervalSinceDate:startDate]/(24*60*60*7);
        NSInteger examWeekNum = timeInterval + 1;
        
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents * comp = [cal components:NSCalendarUnitWeekday|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:examDate];
        NSInteger item = [comp weekday];
        NSInteger examWeekDay = ( item + 6)%7 + ((item - 8) * (-1) / 7 )*7;
    
        NSInteger nowWeekNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weekNum"] integerValue];
        NSInteger nowWeekDay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weekDay"] integerValue];
        
        countDownNum = 7*examWeekNum+examWeekDay-7*nowWeekNum-nowWeekDay;
        NSString *countDownStr;
        if (countDownNum > 0) {
            countDownStr = [NSString stringWithFormat:@"倒计时%ld天", countDownNum];
            [examItemMDict setObject:@0 forKey:@"Expire"];
        } else if (countDownNum == 0) {
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            NSInteger nowHour = [dateComponent hour];
            NSInteger nowMinute = [dateComponent minute];
            NSInteger examHour, examMinute;
            NSInteger preExamHour = [[examItemDict[@"Time"] substringWithRange:NSMakeRange([examItemDict[@"Time"] rangeOfString:@"-"].location+1, 1)] integerValue];
            if (preExamHour > 2) {
                //上午的考试
                examHour = [[examItemDict[@"Time"] substringWithRange:NSMakeRange([examItemDict[@"Time"] rangeOfString:@"-"].location+1, 1)] integerValue];
                examMinute = [[examItemDict[@"Time"] substringWithRange:NSMakeRange([examItemDict[@"Time"] rangeOfString:@"-"].location+3, 2)] integerValue];
            } else {
                //下午的考试
                examHour = [[examItemDict[@"Time"] substringWithRange:NSMakeRange([examItemDict[@"Time"] rangeOfString:@"-"].location+1, 2)] integerValue];
                examMinute = [[examItemDict[@"Time"] substringWithRange:NSMakeRange([examItemDict[@"Time"] rangeOfString:@"-"].location+4, 2)] integerValue];
            }
            if (examHour*60+examMinute > nowHour*60+nowMinute) {
                 countDownStr = @"今天";
                 [examItemMDict setObject:@0 forKey:@"Expire"];
            } else {
                countDownStr = @"已过期";
                [examItemMDict setObject:@1 forKey:@"Expire"];
            }
        } else {
            if ([examItemMDict[@"Time"] isEqualToString:@"none"])
            {
                countDownStr = @"none";
                [examItemMDict setObject:@2 forKey:@"Expire"];
            }
            else
            {
                countDownStr = @"已过期";
                [examItemMDict setObject:@1 forKey:@"Expire"];
            }
        }
        NSString *location;
        NSString *time;
        if ([examItemMDict[@"Time"] isEqualToString:@"none"])
        {
            location = @"考试地点 :";
            time = @"考试时间 :";
        }
        else
        {
            location = [NSString stringWithFormat:@"考试地点 : %@ %@", examItemMDict[@"House"], examItemMDict[@"Classroom"]];
            time = [NSString stringWithFormat:@"考试时间 : 第%ld周 星期%@ %@", (long)examWeekNum, [weekDayArr objectAtIndex:(examWeekDay-1)], examItemMDict[@"Time"]];
        }
        NSDictionary *resultDict = @{
                                     kFindExamTableViewCellDataKeyName : examItemMDict[@"Name"],
                                     kFindExamTableViewCellDataKeyCountDown :
                                         countDownStr,
                                     kFindExamTableViewCellDataKeyCountDownNum :
                                         [NSNumber numberWithInteger:countDownNum],
                                     kFindExamTableViewCellDataKeyLocation : location,
                                     kFindExamTableViewCellDataKeyTime : time,
                                     kFindExamTableViewCellDataKeyExpire :
                                         examItemMDict[@"Expire"]
                                     };
        [resultArr addObject:resultDict];
    }
    //依次排序
    NSSortDescriptor *expireDescriptor = [NSSortDescriptor sortDescriptorWithKey:kFindExamTableViewCellDataKeyExpire ascending:YES];
    NSSortDescriptor *countDownDescriptor = [NSSortDescriptor sortDescriptorWithKey: kFindExamTableViewCellDataKeyCountDownNum ascending:YES];
    return [resultArr sortedArrayUsingDescriptors:@[expireDescriptor, countDownDescriptor]];
}
@end
