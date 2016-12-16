//
//  XBFindTableViewController.m
//  xueban
//
//  Created by dang on 16/7/14.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindTableViewController.h"
#import "XBEmptyTableViewCell.h"
#import "XBFindTableViewCell.h"
#import "XBFindNightMeetTableViewController.h"
#import "XBFindSocialTableViewController.h"
#import "XBFindLibraryViewController.h"
#import "XBFindScoreTableViewController.h"
#import "XBFindExamTableViewController.h"

@interface XBFindTableViewController ()

@end

@implementation XBFindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7) {
        XBEmptyTableViewCell *cell = [[XBEmptyTableViewCell alloc] init];
        return cell;
    } else {
        XBFindTableViewCell *cell = [[XBFindTableViewCell alloc] init];
        [cell configureCellAtIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 ||indexPath.row == 7) {
        return 15.0f;
    } else {
        return 60.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        XBFindNightMeetTableViewController *nightMeetTableViewController = [[XBFindNightMeetTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        nightMeetTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nightMeetTableViewController animated:YES];
    } else if (indexPath.row == 3) {
        XBFindSocialTableViewController *socialTableViewController = [[XBFindSocialTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        socialTableViewController.type = SocialTypeClassmate;
        socialTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:socialTableViewController animated:YES];
    } else if (indexPath.row == 4) {
        XBFindSocialTableViewController *socialTableViewController = [[XBFindSocialTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        socialTableViewController.type = SocialTypeTownee;
        socialTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:socialTableViewController animated:YES];
    } else if (indexPath.row == 6) {
        XBFindLibraryViewController *viewController = [[XBFindLibraryViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 8) {
        XBFindScoreTableViewController *scoreTableViewController = [[XBFindScoreTableViewController alloc] init];
        scoreTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scoreTableViewController animated:YES];
    } else if (indexPath.row == 9) {
        XBFindExamTableViewController *examTableViewController = [[XBFindExamTableViewController alloc] init];
        examTableViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:examTableViewController animated:YES];
    }
}

@end
