//
//  ILShowAlertViewMsg.m
//  IELTSListening
//
//  Created by L on 15/4/21.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILShowAlertViewMsg.h"

@implementation ILShowAlertViewMsg

/**
 *  显示错误信息
 *
 *  @param errorMsg 错误信息的内容 带虚假震动效果
 */
+ (void)showError:(NSString *)errorMsg titleName:(NSString *)titileName WithView:(UIView *)view
{
    // 1.弹框提醒
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titileName message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    // 2.抖动
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.15;
    CGFloat delta = 10;
    shakeAnim.values = @[@0, @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 2;
    [view.layer addAnimation:shakeAnim forKey:nil];
}

/**
 *  显示正确信息
 *
 *  @param successMsg 正确信息的内容
 */
+ (void)showSuccess:(NSString *)successMsg titleName:(NSString *)titileName{
    // 弹框提醒
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:successMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

@end
