//
//  ILHttpTool.h
//  IELTSListening
//
//  Created by L on 15/4/10.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//  发送网络请求
//  对第三方网络请求框架的封装,避免第三方框架不可用风险
#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

//请求成功
typedef void(^AFFinishedBlock)(AFHTTPRequestOperation *oper,id responseObj);

//请求失败
typedef void(^AFFailedBlock)(AFHTTPRequestOperation *oper,NSError *error);

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);

@interface ILHttpTool : NSObject

/**
 *  发送get请求
 *
 *  @param url        请求的地址
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;


/**
 *  发送post请求
 *
 *  @param url        请求的地址
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;



+(void)requestWithUrlString:(NSString *)urlString finished:(AFFinishedBlock)finishedBlock failed:(AFFailedBlock)failedBlock;



#pragma mark 新添加（添加alertView 的错误的提示 2015年11月12日14:50:56）
+(void)errorAlertViewShow:(id)message;

#pragma mark md5 的加密
+ (NSString *)md5:(NSString *)str;




@end
