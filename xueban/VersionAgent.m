//
//  VersionAgent.m
//  xueban
//
//  Created by dang on 16/8/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "VersionAgent.h"
#define APPID @"948136730"

@interface VersionAgent()
{
    BOOL shouldShowLocalNotification;
    NSInteger month;
    NSInteger day;
}
@end

static VersionAgent *versionInstance;

@implementation VersionAgent

+ (id)sharedInstance {
    if (versionInstance == nil)
    {
        versionInstance = [[self alloc] init];
    }
    return versionInstance;
}

- (id)init {
    if (self = [super init]) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    }
    return self;
}

- (void)checkVersion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents * comp = [cal components:NSCalendarUnitWeekday|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    month = [comp month];
    day = [comp day];
    if (![[userDefaults objectForKey:@"checkVersionDay"] integerValue] ){
        //第一次打开应用没有checkVersionDay的值
        [userDefaults setObject:[NSNumber numberWithInteger:day] forKey:@"checkVersionDay"];
        [userDefaults synchronize];
    } else {
        if ([[userDefaults objectForKey:@"checkVersionDay"] integerValue] != day) {
            NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPID];
            NSURL *storeURL = [NSURL URLWithString:storeString];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
            request.HTTPMethod = @"GET";
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if ([data length] > 0 && !error) {// Success
                    [userDefaults setObject:[NSNumber numberWithInteger:day] forKey:@"checkVersionDay"];
                    NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    // All versions that have been uploaded to the AppStore
                    NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                    if ( ![versionsInAppStore count] ) // No versions of app in AppStore
                        return;
                    else {
                        NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                        if ([appVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                            //has new version
                            if ([[userDefaults objectForKey:@"sendUpdateNotificationTime"] integerValue]) {
                                //15天之内如果没有发过通知就发送升级通知 粗略的估计了两次的间隔 30代表一个月的时间
                                if (month*30+day - [[userDefaults objectForKey:@"sendUpdateNotificationTime"] integerValue] > 15) {
                                    shouldShowLocalNotification = YES;
                                }
                            }
                        }
                    }
                }
            }];
        }
    }
}

- (BOOL)shouldShowLocalNotification {
    if (shouldShowLocalNotification) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:month*30+day] forKey:@"sendUpdateNotificationTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        shouldShowLocalNotification = NO;
        return YES;
    }
    return NO;
}

@end
