//
//  XBMeFileTableViewController.m
//  xueban
//
//  Created by dang on 16/8/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeFileTableViewController.h"
#import "XBFilePreviewController.h"
#import "XBMeFileTableViewCell.h"

@interface XBMeFileTableViewController ()

@property (nonatomic, strong) NSMutableArray *fileListArray;
@property (nonatomic, strong) XBNoDataView *noDataView;

@end

@implementation XBMeFileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-文件"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-文件"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBMeFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBMeFileTableViewCell class])];
    cell.fileName = [self.fileListArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [documentPaths objectAtIndex:0];
    NSString * filePath = [documentPath stringByAppendingPathComponent:[self.fileListArray objectAtIndex:indexPath.row]];
    XBFilePreviewController *previewController = [[XBFilePreviewController alloc] init];
    previewController.filePath = [NSString stringWithFormat:@"file://%@", [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navigationController pushViewController:previewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: 将文件真正删除, 现在只是从数组中删去了
    [self.fileListArray removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[self.fileListArray copy] forKey:MyFileList_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"我的文件";
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)initTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.tableView registerClass:[XBMeFileTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XBMeFileTableViewCell class])];
    NSArray *fileArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyFileList_Key];
    self.fileListArray = [[NSMutableArray alloc] initWithArray:fileArray];
    if (self.fileListArray.count > 0) {
        [self.tableView reloadData];
    } else {
        self.noDataView = [XBNoDataView configImageName:@"data_empty" withTitle:@"空空如也"];
        [self.tableView addSubview:self.noDataView];
    }
}

@end
