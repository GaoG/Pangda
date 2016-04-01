//
//  ViewController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/18.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//设置titleView
- (void)addTitleViewWithTitle:(NSString *)title;


// 设置导航栏的左按钮 或 右按钮
-(void)addItemWithImageData:(UIImage*)img
              andHightImage:(UIImage *)himage
                   andFrame:(CGRect)frame
                   selector:(SEL)selector
                   location:(BOOL)isLeft;


-(void)addItemWithTitle:(NSString *)title
              imageName:(NSString *)imageName
               andFrame:(CGRect)frame
               selector:(SEL)selector
               location:(BOOL)isLeft;



-(UISegmentedControl*)segControlWithTitle:(NSArray*)titleArr
                                    frame:(CGRect)frame
                              selectIndex:(NSInteger)index
                                    color:(UIColor *)color;

@end

