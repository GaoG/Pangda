//
//  NSString+Hash.h
//  IELTSListening
//
//  Created by L on 15/4/14.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

/**
 *  计算MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 -s "string"
 *  @endcode
 *
 *  <p>提示：随着 MD5 碰撞生成器的出现，MD5 算法不应被用于任何软件完整性检查或代码签名的用途。<p>
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)md5String;

@end
