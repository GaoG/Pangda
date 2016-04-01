//
//  UIColor+ColorWithHex.h
//  AnshangAppStore
//
//  Created by king on 14-5-7.
//  Copyright (c) 2014年 anshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHex)

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

@end
