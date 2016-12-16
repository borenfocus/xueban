//
//  XBNoDataView.m
//  xueban
//
//  Created by dang on 2016/10/28.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBNoDataView.h"

@interface XBNoDataView ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labelInfos;
@end

@implementation XBNoDataView

#pragma mark - 没有数据时的view
+(XBNoDataView*)configImageName:(NSString *)imageName withTitle:(NSString *)title {
    XBNoDataView *commonNoDataView = [[XBNoDataView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT-200)/2-80, SCREENWIDTH, 200)];
    
    commonNoDataView.imgName = imageName;
    commonNoDataView.labelTitle = title;
    
    return commonNoDataView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imgIcon];
        [self addSubview:self.labelInfos];
    }
    return self;
}

///根据string  font  width 获取Size
-(CGSize)getSizeOfContents:(NSString *)content Font:(UIFont*)font withWidth:(CGFloat)width withHeight:(CGFloat)height{
    
    CGSize size = CGSizeMake(width, height);
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

-(void)setImgName:(NSString *)imgName {
    if ([imgName isEqualToString:@""]) {
        _imgIcon.hidden = YES;
    } else {
        _imgIcon.hidden = NO;
        _imgIcon.image = [UIImage imageNamed:imgName];
    }
}

-(void)setLabelTitle:(NSString *)labelTitle {
    if ([labelTitle isEqualToString:@""]) {
        _labelInfos.hidden = YES;
    }else{
        _labelInfos.hidden = NO;
    }
    _labelInfos.text = labelTitle;
}

- (UIImageView*)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _imgIcon.center = CGPointMake(SCREENWIDTH/2, 20);
        _imgIcon.contentMode = UIViewContentModeScaleAspectFill;
        _imgIcon.clipsToBounds = YES;
    }
    return _imgIcon;
}

- (UILabel*)labelInfos {
    if (!_labelInfos) {
        _labelInfos = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, SCREENWIDTH, 20)];
        _labelInfos.font = [UIFont systemFontOfSize:16.0];
        _labelInfos.textColor = [UIColor colorWithHexString:@"969696"];
        _labelInfos.textAlignment = NSTextAlignmentCenter;
    }
    return _labelInfos;
}

@end
