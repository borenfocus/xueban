//
//  XBMeDetailTableViewController.m
//  xueban
//
//  Created by dang on 16/8/8.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeDetailTableViewController.h"
#import "XBMeDetailHeaderTableViewCell.h"
#import "XBMeDetailTableViewCell.h"
#import "XBEmptyTableViewCell.h"
#import "XBPersonInfoDataCenter.h"
#import <IQKeyboardManager.h>
#import "XBPickPhotoTool.h"
#import "XueBanAPIUrl.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD.h"
#define MAX_LIMIT_NUMS 10

extern NSString * const kMeDidChangeAvatarNotification;

@interface XBMeDetailTableViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    XBMeDetailHeaderTableViewCell *headerTableViewCell;
}
@property (nonatomic, strong) XBPickPhotoTool *pickPhotoTool;

@property (nonatomic,strong) MBProgressHUD  *HUD;
@end

@implementation XBMeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 为了消掉小红点
    [self.tableView reloadData];
    [MobClick beginLogPageView:@"我的-详情"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-详情"];
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
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7) {
        XBEmptyTableViewCell *cell = [[XBEmptyTableViewCell alloc] init];
        return cell;
    } else if (indexPath.row == 1) {
        headerTableViewCell = [[XBMeDetailHeaderTableViewCell alloc] init];
        [headerTableViewCell configWithDict:[[XBPersonInfoDataCenter sharedInstance] loadUser]];
        return headerTableViewCell;
    } else {
        XBMeDetailTableViewCell *cell = [[XBMeDetailTableViewCell alloc] init];
        [cell configWithDict:[[XBPersonInfoDataCenter sharedInstance] loadUser] AtIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7) {
        return 20;
    } else if (indexPath.row == 1) {
        return 80;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                       message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //处理点击拍照
            _pickPhotoTool = [[XBPickPhotoTool alloc] initWithType:XBPickPhotoTypeAvatar];
            [_pickPhotoTool showCameraWithController:self andWithBlock:^(UIImage *data) {
                data = [_pickPhotoTool reSizeImageData:data maxImageSize:800 maxSizeWithKB:800.0];
                [self updateImageToServer:data];
            }];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //处理点击从相册选取
            _pickPhotoTool = [[XBPickPhotoTool alloc] initWithType:XBPickPhotoTypeAvatar];
            [_pickPhotoTool showPhotoLibraryWithController:self andWithBlock:^(UIImage *data) {
                data = [_pickPhotoTool reSizeImageData:data maxImageSize:800 maxSizeWithKB:800.0];
                [self updateImageToServer:data];
            }];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[self.navigationController popToRootViewControllerAnimated:NO];
        }]];
        
        [self presentViewController: alertController animated: YES completion: nil];
    }
}

/*upload images*/
- (void)updateImageToServer:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);

    NSMutableDictionary *Exparams = [[NSMutableDictionary alloc]init];
    
    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:imageData, @"imageName", nil]];
    
    [self hudTipWillShow:YES];
    
    [CKHttpCommunicate createUnloginedUrlStr:kNetPath_Social_Upload WithParam:nil withExParam:Exparams withMethod:POST success:^(id result) {
        //当选取了照片后，暂时关闭学伴，再次打开学伴点击上传后 由于token过期 所以会返回空值
        if (result[@"msg"][@"filePath"])
        {
            [[XBPersonInfoDataCenter sharedInstance] changeAvatarUrl:result[@"msg"][@"filePath"]];
            headerTableViewCell.avatarImageView.image = image;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMeDidChangeAvatarNotification object:nil userInfo:@{@"avatarImage": image}];
        }
        [self hudTipWillShow:NO];
    } uploadFileProgress:^(NSProgress *uploadProgress) {
        
      //  self.HUD.progress = uploadProgress.fractionCompleted;
        
       // _HUD.labelText = [NSString stringWithFormat:@"%2.f%%",uploadProgress.fractionCompleted*100];
        
    } failure:^(NSError *erro) {
        [self hudTipWillShow:NO];
    }];
}

#pragma mark -- init MBProgressHUD
- (void)hudTipWillShow:(BOOL)willShow{
    if (willShow) {
        [self resignFirstResponder];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!_HUD) {
            _HUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            //_HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            //_HUD.progress = 0;
            //_HUD.labelText = @"0%";
            _HUD.removeFromSuperViewOnHide = YES;
        }else{
            //_HUD.progress = 0;
            //_HUD.labelText = @"0%";
            [keyWindow addSubview:_HUD];
            [_HUD show:YES];
        }
    }else{
        [_HUD hide:YES];
    }
}

#pragma mark - private method
- (void)initNavigationItem {
    self.title = @"我的资料";
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
