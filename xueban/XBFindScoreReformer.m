//
//  XBFindScoreReformer.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindScoreReformer.h"
#import "XBFindScoreTableViewCellDataKey.h"
#import "XBFindScoreAPIManager.h"

NSString * const kFindScoreTableViewCellDataKeyName = @"Name";
NSString * const kFindScoreTableViewCellDataKeyType = @"Type";
NSString * const kFindScoreTableViewCellDataKeyScore = @"Score";
NSString * const kFindScoreTableViewCellDataKeyCredit = @"Credit";
NSString * const kFindScoreTableViewCellDataKeyStatus = @"Status";
NSString * const kFindScoreTableViewCellDataKeyState = @"State";

typedef NS_ENUM(NSUInteger, ScoreState) {
    ScoreStateUpdate = 0,
    ScoreStateNoScore = 1,
    ScoreStateHadScore = 2
};

@implementation XBFindScoreReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[XBFindScoreAPIManager class]]) {
        NSMutableArray *resultArr = [NSMutableArray array];
        NSArray *newScoreList = data[@"msg"][@"score"];
        NSArray *newScoreListCopy = [[NSArray alloc] initWithArray:newScoreList];
        NSArray *oldScoreList = [[NSUserDefaults standardUserDefaults] objectForKey:MyScore_Key];
        
        //存入
        NSSortDescriptor *scoreDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[newScoreList sortedArrayUsingDescriptors:@[scoreDescriptor]] forKey:MyScore_Key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSPredicate *containPred = [NSPredicate predicateWithFormat:@"SELF in %@", oldScoreList];
        NSPredicate *notContainPred = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", oldScoreList];
        
        NSMutableArray *containScoreList = [[NSMutableArray alloc] initWithArray:[newScoreList filteredArrayUsingPredicate:containPred]];
        NSArray *notContainScoreList =
        [newScoreListCopy filteredArrayUsingPredicate:notContainPred];
        [notContainScoreList enumerateObjectsUsingBlock:^(NSMutableDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[dict objectForKey:@"Score"] isEqualToString:@""]) {
                [dict setObject:[NSNumber numberWithInteger:ScoreStateNoScore] forKey:@"State"];
            } else {
                [dict setObject:[NSNumber numberWithInteger:ScoreStateUpdate] forKey:@"State"];
            }
        }];
        [containScoreList enumerateObjectsUsingBlock:^(NSMutableDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[dict objectForKey:@"Score"] isEqualToString:@""]) {
                [dict setObject:[NSNumber numberWithInteger:ScoreStateNoScore] forKey:@"State"];
            } else {
                [dict setObject:[NSNumber numberWithInteger:ScoreStateHadScore] forKey:@"State"];
            }
        }];
        [containScoreList addObjectsFromArray:notContainScoreList];
        
        NSSortDescriptor *stateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"State" ascending:YES];
        NSArray *sortedScoreList = [containScoreList sortedArrayUsingDescriptors:@[stateDescriptor, scoreDescriptor]];

        [sortedScoreList enumerateObjectsUsingBlock:^(NSDictionary *scoreItemDict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *typeStr = [NSString stringWithFormat:@"类型 : %@", scoreItemDict[kFindScoreTableViewCellDataKeyType]];
            NSString *scoreStr = [NSString stringWithFormat:@"分数 : %@", scoreItemDict[kFindScoreTableViewCellDataKeyScore]];
            NSString *creditStr = [NSString stringWithFormat:@"学分 : %@", scoreItemDict[kFindScoreTableViewCellDataKeyCredit]];
            NSString *statusStr;
            if ([scoreItemDict[kFindScoreTableViewCellDataKeyScore] isEqual:@""]) {
                statusStr = @"状态 : 暂未公布成绩";
                if (SCREENHEIGHT < 667) {
                    statusStr = @"状态 : 暂未公布";
                }
            } else {
                if ([scoreItemDict[kFindScoreTableViewCellDataKeyScore] integerValue] >= 60) {
                    statusStr = @"状态 : 已通过";
                } else if ([scoreItemDict[kFindScoreTableViewCellDataKeyScore] isEqualToString:@"通过"]) {
                    statusStr = @"状态 : 通过";
                } else {
                    statusStr = @"状态 : 未通过";
                }
            }
            NSDictionary *resultDict = @{
                                             kFindScoreTableViewCellDataKeyName : scoreItemDict[kFindScoreTableViewCellDataKeyName],
                                             kFindScoreTableViewCellDataKeyType : typeStr,
                                             kFindScoreTableViewCellDataKeyScore : scoreStr,
                                             kFindScoreTableViewCellDataKeyCredit : creditStr,
                                             kFindScoreTableViewCellDataKeyStatus : statusStr,
                                             kFindScoreTableViewCellDataKeyState : scoreItemDict[kFindScoreTableViewCellDataKeyState]
                                         };
            [resultArr addObject:resultDict];
        }];
        return [resultArr copy];
    }
    return nil;
}
@end
