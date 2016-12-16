//
//  WFTailoringViewController.h
//  WFPhotoPicker
//
//  Created by dang on 16/8/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WFTailoringViewControllerTailoredImageBlock)(UIImage *imgae);

@interface WFTailoringViewController : UIViewController

/** 传入的 id */
@property (nonatomic, strong) id asset;

@property (nonatomic, copy) WFTailoringViewControllerTailoredImageBlock tailoredImage;

@property (nonatomic, strong) UIImage *image;

@end
