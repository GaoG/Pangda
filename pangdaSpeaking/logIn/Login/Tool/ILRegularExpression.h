//
//  ILRegularExpression.h
//  IELTSListening
//
//  Created by L on 15/4/21.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//  正则表达式

#import <Foundation/Foundation.h>

@interface ILRegularExpression : NSObject

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

@end
