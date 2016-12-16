//
//  XBWebViewController.h
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XBWebViewController : UIViewController

@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) CALayer *progressLayer;

@end
