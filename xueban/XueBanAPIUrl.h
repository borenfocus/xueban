//
//  XueBanAPIUrl.h
//  CTNetworking
//
//  Created by dang on 16/6/9.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#ifndef XueBanAPIUrl_h
#define XueBanAPIUrl_h
/*************极光推送************/
//设置别名
#define kNetPath_SetAlias @""
/***************教务***************/
// 登录
#define kNetPath_Register @""
// 注册 (注意这里在登录界面调用register接口)
#define kNetPath_Login @""
// 获取考试安排
#define kNetPath_Exam @""
// 获取课表
#define kNetPath_Curriculum @""
// 获取个人信息
//#define kNetPath_PersonInfo @""
// 获取全部成绩
#define kNetPath_AllScore @""
// 获取本学期成绩
#define kNetPath_TermScore @""

/***************动态*****************/
//全局搜索
#define kNetPath_Search @""
//得到公众号列表
#define kNetPath_Official_List @""
//得到更多公众号推荐列表
#define kNetPath_Official_More @""
//得到一个公众号的信息
#define kNetPath_Official_Info @""
//得到一个订阅号的新闻列表
#define kNetPath_Official_News @""
//关注/取消关注公众号
#define kNetPath_Official_Concern @""
//接受/取消公众号推送
#define kNetPath_Official_Notify @""
//获取unionId
#define kNetPath_Official_UnionId @""
//访问一个功能号 (请求http)
#define kNetPath_Official_Func @""
//收藏
#define kNetPath_Official_Collect @""

/***************图书馆***************/
//设置图书馆密码
#define kNetPath_SetLibraryPassword @""
//得到用户的图书馆个人信息
#define kNetPath_LibPersonInfo @""
//得到当前借阅信息
#define kNetPath_BorrowInfo @""
//得到一本书的详细信息
#define kNetPath_BookDetail @""
//搜书
#define kNetPath_SearchBook @""

/***************社交***************/
//得到随机的同乡
#define kNetPath_Social_Townee @""
//得到随机的同校同学
#define kNetPath_Social_Classmate @""
//头像上传
#define kNetPath_Social_Upload @""
//发送一条私聊消息
#define kNetPath_PrivateLetter_Send @""
//得到用户的所有聊过天的对象列表
#define kNetPath_PrivateLetter_List @""
//得到与某个人聊天的内容
#define kNetPath_PrivateLetter_Content @""
/***************卧谈会***************/
//获取帖子
#define kNetPath_NightMeetPosts @""
//获取帖子的详细数据
#define kNetPath_NightMeetPostDetail @""
//发表帖子
#define kNetPath_NightMeetWritePost @""
//给帖子评论
#define kNetPath_NightMeetCommentPost @""
//给帖子点赞或取消点赞
#define kNetPath_NightMeetZanPost @""

/***************我的***************/
//与我相关
#define kNetPath_Me_About @""
//我的收藏
#define kNetPath_Me_Collection @""
//帮助与反馈
#define kNetPath_Feedback @""

#endif /* XueBanAPIUrl_h */
