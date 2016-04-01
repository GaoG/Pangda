//
//  ILFileDownloader.h
//  IELTSListening
//
//  Created by L on 15/4/18.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//  一个ILFileDownloader专门下载一个文件

#import <Foundation/Foundation.h>

@interface ILFileDownloader : NSObject

/**
 * 所需要下载文件的远程URL(连接服务器的路径)
 */
@property (nonatomic, copy) NSString *url;
/**
 * 文件的存储路径(文件下载到什么地方)
 */
@property (nonatomic, copy) NSString *destPath;

/**
 * 是否正在下载(有没有在下载, 只有下载器内部才知道)
 */
@property (nonatomic, readonly, getter = isDownloading) BOOL downloading;


/**
 * 用来监听下载完毕
 */
@property (nonatomic, copy) void (^completionHandler)(NSString *str);
/**
 * 用来监听下载失败
 */
@property (nonatomic, copy) void (^failureHandler)(NSError *error);

/**
 * 开始(恢复)下载
 */
- (void)start;

/**
 * 暂停下载
 */
- (void)pause;

/**
 * 判断地址是否存在
 */

- (BOOL)isOrNoTherLocation:(NSString *)str;






@end
