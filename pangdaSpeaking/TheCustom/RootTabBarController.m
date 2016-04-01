//
//  RootTabBarController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/20.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "RootTabBarController.h"
#import "MeViewController.h"
#import "JiJingViewController.h"
#import "VideoViewController.h"
#import "CustomTabBar.h"
@interface RootTabBarController (){


    CustomTabBar*tabBar;


}

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViewControllers];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideTabBar:) name:@"hideTabBar" object:nil];
    
    
}


////支持旋转
//-(BOOL)shouldAutorotate{
//    return YES;
//}
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}


-(void)createViewControllers
{
//    机经
    UINavigationController*nav_jiJing=[[UINavigationController alloc]initWithRootViewController:[[JiJingViewController alloc]init]];
    
    //视频
    VideoViewController*videoVC=[[VideoViewController alloc]init];
    UINavigationController*nav_video=[[UINavigationController alloc]initWithRootViewController:videoVC];
    
   
    //我的
    UINavigationController*nav_me=[[UINavigationController alloc]initWithRootViewController:[[MeViewController alloc]init]];
    
    
    self.viewControllers=@[nav_jiJing,nav_video,nav_me];
    // self.viewControllers=@[nav_school,nav_video,nav_find];
    UITabBar*tabbart=self.tabBar;
    UITabBarItem*tabbarItem1=[tabbart.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabbart.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabbart.items objectAtIndex:2];

    tabbarItem1.selectedImage = [[UIImage imageNamed:@"tab_jijing_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabbarItem1.image = [[UIImage imageNamed:@"tab_jijing_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//     tabbarItem1.imageInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    tabbarItem1.title = @"机经";
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"tab_video_h"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"tab_video_n"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabBarItem2.imageInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    tabBarItem2.title = @"视频";
    // warning 4.27 添加待修改
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"tab_me_h"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageNamed:@"tab_me_n"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabBarItem3.imageInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    tabBarItem3.title = @"我的";

//    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:232/255.0 green:71/255.0f blue:239/255.0f alpha:1];
    
    self.tabBar.selectedImageTintColor = [UIColor redColor];

    self.selectedViewController =  [self.viewControllers objectAtIndex:1];
    
}




//是否隐藏tabBar
-(void)hideTabBar:(NSNotification*)notif
{
    NSString*hideTabBar;//是否隐藏tabBar
    hideTabBar=notif.object;
    if ([hideTabBar isEqualToString:@"yes"]) {
        self.tabBar.hidden=YES;
    }else
    {
        self.tabBar.hidden=NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
