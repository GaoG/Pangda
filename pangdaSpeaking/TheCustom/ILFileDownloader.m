
//
//  ILFileDownloader.m
//  IELTSListening
//
//  Created by L on 15/4/18.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILFileDownloader.h"
#import "ILHttpTool.h"
#import "MBProgressHUD.h"
@interface ILFileDownloader() <NSURLConnectionDataDelegate>
/**
 * 连接对象
 */
@property (nonatomic, strong) NSURLConnection *conn;

@property (nonatomic, strong)NSMutableData *audioData;
@end

@implementation ILFileDownloader{


}



/**
 * 判断地址是否存在
 */
- (BOOL)isOrNoTherLocation:(NSString *)str{


    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@.mp3",cachePath,mp3Location,[ILHttpTool md5:str]];
    
    if([fileManager fileExistsAtPath:filePath]){
    
        NSLog(@"cunzai");
        
        return YES;
        
    } else{
    
        return NO;
    }
    
    return nil;

}


/**
 * 开始(恢复)下载，开启异步线程实现下载
 */
- (void)start
{
    
    
    
    
   dispatch_async(dispatch_get_main_queue(), ^{
       
       
       
       NSString *playString = self.url;
       
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:playString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
       
       NSURLConnection *coon = [NSURLConnection connectionWithRequest:request delegate:self];
       [coon start];
       self.audioData = [NSMutableData data];
 
   });
    
}

/**
 * 暂停下载
 */
- (void)pause
{
    //暂停时讲链接对象取消
    [self.conn cancel];
    self.conn = nil;
    //将下载状态设置为no
    _downloading = NO;
}

#pragma mark - NSURLConnectionDataDelegate 代理方法
/**
 *  1. 当接受到服务器的响应(连通了服务器)就会调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"^^^^^^^^6^^^%@",[res allHeaderFields]);
}

/**
 *  2. 当接受到服务器的数据就会调用(可能会被调用多次, 每次调用只会传递部分数据)
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.audioData appendData:data];
    
}

/**
 *  3. 当服务器的数据接受完毕后就会调用
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    
    [self writeJsonToLocalplayDocument:self.audioData ];
    
   

}

- (void)writeJsonToLocalplayDocument:(NSData *)data
{
    //2.获取文件存储的文件夹（Documents、Library、Caches、Tmp）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *playUrl = [cachePath stringByAppendingPathComponent:mp3Location];
    [fileManager createDirectoryAtPath:playUrl withIntermediateDirectories:YES attributes:nil error:nil];
    //4.将数据写入文件并按照文件路径存储
    

//    NSString *filename = [playUrl stringByAppendingPathComponent:@"AStreet2.mp3"];
    
    NSString * tempName = [NSString stringWithFormat:@"%@.mp3",[ILHttpTool md5:_url]];
    NSString *filename = [playUrl stringByAppendingPathComponent:tempName];
   
    [data writeToFile:filename atomically:YES];
    
    if (self.completionHandler) {
         self.completionHandler(filename);
    }
    
   
    
}




/**
 *  请求错误(失败)的时候调用(请求超时\断网\没有网, 一般指客户端错误)
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.completionHandler) {
        self.completionHandler(@"no");
    }
    
    
    [ILShowAlertViewMsg showError:@"读取失败" titleName:@"提示" WithView:[[UIApplication sharedApplication]keyWindow]];

    
    if (self.failureHandler) {
        self.failureHandler(error);
    }
}



@end
