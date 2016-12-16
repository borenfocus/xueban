//
//  XBCourseTableViewController.m
//  xueban
//
//  Created by dang on 2016/10/30.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBCourseTableViewController.h"
#import "XBCourseTableViewCell.h"
#import "XBCourseCellDataKey.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface XBCourseTableViewController ()

@property (nonatomic, strong) NSArray *lessonArray;

@end

@implementation XBCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lessonArray = self.configDict[kCourseCellDataKeyLesson];
    [self initNavigationItem];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"全搜-课程"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"全搜-课程"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lessonArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBCourseTableViewCell class])];
    [cell configWithDict:self.lessonArray[indexPath.section]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"课程详情";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[XBCourseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBCourseTableViewCell class])];
}

@end
