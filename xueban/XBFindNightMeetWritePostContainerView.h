//
//  XBFindNightMeetWritePostContainerView.h
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTMaterialSwitch.h"

@interface XBFindNightMeetWritePostContainerView : UIView

@property (nonatomic, strong) UITextView       *textView;
@property (nonatomic, strong) UILabel          *textNumLabel;
@property (nonatomic, strong) JTMaterialSwitch *jtSwitch;
@property (nonatomic, copy) void (^confirmHandler)();

@end
