//
//  CustomTabBar.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/21.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedBlock)(NSInteger index);
@interface CustomTabBar : UIView
//扩展初始化方法，传入带有图片名称的dic 和block
- (id)initWithFrame:(CGRect)frame imageDic:(NSDictionary *)dic selected:(SelectedBlock)block;
@end
