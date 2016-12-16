//
//  AboutXueBanViewController.m
//  ssdutAssistant
//
//  Created by OurEDA on 15/9/11.
//  Copyright (c) 2015年 OurEDA. All rights reserved.
//

#import "AboutXueBanViewController.h"
#import "AboutXueHeaderTableViewCell.h"
#import "AboutXueCustomTableViewCell.h"
#import "XBMeSetTableViewCell.h"
#import "AboutXueFooterTableViewCell.h"
#import "XBUserAgreementWebViewController.h"
#import "XBMeSetSignOutAlertView.h"
#import "XBLoginViewController.h"
#import "XBCleanCacheTool.h"

@interface AboutXueBanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UITableView * aboutXueTableView;
@end

@implementation AboutXueBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于学伴";
    [self initNavigationItem];
    self.aboutXueTableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self registerNibCell];
    
    self.aboutXueTableView.dataSource = self;
    self.aboutXueTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)registerNibCell
{
    [self.aboutXueTableView registerNibWithClass:[AboutXueHeaderTableViewCell class]];
    [self.aboutXueTableView registerNibWithClass:[AboutXueCustomTableViewCell class]];
    [self.aboutXueTableView registerNibWithClass:[AboutXueFooterTableViewCell class]];
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AboutXueHeaderTableViewCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"AboutXueHeaderTableViewCell" forIndexPath:indexPath];
        return headerCell;
    }else if (indexPath.row == 3){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        return cell;
    }else if (indexPath.row == 4){
        XBMeSetTableViewCell *cell = [[XBMeSetTableViewCell alloc] init];
        [cell configureCellAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        return cell;
    }else if (indexPath.row == 5){
        AboutXueFooterTableViewCell * footerCell = [tableView dequeueReusableCellWithIdentifier:@"AboutXueFooterTableViewCell" forIndexPath:indexPath];
        return footerCell;
    }else{
        AboutXueCustomTableViewCell * customCell = [tableView dequeueReusableCellWithIdentifier:@"AboutXueCustomTableViewCell" forIndexPath:indexPath];
        [customCell setCellType:indexPath.row];
        return customCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat custom_h ;
    if (SCREENWIDTH > 375) {
        custom_h = 75;
    }else if(SCREENWIDTH ==375){
        custom_h = 60;
    } else {
        custom_h = 50;
    }
    
    CGFloat header_h ;
    if (SCREENHEIGHT == 480) {
        header_h = 200;
    }else{
        header_h = 220;
    }
    
    switch (indexPath.row) {
        case 0:
            return header_h;
            break;
        case 1:case 2:case 4:
            return custom_h;
            break;
        case 3:
            return 15;
            break;
        case 5:
            return (SCREENHEIGHT - 3*custom_h - header_h-64-15);
            break;
            
        default:
            break;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        XBUserAgreementWebViewController * webViewController = [[XBUserAgreementWebViewController alloc] init];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else if (indexPath.row == 2) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id948136730"]];
    }
    else if (indexPath.row == 4) {
        XBMeSetSignOutAlertView *alertView = [[XBMeSetSignOutAlertView alloc] init];
        [alertView show];
        __weak typeof(alertView) weakAlertView = alertView;
        alertView.cancelHandler = ^(){
            [weakAlertView close];
        };
        alertView.confirmHandler = ^(){
            [weakAlertView close];
            [XBCleanCacheTool cleanCache];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IF_Login];
            XBLoginViewController *loginViewController = [[XBLoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:^{
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        };
    }
    [self.aboutXueTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private method
- (void)initNavigationItem
{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
