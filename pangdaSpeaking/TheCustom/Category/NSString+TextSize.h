//
//  NSString+TextSize.h
//  IELTSListening
//
//  Created by L on 15/4/10.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TextSize)
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;
@end
