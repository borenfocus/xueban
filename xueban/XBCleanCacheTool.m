//
//  XBCleanCacheTool.m
//  xueban
//
//  Created by dang on 16/8/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBCleanCacheTool.h"

@implementation XBCleanCacheTool

+ (void)cleanCache {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyUnreadArray];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyFileList_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MySuggestOfficial_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyToolOfficial_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyCenterOfficial_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MySuggestOfficial_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyTerm_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyChatList_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyBadgeNumber_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserContent_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyName_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyStudentId_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyCourseSorted_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyBackgroundImage_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AllMyScore_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyCourse_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyScore_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IF_CourseHave];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyCourseColor_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyBorrowMessage_Key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyExamMessage_Key];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [JPUSHService setBadge:0];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
