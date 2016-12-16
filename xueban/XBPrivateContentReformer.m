//
//  XBPrivateContentReformer.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateContentReformer.h"
#import "XBPrivateContentCellDataKey.h"
//temp
#import "NSDate+Utils.h"

NSString *const kPrivateContentCellDataKeyId = @"id";
NSString *const kPrivateContentCellDataKeyFromId = @"fromId";
NSString *const kPrivateContentCellDataKeyToId = @"toId";
NSString *const kPrivateContentCellDataKeyContent = @"content";
NSString *const kPrivateContentCellDataKeyTime = @"createdAt";
NSString *const kPrivateContentCellDataKeyShowDate = @"shouldShowDate";
NSString *const kPrivateContentCellDataKeyPreviousDate = @"previousDate";

static NSString *previousTime = nil;

@interface XBPrivateContentReformer ()

@property (nonatomic, assign) NSNumber *shouldShowDate;

@end

@implementation XBPrivateContentReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data
{
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *peopleList = data[@"msg"][@"messages"];
    self.shouldShowDate = @1;
    [peopleList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[kPrivateContentCellDataKeyId] isEqual:@0])
        {
            return;
        }
        NSString *timeStr = dict[kPrivateContentCellDataKeyTime];
        timeStr = [NSString formateDate:timeStr withFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" dateType:@1];
        
        [self minuteOffSetStart:previousTime end:dict[kPrivateContentCellDataKeyTime]];
        if ([self.shouldShowDate  isEqual: @1])
        {
            previousTime = dict[kPrivateContentCellDataKeyTime];
        }
        NSDictionary *resultDict = @{
                                     kPrivateContentCellDataKeyId: dict[kPrivateContentCellDataKeyId],
                                     kPrivateContentCellDataKeyFromId: dict[kPrivateContentCellDataKeyFromId],
                                     kPrivateContentCellDataKeyToId: dict[kPrivateContentCellDataKeyToId],
                                     kPrivateContentCellDataKeyContent: dict[kPrivateContentCellDataKeyContent],
                                     kPrivateContentCellDataKeyTime: timeStr,
                                     kPrivateContentCellDataKeyShowDate :self.shouldShowDate,
                                     kPrivateContentCellDataKeyPreviousDate: previousTime
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}


- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.shouldShowDate = @1;
        return;
    }
    
    
    NSDate *startDate = [NSDate dateFromString:start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    
    NSDate *endDate = [NSDate dateFromString:end withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.shouldShowDate = @1;
    }else{
        self.shouldShowDate = @0;
    }
    
}
@end
