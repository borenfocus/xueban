//
//  XBCurriculumRefresh.m
//  xueban
//
//  Created by dang on 2016/11/2.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBCurriculumRefresh.h"
#import "XBCurriculumAPIManager.h"
@interface XBCurriculumRefresh()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    XBCurriculumRefreshType typeCopy;
}
@property (nonatomic, strong) XBCurriculumAPIManager *curriculumAPIManager;

@end

@implementation XBCurriculumRefresh

+ (instancetype)sharedInstance {
    static XBCurriculumRefresh *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XBCurriculumRefresh alloc] init];
    });
    return sharedInstance;
}

- (void)refreshWithType:(XBCurriculumRefreshType)type {
    typeCopy = type;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MySemester_Key]) {
        [self.curriculumAPIManager loadData];
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    params = @{
               
               };
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.curriculumAPIManager) {
        //刷新UI
        NSDictionary * contentDic = [manager fetchDataWithReformer:nil];
        if ([[contentDic objectForKey:@"status"] boolValue]) {
            NSArray * courseArr = [contentDic objectForKey:@"msg"][@"curriculum"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:courseArr forKey:MyCourse_Key];
            NSMutableArray * realCourseList = [[NSMutableArray alloc]init];
            for(NSInteger i = 0 ; i < [courseArr count] ; i++) {
                //去除掉尔雅的数组
                NSArray *array = [[courseArr objectAtIndex:i] objectForKey:@"Lesson"];
                if ([array count]) {
                    //开始将一周多节课的课程按照每一节课分开
                    for (NSInteger j = 0; j < [array count]; j++) {
                        NSMutableDictionary * mutDic = [[NSMutableDictionary alloc] initWithDictionary:[courseArr objectAtIndex:i]];
                        [mutDic removeObjectForKey:@"Lesson"];
                        [mutDic setObject:[array objectAtIndex:j] forKey:@"Lesson"];
                        [realCourseList addObject:mutDic];
                    }
                }
            }
            //TODO: 这里有严重问题 
            if ([realCourseList count] >= 2) {
                //冒泡排序
                for (NSInteger i = 0 ;  i < ([realCourseList count] - 2) ; i ++) {
                    for (NSInteger j = 0 ; j < ([realCourseList count] - 2 - i) ; j ++) {
                        if ([[[realCourseList objectAtIndex:j] objectForKey:@"Lesson"] objectForKey:@"WeekDay"] > [[[realCourseList objectAtIndex:j + 1] objectForKey:@"Lesson"] objectForKey:@"WeekDay"]) {
                            
                            NSDictionary * tempDic = [[NSDictionary alloc]initWithDictionary:[realCourseList objectAtIndex:j]];
                            [realCourseList replaceObjectAtIndex:j withObject:[realCourseList objectAtIndex:j + 1]];
                            [realCourseList replaceObjectAtIndex:j + 1 withObject:tempDic];
                        } else if ([[[realCourseList objectAtIndex:j] objectForKey:@"Lesson"] objectForKey:@"WeekDay"] ==[[[realCourseList objectAtIndex:j + 1] objectForKey:@"Lesson"] objectForKey:@"WeekDay"]) {
                            
                            if ([[[realCourseList objectAtIndex:j] objectForKey:@"Lesson"] objectForKey:@"Section"] > [[[realCourseList objectAtIndex:j + 1] objectForKey:@"Lesson"] objectForKey:@"Section"]) {
                                
                                NSDictionary * tempDic = [[NSDictionary alloc]initWithDictionary:[realCourseList objectAtIndex:j]];
                                [realCourseList replaceObjectAtIndex:j withObject:[realCourseList objectAtIndex:j + 1]];
                                [realCourseList replaceObjectAtIndex:j + 1 withObject:tempDic];
                            }
                        }
                    }
                }
                [userDefaults setObject:realCourseList forKey:MyCourseSorted_Key];
                [userDefaults synchronize];
            }
            if (self.completeHandler && typeCopy == XBCurriculumRefreshTypeForeground) {
                self.completeHandler();
            }
        }
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
    NSNumber *code = responseDict[@"code"];
    if (typeCopy == XBCurriculumRefreshTypeForeground) {
        if (self.failHandler) {
            self.failHandler([code intValue]);
        }
    }
}

#pragma mark - getters and setters
- (XBCurriculumAPIManager *)curriculumAPIManager {
    if (_curriculumAPIManager == nil) {
        _curriculumAPIManager = [[XBCurriculumAPIManager alloc] init];
        _curriculumAPIManager.delegate = self;
        _curriculumAPIManager.paramSource = self;
    }
    return _curriculumAPIManager;
}

@end
