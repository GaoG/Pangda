//
//  GeneralHelper.h
//  ArrangeCoach_user
//
//  Created by JC_Hu on 14/12/19.
//  Copyright (c) 2014年 资岩 周. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface GeneralHelper : NSObject


/*
 *  用正则判断密码，是否6－20位
 */
+ (BOOL) checkInputPassword:(NSString *)text;




/*
 *  用正则判断手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;





@end
