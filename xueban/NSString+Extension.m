//
//  NSString+Extension.m
//  xueban
//
//  Created by dang on 16/9/14.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)reformDateStringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *UTCDate = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:dateFormat];
    NSString *timeStr = [dateFormatter stringFromDate:UTCDate];
    return timeStr;
}

- (CGFloat)getHeightWithFontSize:(CGFloat)size Width:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return contentSize.height;
    
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString
{
    NSDate *lastDate = [NSDate dateFromString:self withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSInteger lastDateHour = [[dateFormatter stringFromDate:lastDate] integerValue];
    
    if (lastDateHour>=0 && lastDateHour<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%d",(int)lastDateHour];
    }else {
        period = @"下午";
        hour = [NSString stringWithFormat:@"%d",(int)lastDateHour-12];
        
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}


- (NSString *)changeDateString
{
    NSDate *lastDate = [NSDate dateFromString:self withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days == 1) {
            //dateStr = [lastDate stringYearMonthDayCompareToday];
            return @"昨天";//返回昨天
            
        }else if (days == 0)
        {
            dateStr = @"";
        }else{
            dateStr = [lastDate stringMonthDay];
            return [NSString stringWithFormat:@"%@", dateStr];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
        return [NSString stringWithFormat:@"%@", dateStr];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSInteger lastDateHour = [[dateFormatter stringFromDate:lastDate] integerValue];
    
    if (lastDateHour>=0 && lastDateHour<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%d",(int)lastDateHour];
    }else {
        period = @"下午";
        hour = [NSString stringWithFormat:@"%d",(int)lastDateHour-12];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate dateType:(NSNumber *)type
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        [dateFormatter setDateFormat:@"HH"];
        NSInteger lastDateHour = [[dateFormatter stringFromDate:needFormatDate] integerValue];
        NSString *period= @"";   //时间段
        NSString *hour;     //时
        if (lastDateHour>=0 && lastDateHour<12) {
            period = @"上午";
            hour = [NSString stringWithFormat:@"%d",(int)lastDateHour];
        }else if (lastDateHour==12){
            period = @"下午";
            hour = [NSString stringWithFormat:@"%d",(int)lastDateHour];
        }else{
            period = @"下午";
            hour = [NSString stringWithFormat:@"%d",(int)lastDateHour-12];
        }
        
        if(time<=60*60*24*2){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            

            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                 dateStr = [NSString stringWithFormat:@"%@%@:%02d",period, hour, (int)[needFormatDate minute]];
            }else{
                ////  昨天
                if ([type isEqualToNumber:@1])
                {
                    dateStr = [NSString stringWithFormat:@"昨天 %@%@:%02d",period, hour, (int)[needFormatDate minute]];
                }
                else
                    dateStr = [NSString stringWithFormat:@"昨天"];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                
                [dateFormatter setDateFormat:@"MM-dd"];
                if ([type isEqualToNumber:@1])
                {
                    dateStr = [NSString stringWithFormat:@"%@ %@%@:%02d", [dateFormatter stringFromDate:needFormatDate], period, hour, (int)[needFormatDate minute]];
                }
                else
                    dateStr = [dateFormatter stringFromDate:needFormatDate];

                
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                if ([type isEqualToNumber:@1])
                {
                    dateStr = [NSString stringWithFormat:@"%@ %@%@:%02d", [dateFormatter stringFromDate:needFormatDate], period, hour, (int)[needFormatDate minute]];
                }
                else
                    dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}
@end
