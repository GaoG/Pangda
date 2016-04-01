//
//  ILShowAlertViewMsg.h
//  IELTSListening
//
//  Created by L on 15/4/21.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILShowAlertViewMsg : NSObject

/**
 *  显示错误信息
 *
 *  @param errorMsg 错误信息的内容 带虚假震动效果
 */
+ (void)showError:(NSString *)errorMsg titleName:(NSString *)titileName WithView:(UIView *)view;

/**
 *  显示正确信息
 *
 *  @param successMsg 正确信息的内容
 */
+ (void)showSuccess:(NSString *)successMsg titleName:(NSString *)titileName;

@end
