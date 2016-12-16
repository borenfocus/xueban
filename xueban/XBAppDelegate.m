//
//  XBAppDelegate.m
//  xueban
//
//  Created by dang on 16/6/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBAppDelegate.h"
#import "XBRootTabBarController.h"
#import "XBLoginViewController.h"
#import "XBSuggestViewController.h"
#import "XBMeAboutTableViewController.h"
#import "XBPrivateContentViewController.h"

#import "XBCleanCacheTool.h"
#import "TokenRefresh.h"
#import "XBCurriculumRefresh.h"
#import "VersionAgent.h"
//友盟统计
#import "UMMobClick/MobClick.h"
//友盟社会分享
#import <UMSocialCore/UMSocialCore.h>
//JSPatch热修复
#import <JSPatchPlatform/JSPatch.h>
//蒲公英sdk
//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>
//极光推送
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NSString *const kPrivateDidRecieveNotification = @"kPrivateDidRecieveNotification";
extern NSString * const XBWillEnterForegroundNotification;

@interface XBAppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation XBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupUMMobClick];
    [self setupUMSocialShare];
    [self setupJSPatch];
    [self setupJPush:launchOptions];
    
    [self customizeInterface];
    
    [self setupRootViewController];
    
    
    //初始化TokenRefresh中间人
    [TokenRefresh sharedInstance];

    self.window.backgroundColor = [UIColor whiteColor];
    
    //启动页隐藏statusBar后 重新显示出来
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[UIApplication sharedApplication].applicationIconBadgeNumber] forKey:MyBadgeNumber_Key];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[VersionAgent sharedInstance] shouldShowLocalNotification]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UILocalNotification * localNotification = [[UILocalNotification alloc] init];
            if (localNotification) {
                localNotification.fireDate= [[[NSDate alloc] init] dateByAddingTimeInterval:3];
                localNotification.timeZone=[NSTimeZone defaultTimeZone];
                localNotification.alertBody = @" 学伴有新的版本，到 App Store 看看吧。";
                localNotification.alertAction = @" 升级 ";
                localNotification.soundName = @"";
                [application scheduleLocalNotification:localNotification];
                if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
                    
                    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
                }
            }
        });
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    XBRootTabBarController *tabBarController = (XBRootTabBarController *)self.window.rootViewController;
    UITabBarItem *item = [tabBarController.tabBar.items objectAtIndex:3];
    item.badgeValue = nil;
    
    NSArray *unreadArray = [[NSArray alloc] init];
    [[NSUserDefaults standardUserDefaults]  setObject:unreadArray forKey:MyUnreadArray];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XBWillEnterForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IF_Login]) {
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[VersionAgent sharedInstance] checkVersion];
            [[XBCurriculumRefresh sharedInstance] refreshWithType:XBCurriculumRefreshTypeBackground];
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //进入AppStore
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * url = @"itms-apps://itunes.apple.com/app/id948136730";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
}

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark 友盟统计
- (void)setupUMMobClick {
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"";
    UMConfigInstance.channelId = @"App Store";
    //配置以上参数后调用此方法初始化SDK
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark 友盟社会分享
- (void)setupUMSocialShare {
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"" appSecret:@"" redirectURL:@""];
    
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@""  appSecret:@"" redirectURL:@""];
}

#pragma mark JSPatch热修复
- (void)setupJSPatch {
    [JSPatch startWithAppKey:@""];
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
//    [JSPatch testScriptInBundle];
}

#pragma mark 极光推送
- (void)setupJPush:(NSDictionary *)launchOptions {
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
#pragma clang diagnostic pop
    //Required
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0) {
            NSLog(@"registrationID获取成功：%@",registrationID);
        } else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}


//添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSDictionary *messageDict = userInfo[@"extra"];
    if ([userInfo[@"type"] isEqual: @3]) {
        NSNumber *fromId = messageDict[@"fromId"];
        NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
        NSInteger unreadNum = 0;
        if (unreadArray == nil) {
            unreadArray = [[NSArray alloc] init];
        }
        NSMutableArray *unreadListArray = [[NSMutableArray alloc] initWithArray:unreadArray];
        for (NSInteger i = 0; i < unreadListArray.count; i++) {
            NSDictionary *unreadDict = [unreadListArray objectAtIndex:i];
            if (unreadDict[@"fromId"] == fromId) {
                //如果有来自A的未读消息，又收到了新的A的未读消息
                unreadNum = [unreadDict[@"unreadNum"] integerValue] + 1;
                [unreadListArray replaceObjectAtIndex:i withObject:@{
                                                                       @"fromId": fromId,                                   @"unreadNum": [NSNumber numberWithInteger:unreadNum]
                                                                     }];
                break;
            }
        }
        if (unreadNum == 0) {
            //经过上面循环没有增加
            [unreadListArray addObject:@{
                                         @"fromId": fromId,
                                         @"unreadNum": @1
                                         }];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[unreadListArray copy] forKey:MyUnreadArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPrivateDidRecieveNotification object:nil userInfo:@{@"messageDict": messageDict}];
        
    }
    if ([userInfo[@"type"] isEqual: @5] || [userInfo[@"type"] isEqual: @6]) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else if ([userInfo[@"type"] isEqual: @0]) {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知");
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知");
    }
    completionHandler(UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    NSDictionary *messageDict = userInfo[@"extra"];
    if ([userInfo[@"type"] isEqual: @3]) {
        NSNumber *fromId = messageDict[@"fromId"];
        // 取到tabbarcontroller
        XBRootTabBarController *tabBarController = (XBRootTabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = 3;
        // 取到navigationcontroller
        UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
        //取到nav控制器当前显示的控制器
        UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[XBPrivateContentViewController class]]) {
//            XBPrivateContentViewController *vc = (XBPrivateContentViewController *)baseVC;
//            [vc.listAPIManager loadData];
            return;
        }
        // 否则，跳转到我的消息
        XBPrivateContentViewController *tableViewController = [[XBPrivateContentViewController alloc] init];
        tableViewController.userId = fromId;
        tableViewController.avatarUrl = messageDict[@"fromHeadImage"];
        tableViewController.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:tableViewController animated:NO];
    } else if ([userInfo[@"type"] isEqual: @5] || [userInfo[@"type"] isEqual: @6]) {
        // 取到tabbarcontroller
        XBRootTabBarController *tabBarController = (XBRootTabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = 3;
        // 取到navigationcontroller
        UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
        //取到nav控制器当前显示的控制器
        UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[XBMeAboutTableViewController class]])
        {
            XBMeAboutTableViewController *vc = (XBMeAboutTableViewController *)baseVC;
            [vc.aboutAPIManager loadData];
            return;
        }
        // 否则，跳转到我的相关
        XBMeAboutTableViewController *tableViewController = [[XBMeAboutTableViewController alloc] init];
        tableViewController.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:tableViewController animated:NO];
    } else if ([userInfo[@"type"] isEqual: @0]) {
        XBRootTabBarController *tabBarController = (XBRootTabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = 1;
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知");
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知");
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)setupRootViewController {
    //版本号key
    NSString*key = (NSString *)kCFBundleVersionKey;
    //当前最新应用的版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //沙盒中存储的登录过的应用版本号
    NSString*savedVersion= [[NSUserDefaults standardUserDefaults]objectForKey:key];
    //判断是否第一次进入当前版本
    if(![version isEqualToString:savedVersion]) {
        //保存版本号
        //[XBCleanCacheTool cleanCache];
        // ------注意这里没有讲IF_Login变为NO 为了保证当更新之后 用户不必重新登录
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        XBRootTabBarController *rootTabBarController = [[XBRootTabBarController alloc] init];
        rootTabBarController.tabBar.translucent = YES;  // 半透明
        self.window.rootViewController = rootTabBarController;
    //}
    //else
    //{
        ////保存版本号
        //[[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        ////第一次登录(显示新特性欢迎界面)
        ////self.window.rootViewController = [[NewFeatureViewControlleralloc]init];
        //XBSuggestViewController *suggestViewController = [[XBSuggestViewController alloc] init];
        //UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:suggestViewController];
        //self.window.rootViewController = navigation;
    //}
}

- (void)customizeInterface {
    UINavigationBar *navigationbar = [UINavigationBar appearance];
    
    // 默认情况下，导航栏的translucent属性为YES,另外，系统还会对所有的导航栏做模糊处理，这样可以让导航栏的颜色更加饱和。
    // 关闭模糊处理
    [navigationbar setTranslucent:NO];
    
    // 设置导航栏背景颜色
    [navigationbar setBarTintColor:[UIColor colorWithHexString:@"f5f5f5"]];
    
    // 设置返回按钮的箭头颜色
    [navigationbar setTintColor:[UIColor blackColor]];
    
    // 设置导航栏标题字体和颜色
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    [navigationbar setTitleTextAttributes:textAttributes];
//    //设置UITextField的光标颜色
//    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];
//    
//    //设置UITextView的光标颜色
//    [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];
    
    // 修改状态栏的风格
    // 1:在project target的Info tab中，插入一个新的key，名字为View controller-based status bar appearance，并将其值设置为NO。
    // 2:设置StatusBarStyle
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
