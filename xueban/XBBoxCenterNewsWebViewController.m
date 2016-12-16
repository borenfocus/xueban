//
//  XBBoxCenterNewsWebViewController.m
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterNewsWebViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "XBDownloadFileTool.h"
#import "XBDownloadBottomView.h"
#import "XBBoxCenterCellDataKey.h"
#import "XBBoxCenterNewsCollectAPIManager.h"
#import "XBBoxUnionIdAPIManager.h"
#import "XBFilePreviewController.h"
#import "XBMeFileTableViewController.h"
#import "XBBoxSetTableViewController.h"
#import "FSShareSheet.h"
#import "XBBoxContentCellDataKey.h"
@interface XBBoxCenterNewsWebViewController ()<WKNavigationDelegate, UIAlertViewDelegate, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, FSShareSheetDelegate>
{
    NSURLRequest *requestCopy;
    NSString *fileName;
    NSString *filePathCopy;
    NSString *unionId;
}
@property (nonatomic, strong) XBBoxCenterNewsCollectAPIManager *collectAPIManager;
@property (nonatomic, strong) XBBoxUnionIdAPIManager *unionIdAPIManager;
@property (nonatomic, strong) XBDownloadBottomView *bottomView;

@end

@implementation XBBoxCenterNewsWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationItem];
    self.webView.navigationDelegate = self;
    [self.unionIdAPIManager loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订阅号文章"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订阅号文章"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *hostname = navigationAction.request.URL.absoluteString;
    for (NSInteger i = 0; i < [self.fileArray count]; i ++) {
        NSDictionary * dic = [self.fileArray objectAtIndex:i];
        NSString * urlStr = [dic objectForKey:@"url"];
        if ([hostname isEqualToString:urlStr])
        {
            fileName = [dic objectForKey:@"text"];
            requestCopy = navigationAction.request;
            if (navigationAction.navigationType == WKNavigationTypeLinkActivated)
            {
                XBDownloadFileTool * downloadFile = [[XBDownloadFileTool alloc] init];
                NSArray * documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * documentPath = [documentPaths objectAtIndex:0];
                NSString * filePath = [documentPath stringByAppendingPathComponent:fileName];
                if (![downloadFile ifHaveDownload:fileName]) {
                    
                    UIAlertView * view  =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否下载%@", fileName] message:nil delegate:self cancelButtonTitle:@"开始下载" otherButtonTitles:@"取消下载", nil];
                    [view show];
                    
                } else {
                    XBFilePreviewController *previewController = [[XBFilePreviewController alloc] init];
                    previewController.filePath = [NSString stringWithFormat:@"file://%@", [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [self.navigationController pushViewController:previewController animated:YES];
                }
                // 不允许web内跳转
                decisionHandler(WKNavigationActionPolicyCancel);
            }
            break;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_bottomView.progressButton setEnabled:NO];
        [_bottomView.progressButton setTitle:@"正在下载" forState:UIControlStateNormal];
        [_bottomView.progressButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
        NSInteger location = [fileName rangeOfString:@"."].location;
        NSString *formate = [fileName substringFromIndex:location];
        UIImage * fileImage;
        if ([formate isEqual:@".apk"]) {
            fileImage = UIIMGName(@"me_file_apk");
        }else if ([formate isEqual:@".doc"] || [formate isEqual:@".docx"]) {
            fileImage = UIIMGName(@"me_file_doc");
        }else if ([formate isEqual:@".pdf"]) {
            fileImage = UIIMGName(@"me_file_pdf");
        }else if ([formate isEqual:@".jpg"]||[formate isEqual:@".jpeg"]||[formate isEqual:@".png"]) {
            fileImage = UIIMGName(@"me_file_pic");
        }else if ([formate isEqual:@".txt"]) {
            fileImage = UIIMGName(@"me_file_txt");
        }else if ([formate isEqual:@".xls"] || [formate isEqual:@".xlsx"]) {
            fileImage = UIIMGName(@"me_file_xls");
        }else if ([formate isEqual:@".zip"] ) {
            fileImage = UIIMGName(@"me_file_zip");
        }else{
            fileImage = UIIMGName(@"me_file_other");
        }
        self.bottomView.iconImageView.image = fileImage;
        self.bottomView.titleLabel.text = fileName;
        [self.view addSubview:self.bottomView];
        XBDownloadFileTool * downloadFile = [[XBDownloadFileTool alloc] init];
        [downloadFile downloadFileWithOption: nil
                               withInferface: [requestCopy.URL absoluteString]
                                   savedPath: fileName
                             downloadSuccess:^(AFHTTPSessionManager *manager, NSString *filePath) {
                                 [_bottomView.progressButton setEnabled:YES];
                                 [_bottomView.progressButton setTitle:@"查看下载" forState:UIControlStateNormal];
                                 [_bottomView.progressButton setBackgroundColor:[UIColor colorWithHexString:BlueColor]];
                                 filePathCopy = filePath;
                             } downloadFailure:^(AFHTTPSessionManager *manager, NSError *error) {
                                 
                             } progress:^(float progress) {
                                 
                             }];
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.collectAPIManager) {
        params = @{
                   
                   };
    } else if (manager == self.unionIdAPIManager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.collectAPIManager)
    {
        
    }
    if (manager == self.unionIdAPIManager)
    {
        NSDictionary *responseDict = [manager fetchDataWithReformer:nil];
        unionId = responseDict[@"msg"][@"unionId"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?unionId=%@", self.newsDict[kBoxCenterCellDataKeyUrl], unionId]]]];
    }

}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{

}

#pragma mark - FSShareSheetDelegate
- (void)shareSheet:(FSShareSheet *)shareView clickedButtonAtIndex:(NSInteger)index
{
    UMSocialPlatformType shareType;
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *title = self.newsDict[kBoxCenterCellDataKeyTitle];
    NSString *description = self.newsDict[kBoxCenterCellDataKeyDescription];
    UIImage *image = [UIImage imageNamed:@"share_logo"];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:image];
    [shareObject setWebpageUrl:self.urlStr];
    messageObject.shareObject = shareObject;
    switch (index) {
        case 1:
            shareType = UMSocialPlatformType_QQ;
            [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:nil];
            break;
        case 2:
            shareType = UMSocialPlatformType_Qzone;
            [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:nil];
            break;
        case 3:
            shareType = UMSocialPlatformType_WechatSession;
            [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:nil];
            break;
        case 4:
            shareType = UMSocialPlatformType_WechatTimeLine;
            [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:nil];
            break;
        case 5:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.urlStr;
            [MBProgressHUD show:@"已复制" icon:@"box_center_more_complete" view:self.view];
        }
            break;
        case 6:
        {
            XBBoxSetTableViewController *tableViewController = [[XBBoxSetTableViewController alloc] init];
            tableViewController.officialId = self.officialConfigDict[kBoxContentCellDataKeyId];
            [self.navigationController pushViewController:tableViewController animated:YES];
        }
            break;
        case 7:
        {
            [self.collectAPIManager loadData];
            
            //这个的逻辑显示有问题
            [MBProgressHUD show:@"已收藏" icon:@"box_center_more_complete" view:self.view];
        }
            break;
        case 8:
        {
            XBMeFileTableViewController *tableViewController = [[XBMeFileTableViewController alloc] init];
            [self.navigationController pushViewController:tableViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickMoreBarButton
{
    FSShareSheet *shareSheet = [[FSShareSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil];
    [shareSheet show];
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = self.officialTitle;
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];

    UIButton *moreBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [moreBarButton setImage:[UIImage imageNamed:@"box_center_more"] forState:UIControlStateNormal];
    [moreBarButton addTarget:self action:@selector(clickMoreBarButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBarButton];
    [self.navigationItem setRightBarButtonItem:moreBarButtonItem];
}

#pragma mark - getter and setter
- (XBBoxCenterNewsCollectAPIManager *)collectAPIManager
{
    if (!_collectAPIManager)
    {
        _collectAPIManager = [[XBBoxCenterNewsCollectAPIManager alloc] init];
        _collectAPIManager.paramSource = self;
        _collectAPIManager.delegate = self;
    }
    return _collectAPIManager;
}

- (XBBoxUnionIdAPIManager *)unionIdAPIManager
{
    if (!_unionIdAPIManager)
    {
        _unionIdAPIManager = [[XBBoxUnionIdAPIManager alloc] init];
        _unionIdAPIManager.paramSource = self;
        _unionIdAPIManager.delegate = self;
    }
    return _unionIdAPIManager;
}

- (XBDownloadBottomView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[XBDownloadBottomView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-49-64, SCREENWIDTH, 49)];
        __weak typeof(_bottomView) weakBottomView = _bottomView;
        _bottomView.closeHandler = ^(){
            [weakBottomView removeFromSuperview];
        };
//        __weak typeof(filePathCopy) weakFilePath = filePathCopy;
        __weak typeof(self) weakSelf = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        _bottomView.progressHandler = ^(){
            XBFilePreviewController *previewController = [[XBFilePreviewController alloc] init];
            previewController.filePath = filePathCopy;
            [weakSelf.navigationController pushViewController:previewController animated:YES];
        };
#pragma clang diagnostic pop
    }
    return _bottomView;
}
@end

