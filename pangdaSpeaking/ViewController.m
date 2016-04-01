//
//  ViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/18.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ViewController.h"
#import "DEFINEH.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0  blue:250/255.0  alpha:1];
    
// 设置导航栏的颜色 和透明名度
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:0.05];
    
}

//设置titleView
- (void)addTitleViewWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,40)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor= RGBA;
    label.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = label;
}


// 设置导航栏的左按钮 或 右按钮
-(void)addItemWithImageData:(UIImage*)img andHightImage
:(UIImage *)himage andFrame:(CGRect)frame selector:(SEL)selector location:(BOOL)isLeft
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:himage forState:UIControlStateHighlighted];
    btn.frame=frame;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//    btn.layer.cornerRadius=frame.size.height/2;
//    btn.layer.masksToBounds=YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft == YES) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
    
}


-(void)addItemWithTitle:(NSString *)title imageName:(NSString *)imageName andFrame:(CGRect)frame selector:(SEL)selector location:(BOOL)isLeft
{
    UIImage *imag=[UIImage imageNamed:imageName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setFrame:frame];
    [btn setBackgroundImage:imag forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft == YES) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
    
}


-(UISegmentedControl*)segControlWithTitle:(NSArray*)titleArr frame:(CGRect)frame selectIndex:(NSInteger)index color:(UIColor *)color
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:81/255.0 blue:20/255.0 alpha:1],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    UISegmentedControl* _navName=[[UISegmentedControl alloc]initWithItems:titleArr];
    _navName.tintColor=color;
    _navName.selectedSegmentIndex=index;
    [_navName setTitleTextAttributes:dic forState:UIControlStateNormal];
    _navName.frame=frame;
    return _navName;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
