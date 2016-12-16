
//
//  XBFindNightMeetWritePostViewController.m
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetWritePostViewController.h"
#import "XBFindNightMeetWritePostContainerView.h"
#import "XBFindNightMeetWritePostAPIManager.h"
#define MAX_LIMIT_NUMS 140

extern NSString *const kNightMeetDidWritePostNotification;

@interface XBFindNightMeetWritePostViewController ()<UITextViewDelegate, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) XBFindNightMeetWritePostContainerView *containerView;
@property (nonatomic, strong) XBFindNightMeetWritePostAPIManager *writePostAPIManager;

@end

@implementation XBFindNightMeetWritePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.view addSubview:self.containerView];
    [self initNavigationItem];
    [self actionHandler];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"卧谈会发帖"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"卧谈会发帖"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionHandler {
    __weak typeof(self) weakSelf = self;
    _containerView.confirmHandler = ^(){
        [weakSelf.writePostAPIManager loadData];
    };
}

#pragma mark - 限制输入字数(最多不超过140个字)
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_LIMIT_NUMS)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc)
            {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _containerView.textNumLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}

#pragma mark - 显示当前可输入字数/总字数
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos)
    {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //不让显示负数
    _containerView.textNumLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"你想说点什么？..."])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"你想说点什么？...";
        textView.textColor = [UIColor colorWithHexString:@"969696"];
    }
    [textView resignFirstResponder];
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    if (manager == self.writePostAPIManager)
    {
        NSDictionary *params = @{
                                 
                                 };
        return params;
    }
    return @{};
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.writePostAPIManager)
    {
        [_containerView.textView resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNightMeetDidWritePostNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.writePostAPIManager)
    {
        
    }
}

#pragma mark - event response
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initNavigationItem
{
    self.title = @"发帖";
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 24.0f, 24.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

#pragma mark - getter and setter
- (XBFindNightMeetWritePostContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[XBFindNightMeetWritePostContainerView alloc] initWithFrame:self.view.frame];
         _containerView.textView.delegate = self;
    }
    return _containerView;
}

- (XBFindNightMeetWritePostAPIManager *)writePostAPIManager {
    if (_writePostAPIManager == nil) {
        _writePostAPIManager = [[XBFindNightMeetWritePostAPIManager alloc] init];
        _writePostAPIManager.delegate = self;
        _writePostAPIManager.paramSource = self;
    }
    return _writePostAPIManager;
}
@end
