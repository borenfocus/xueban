//
//  QRReaderViewController.m
//  YunWan
//
//  Created by 张威 on 15/1/26.
//  Copyright (c) 2015年 ZhangWei. All rights reserved.
//

#import "QRReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import "XBGrantAlertView.h"
#import "XBSettingGranteView.h"
#import "XBCheckGrantTool.h"

@import AVFoundation;
@import Photos;
@interface QRReaderViewController() <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XBGrantAlertViewDelegate>
{
    BOOL isFirstLoad;
}
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) NSTimer *scanLineTimer;

@end

@implementation QRReaderViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [XBProgressHUD showHUDAddedTo:self.view];
    [self initViewAndSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma clang diagnostic pop
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstLoad == NO) {
        [self checkCameraGrante];
        isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIApplication *application = [UIApplication sharedApplication];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [application setStatusBarHidden:NO];
#pragma clang diagnostic pop
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

//此方法是在识别到QRCode并且完成转换，如果QRCode的内容越大，转换需要的时间就越长。
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    // 1如果扫描完成，停止会话
    [self.session stopRunning];
    //2删除预览图层
    [self.previewLayer removeFromSuperlayer];
    //设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([self.QRDelegate respondsToSelector:@selector(didFinishedReadingQR:)]) {
            [self.QRDelegate didFinishedReadingQR:obj.stringValue];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
#pragma clang diagnostic pop
        }
    }];
}

#pragma mark - XBCameraGranteViewDelegate
- (void)didClickGranteConfirmButton:(XBGrantAlertViewType)type {
    if (type == XBGrantAlertViewTypeCamera) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted)
                {
                    // 用户授权
                    [self openCamera];
                }
                else
                {
                    // 用户拒绝授权
                    // DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                    //[self presentViewController:vc animated:YES completion:nil];
                }
            });
        }];
    } else if (type == XBGrantAlertViewTypePhotoLibrary) {
        // 系统弹出授权对话框
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                {
                    // 用户拒绝，跳转到自定义提示页面
//                    DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
//                    [self presentViewController:vc animated:YES completion:nil];
                }
                else if (status == PHAuthorizationStatusAuthorized)
                {
                    // 用户授权，弹出相册对话
                    [self openPhotoLibrary];
                }
            });
        }];
    }
}

#pragma mark - private method
- (void)initViewAndSubViews {
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = mainBounds;
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - 80, readerFrame.size.width - 80);
    CGRect scanCrop =
    CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
               (readerFrame.size.height - viewFinderSize.height)/2,
               viewFinderSize.width,
               viewFinderSize.height);
    
    /* 画一个取景框开始 */
    // 正方形取景框的边长
    CGFloat edgeWidth = 18.0f;
    CGFloat edgeHeight = 16.0f;
    
    UIImageView *topLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  edgeWidth, edgeHeight)];
    topLeft.image = [UIImage imageNamed:@"qr_top_left.png"];
    [self.view addSubview:topLeft];
    
    UIImageView *topRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeWidth,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  edgeWidth, edgeHeight)];
    topRight.image = [UIImage imageNamed:@"qr_top_right.png"];
    [self.view addSubview:topRight];
    
    UIImageView *bottomLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeWidth,
                                                  edgeWidth, edgeHeight)];
    bottomLeft.image = [UIImage imageNamed:@"qr_bottom_left"];
    [self.view addSubview:bottomLeft];
    
    UIImageView *bottomRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeWidth,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeWidth,
                                                  edgeWidth, edgeHeight)];
    bottomRight.image = [UIImage imageNamed:@"qr_bottom_right"];
    [self.view addSubview:bottomRight];
    
    UIView *topLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             viewFinderSize.width+2, 1)];
    topLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLine];
    
    UIView *bottomLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height + viewFinderSize.height)/2,
                                             viewFinderSize.width+2, 1)];
    bottomLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomLine];
    
    UIView *leftLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             1, viewFinderSize.height+2)];
    leftLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:leftLine];
    
    UIView *rightLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             1, viewFinderSize.height+2)];
    rightLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:rightLine];
    
    self.scanLineImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - 230)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  230, 10)];
    self.scanLineImageView.image = [UIImage imageNamed:@"qr_scan_line"];
    
    [self.view addSubview:self.scanLineImageView];
    
    /* 画一个取景框结束 */
    
    /* 配置取景框之外颜色开始 */
    // scanCrop
    UIView *viewTopScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainBounds.size.width, scanCrop.origin.y)];
    
    UIView *viewBottomScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y+scanCrop.size.height,
                                             mainBounds.size.width,
                                             mainBounds.size.height - scanCrop.size.height - scanCrop.origin.y)];
    
    UIView *viewLeftScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y, scanCrop.origin.x, scanCrop.size.height)];
    
    UIView *viewRightScan =
    [[UIView alloc] initWithFrame:CGRectMake(scanCrop.origin.x + scanCrop.size.width,
                                             scanCrop.origin.y,
                                             mainBounds.size.width - scanCrop.origin.x - scanCrop.size.width,
                                             scanCrop.size.height)];
    viewTopScan.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    viewBottomScan.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    viewLeftScan.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    viewRightScan.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self.view addSubview:viewTopScan];
    [self.view addSubview:viewBottomScan];
    [self.view addSubview:viewLeftScan];
    [self.view addSubview:viewRightScan];
    
    /* 配置取景框之外颜色结束 */
    
    // 返回键
    UIButton *goBackButton = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
        [button setBackgroundImage:[UIImage imageNamed:@"qr_vc_back"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:goBackButton];
    
    // 打开相册
    UIButton *torchSwitch = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(mainBounds.size.width-44-10, 30, 30, 30)];
        [button setBackgroundImage:[UIImage imageNamed:@"qr_album"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickPhotoLibraryButton) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:torchSwitch];
    
    
    self.infoLabel =
    [[UILabel alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                              (readerFrame.size.height + viewFinderSize.height)/2 + 20,
                                              viewFinderSize.width, 30)];
    self.infoLabel.text = @"将二维码放入框内，即可自动扫描";
    self.infoLabel.font = [UIFont systemFontOfSize:13.0];
    self.infoLabel.layer.cornerRadius = self.infoLabel.frame.size.height / 2;
    self.infoLabel.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.infoLabel];
    self.view.backgroundColor = [UIColor blackColor];
}

#define LINE_SCAN_TIME  3.0     // 扫描线从上到下扫描所历时间（s）

- (void)createTimer {
    self.scanLineTimer =
    [NSTimer scheduledTimerWithTimeInterval:LINE_SCAN_TIME
                                     target:self
                                   selector:@selector(moveUpAndDownLine)
                                   userInfo:nil
                                    repeats:YES];
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(self.view.frame.size.width - 80, self.view.frame.size.width - 80);
    
    CGRect scanLineframe = self.scanLineImageView.frame;
    scanLineframe.origin.y =
    (readerFrame.size.height - viewFinderSize.height)/2;
    self.scanLineImageView.frame = scanLineframe;
    self.scanLineImageView.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
                     animations:^{
                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
                         scanLineframe.origin.y =
                         (readerFrame.size.height + viewFinderSize.height)/2 -
                         weakSelf.scanLineImageView.frame.size.height;
                         
                         weakSelf.scanLineImageView.frame = scanLineframe;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.scanLineImageView.hidden = YES;
                     }];
}

- (void)checkCameraGrante {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 应用第一次申请权限调用这里
        if ([XBCheckGrantTool isCameraNotDetermined])
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBGrantAlertView *grantAlertView = [[XBGrantAlertView alloc] initWithFrame:window.frame];
            grantAlertView.delegate = self;
            grantAlertView.alertViewType = XBGrantAlertViewTypeCamera;
            [window addSubview:grantAlertView];
            [UIView animateWithDuration:0.2f animations:^{
                grantAlertView.alpha = 1.0f;
            }];
        }
        // 用户已经拒绝访问摄像头
        else if ([XBCheckGrantTool isCameraDenied])
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBSettingGranteView *settingGranteView = [[XBSettingGranteView alloc] initWithFrame:window.frame];
            settingGranteView.settingType = XBSettingGranteViewTypeCamera;
            [window addSubview:settingGranteView];
            [UIView animateWithDuration:0.2f animations:^{
                settingGranteView.alpha = 1.0f;
            }];
        }
        // 用户允许访问摄像头
        else
        {
            [self openCamera];
        }
    }
    else
    {
        NSLog(@"当前设备不支持摄像头，比如模拟器");
    }
}

- (void)checkPhotoLibraryGrant {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // 第一次安装App，还未确定权限，调用这里
        if ([XBCheckGrantTool isPhotoLibraryNotDetermined])
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBGrantAlertView *grantAlertView = [[XBGrantAlertView alloc] initWithFrame:window.frame];
            grantAlertView.delegate = self;
            grantAlertView.alertViewType = XBGrantAlertViewTypePhotoLibrary;
            [window addSubview:grantAlertView];
            [UIView animateWithDuration:0.2f animations:^{
                grantAlertView.alpha = 1.0f;
            }];
        }
        else if ([XBCheckGrantTool isPhotoLibraryDenied])
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            XBSettingGranteView *settingGranteView = [[XBSettingGranteView alloc] initWithFrame:window.frame];
            settingGranteView.settingType = XBSettingGranteViewTypePhotoLibrary;
            [window addSubview:settingGranteView];
            [UIView animateWithDuration:0.2f animations:^{
                settingGranteView.alpha = 1.0f;
            }];
        }
        else
        {
            // 已经授权，跳转到相册页面
            [self openPhotoLibrary];
        }
    }
    else
    {
        // 当前设备不支持打开相册
        NSLog(@"当前设备不支持相册");
    }
}

- (void)openCamera {
    CGRect readerFrame = [[UIScreen mainScreen] bounds];
    CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - 80, readerFrame.size.width - 80);
    /**********************************摄像头开始**********************************/
    // 1 实例化摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // An AVCaptureDevice object abstracts a physical capture device that provides input data (such as audio or video) to an AVCaptureSession object.
    
    // 2 设置输入,把摄像头作为输入设备
    // 因为模拟器是没有摄像头的，因此在此最好做个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头%@", error.localizedDescription);
        return;
    }
    
    // 3 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    CGRect scanCrop =
    CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
               (readerFrame.size.height - viewFinderSize.height)/2,
               viewFinderSize.width,
               viewFinderSize.height);
    
    outPut.rectOfInterest =
    CGRectMake(scanCrop.origin.y/readerFrame.size.height,
               scanCrop.origin.x/readerFrame.size.width,
               scanCrop.size.height/readerFrame.size.height,
               scanCrop.size.width/readerFrame.size.width
               );
    
    // 3.1 设置输出的代理
    // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验。
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    // 4.1 设置输出的格式
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 5 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // AVCaptureVideoPreviewLayer -- to show the user what a camera is recording
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2设置preview图层的大小
    
    [preview setFrame:self.view.bounds];
    //5.3将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    self.session = session;
    
    [XBProgressHUD hideHUDForView:self.view];
    
    /**********************************摄像头结束**********************************/
    [self.session startRunning];
    if (self.scanLineTimer == nil) {
        [self moveUpAndDownLine];
        [self createTimer];
    }
}

- (void)openPhotoLibrary {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.navigationBar.tintColor = [UIColor blackColor];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - event response
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 打开相册
- (void)clickPhotoLibraryButton {
    [self checkPhotoLibraryGrant];
}

@end
