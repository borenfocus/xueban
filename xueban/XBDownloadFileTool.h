//
//  XBDownloadFileTool.h
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface XBDownloadFileTool : NSObject

- (BOOL)ifHaveDownload:(NSString *)fileName;

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPSessionManager *manager, NSString *filePath))success
               downloadFailure:(void (^)(AFHTTPSessionManager *manager, NSError *error))failure
                      progress:(void (^)(float progress))progress;
@end
