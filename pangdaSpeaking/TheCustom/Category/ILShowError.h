//
//  ILShowError.h
//  IELTSListening
//
//  Created by L on 15/4/20.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILShowError : NSObject

/**
 *  显示错误信息
 *
 *  @param errorMsg 错误信息的内容
 */
+ (void)showError:(NSString *)errorMsg titleName:(NSString *)titileName WithView:(UIView *)view;

@end
