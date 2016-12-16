//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "XBPersonInfoKey.h"
#import "XBPersonInfoDataCenter.h"
#import "UIButton+WebCache.h"

@interface UUMessageCell (){
    
    UIView *headImageBackView;
}

@property (nonatomic, assign) BOOL showDateLabel;
@end

@implementation UUMessageCell
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.showDateLabel = YES;
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
    
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}

- (void)btnContentClick{

        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    
}

//内容及Frame设置
- (void)configWithDict:(NSDictionary *)dict{
    NSNumber *fromId = [[[XBPersonInfoDataCenter sharedInstance] loadUser] objectForKey:MyStudentId_Key];
   
    NSNumber *showDateLabel = dict[@"shouldShowDate"];
    
    // 1、设置时间
    self.labelTime.text = dict[@"createdAt"];
    
    
    CGRect timeF = CGRectZero;

    //[self minuteOffSetStart:previousTime end:dict[@"createdAt"]];
    if ([showDateLabel isEqualToNumber:@1])
    {
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [dict[@"createdAt"] sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat timeX = (SCREENWIDTH - timeSize.width) / 2;
        timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
        //previousTime = dict[@"createdAt"];
    }
    self.labelTime.frame = timeF;
    
    // 2、设置头像
    CGRect iconF;
    CGFloat iconX = ChatMargin;

    if (fromId == dict[@"fromId"])
    {
        iconX = SCREENWIDTH - ChatMargin - ChatIconWH;
        NSURL *url = [NSURL URLWithString:[[XBPersonInfoDataCenter sharedInstance] loadUser][kPersonInfoAvatarUrl]];
        [self.btnHeadImage sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"login_logo"]];
    }
    else
    {
        
        [self.btnHeadImage sd_setImageWithURL:[NSURL URLWithString:self.headImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"login_logo"]];
    }
    CGFloat iconY = CGRectGetMaxY(timeF) + ChatMargin;
    iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    headImageBackView.frame = iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    
    


    // 4、设置内容
    CGRect contentF;
    CGFloat contentX = CGRectGetMaxX(iconF)+ChatMargin;
    CGFloat contentY = iconY;
    
    CGSize contentSize = [dict[@"content"] sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    if (fromId == dict[@"fromId"])
    {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }

    contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];

    self.btnContent.frame = contentF;
    
    if (fromId == dict[@"fromId"])
    {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    //背景气泡图
    UIImage *normal;
    if (fromId == dict[@"fromId"])
    {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];

    [self.btnContent setTitle:dict[@"content"] forState:UIControlStateNormal];
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

#pragma clang diagnostic pop
@end



