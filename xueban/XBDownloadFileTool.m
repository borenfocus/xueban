//
//  XBDownloadFileTool.m
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBDownloadFileTool.h"

@implementation XBDownloadFileTool

- (BOOL)ifHaveDownload:(NSString *)fileName
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * fileList = [userDefaults objectForKey:MyFileList_Key];
    for (NSInteger i = 0; i < [fileList count]; i ++) {
        if ([fileName isEqual:[fileList objectAtIndex:i]]) {
            return YES;
        }
    }
    return NO;
}

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPSessionManager *manager, NSString *filePath))success
               downloadFailure:(void (^)(AFHTTPSessionManager *manager, NSError *error))failure
                      progress:(void (^)(float progress))progress {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSArray * documentPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [documentPaths objectAtIndex:0];

    NSString * filePath = [documentPath stringByAppendingPathComponent:savedPath];
    
    //4. 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        float p = downloadProgress.completedUnitCount / (downloadProgress.totalUnitCount / 1.0);
        progress(p);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载地址
        NSLog(@"默认下载地址:%@  \n\n",targetPath);
        
        //设置下载路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成调用的方法 , response数据和error都是这样 , filePath 是destination返回的下载路径
        NSLog(@"下载完成 %@", filePath);
    
        NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:MyFileList_Key]];
        [arr insertObject:savedPath atIndex:0];
        [userDefaults setObject:[arr copy] forKey:MyFileList_Key];
        [userDefaults synchronize];
        
        success(manager, [filePath absoluteString]);
    }];
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"setDownloadTaskDidWriteDataBlock: %lld %lld %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    //5. 开始启动任务, 这个是必须.
    [task resume];
    
}

@end
