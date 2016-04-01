//
//  NSString+Path.h
//  IELTSListening
//
//  Created by L on 15/4/10.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

/**
*  获取文档目录
*/
+ (NSString *)documentPath;

/**
 *  获取缓存目录
 */
+ (NSString *)cachePath;

/**
 *  获取临时目录
 */
+ (NSString *)tempPath;

/**
 *  添加文档路径
 */
- (NSString *)appendDocumentPath;

/**
 *  添加缓存路径
 */
- (NSString *)appendCachePath;

/**
 *  添加临时路径
 */
- (NSString *)appendTempPath;

@end
