//
//  XBSuggestViewController.m
//  xueban
//
//  Created by dang on 16/9/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBSuggestViewController.h"
#import "XBLoginViewController.h"
@interface XBSuggestViewController ()

@end

@implementation XBSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToApp:(id)sender
{
    XBLoginViewController *loginViewController = [[XBLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
