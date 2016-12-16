//
//  XBRootTabBarController.m
//  xueban
//
//  Created by dang on 16/6/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBRootTabBarController.h"
#import "XBERPCourseViewController.h"
#import "XBBoxViewController.h"
#import "XBFindTableViewController.h"
#import "XBMeTableViewController.h"

extern NSString *const kPrivateDidRecieveNotification;

@interface XBRootTabBarController ()

@end

@implementation XBRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateDidRecieveNotificationAction:) name:kPrivateDidRecieveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {
    XBERPCourseViewController *erpCourseViewController = [[XBERPCourseViewController alloc] init];
    erpCourseViewController.title = @"课表";
    erpCourseViewController.tabBarItem = [self initializeTabBarItemWithTag:0];
    UINavigationController *courseNav = [[UINavigationController alloc] initWithRootViewController:erpCourseViewController];
    
    XBBoxViewController *boxViewController = [[XBBoxViewController alloc] init];
    boxViewController.title = @"动态";
    boxViewController.tabBarItem = [self initializeTabBarItemWithTag:1];
    UINavigationController *boxNav = [[UINavigationController alloc] initWithRootViewController:boxViewController];

    XBFindTableViewController *findTableViewController = [[XBFindTableViewController alloc] init];
    findTableViewController.title = @"发现";
    findTableViewController.tabBarItem = [self initializeTabBarItemWithTag:2];
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:findTableViewController];

    XBMeTableViewController *meTableViewController = [[XBMeTableViewController alloc] init];
    meTableViewController.title = @"我的";
    meTableViewController.tabBarItem = [self initializeTabBarItemWithTag:3];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meTableViewController];
    
    self.viewControllers = @[courseNav, boxNav, findNav, meNav];
}

- (UITabBarItem *)initializeTabBarItemWithTag:(NSInteger)tag {
    NSArray *tabBarItemImages = @[@"erp", @"box", @"find", @"me"];
    NSArray *tabBarItemTitles = @[@"课表", @"动态", @"发现", @"我的"];
    UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal", tabBarItemImages[tag]]];
    UIImage *highlitedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_highlight", tabBarItemImages[tag]]];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    highlitedImage = [highlitedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:tabBarItemTitles[tag] image:normalImage selectedImage:highlitedImage];
    barItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    [barItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                      NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                      NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
    return barItem;
}

- (void)privateDidRecieveNotificationAction:(NSNotification *)notify {
    NSInteger allUnreadNum = 0;
    NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
    for (NSDictionary *dict in unreadArray) {
        allUnreadNum += [dict[@"unreadNum"] integerValue];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = allUnreadNum;
    UITabBarItem *item = [self.tabBar.items objectAtIndex:3];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        item.badgeValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
}

@end
