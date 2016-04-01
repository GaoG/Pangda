//
//  ILHttpTool.m
//  IELTSListening
//
//  Created by L on 15/4/10.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILHttpTool.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ILHttpTool
/**
 *  发送get请求
 *
 *  @param url        请求的地址
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure
{
    // 1.创建AFN管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.发送网络请求
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  发送post请求
 *
 *  @param url        请求的地址
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure
{
    // 1.创建AFN管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 3.发送网络请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}


+(void)requestWithUrlString:(NSString *)urlString finished:(AFFinishedBlock)finishedBlock failed:(AFFailedBlock)failedBlock;{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:finishedBlock failure:failedBlock];
}



#pragma mark 新添加（添加alertView 的错误的提示 2015年11月12日14:50:56）
+(void)errorAlertViewShow:(id)message{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",message] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    
    [alert show];
}


#pragma mark md5 的加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
