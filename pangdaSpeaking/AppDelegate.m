//
//  AppDelegate.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/18.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DEFINEH.h"
#import "RootTabBarController.h"
#import "JPUSHService.h"
#import <sys/sysctl.h>
@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate{

//这里添加一句话
    NSString *appUpLoadUrl;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//     友盟统计
    [self umStatistics];
    
    //获得设备型号
    [self initGetDevice];
    
//    检测更新版本
    
    [self appUpload];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController = [[RootTabBarController alloc]init];
    
     [self.window makeKeyAndVisible];
    
    
    
    
/*
 ** 极光推送
 */
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:JPAPPKEY channel:JPchannel apsForProduction:JPisProduction];
    
    
    
    
    
    
    

    return YES;
}

/*
 *** 友盟的统计
 */
- (void)umStatistics{

     [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick setLogEnabled:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];

}

/*
 ** 极光推送 获取token
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    
    //将token值存在本地  在登陆时将token值一并传给后台
    NSUserDefaults *tokenNum=[NSUserDefaults standardUserDefaults];
    [tokenNum setObject:hexToken forKey:@"Token"];
    [tokenNum synchronize];
}


/*
 ** 极光推送
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
/*
 ** 极光推送
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

/*
 ** 极光推送
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



/*
 **** 统计 （通知）
 */
- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
}




/*
 ** 检测更新新版本
 */
- (void)appUpload{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *httpUrl =[NSString stringWithFormat:@"%@m=api&c=info&a=getversion&appid=1&devtype=iOS&v=%@&mobile=%@",REQUSTHTTPURL,appCurVersion,[user objectForKey:@"user_name"]];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"status"] ] isEqualToString:@"1"]||[starDic objectForKey:@"data"]) {
            
            appUpLoadUrl = [[starDic objectForKey:@"data"]objectForKey:@"url"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[[starDic objectForKey:@"data"] objectForKey:@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[[starDic objectForKey:@"data"]objectForKey:@"button"], nil];
            
            alertView.delegate = self;
             [alertView show];
            
        }
        
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        
    }];
    
}

/** 版本提示的alertView
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUpLoadUrl]];
    }
    
}

/*
 ** 获取设备类型
 */
-(void)initGetDevice{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *device = [ud stringForKey:@"device"];
    //[ud removeObjectForKey:@"device"];
    if (!device) {
        //获取设备型号
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char*)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        [self device:platform];
    }else{
        NSLog(@"888");
    }
    
}



/*
 *** 获取到手机的型号
 */
-(void)device:(NSString*)platform{
    NSString *str = platform;
    if([platform isEqualToString:@"iPhone1,1"]){
        str = @"iPhone2G (A1203)";
    }
    if([platform isEqualToString:@"iPhone1,2"]){
        str =  @"iPhone3G (A1241/A1324)";
    }
    
    if([platform isEqualToString:@"iPhone2,1"]){
        str = @"iPhone3GS (A1303/A1325)";
    }
    
    if([platform isEqualToString:@"iPhone3,1"]){
        str =  @"iPhone4 (A1332)";
    }
    
    if([platform isEqualToString:@"iPhone3,2"]){
        str =  @"iPhone4 (A1332)";
    }
    
    if([platform isEqualToString:@"iPhone3,3"])
    {str =  @"iPhone4 (A1349)";}
    
    if([platform isEqualToString:@"iPhone4,1"]){
        str =  @"iPhone4S (A1387/A1431)";
    }
    
    
    if([platform isEqualToString:@"iPhone5,1"])
    {str =  @"iPhone5 (A1428)";}
    if([platform isEqualToString:@"iPhone5,2"])
    {str =  @"iPhone5 (A1429/A1442)";}
    if([platform isEqualToString:@"iPhone5,3"])
    { str =  @"iPhone5c (A1456/A1532)";}
    if([platform isEqualToString:@"iPhone5,4"])
    { str =  @"iPhone5c (A1507/A1516/A1526/A1529)";}
    if([platform isEqualToString:@"iPhone6,1"])
    {str =  @"iPhone5s (A1453/A1533)";}
    if([platform isEqualToString:@"iPhone6,2"])
    {str =  @"iPhone5s (A1457/A1518/A1528/A1530)";}
    if([platform isEqualToString:@"iPhone7,1"])
    {str =  @"iPhone6 Plus (A1522/A1524)";}
    if([platform isEqualToString:@"iPhone7,2"])
    {str =  @"iPhone6 (A1549/A1586)";}
    if([platform isEqualToString:@"iPhone8,1"])
    {str =  @"iPhone6s";}
    if([platform isEqualToString:@"iPhone8,2"])
    {str =  @"iPhone6sPlus";}
    if([platform isEqualToString:@"iPod1,1"])
    {str =  @"iPodTouch 1G (A1213)";}
    if([platform isEqualToString:@"iPod2,1"])
    {str =  @"iPodTouch 2G (A1288)";}
    if([platform isEqualToString:@"iPod3,1"])
    {str =  @"iPodTouch 3G (A1318)";}
    if([platform isEqualToString:@"iPod4,1"])
    {str =  @"iPodTouch 4G (A1367)";}
    if([platform isEqualToString:@"iPod5,1"])
    {str =  @"iPodTouch 5G (A1421/A1509)";}
    if([platform isEqualToString:@"iPad1,1"])
    {str =  @"iPad1G (A1219/A1337)";}
    if([platform isEqualToString:@"iPad2,1"])
    {str =  @"iPad2 (A1395)";}
    if([platform isEqualToString:@"iPad2,2"])
    {str =  @"iPad2 (A1396)";}
    if([platform isEqualToString:@"iPad2,3"])
    {str =  @"iPad2 (A1397)";}
    if([platform isEqualToString:@"iPad2,4"])
    {str =  @"iPad2 (A1395+New Chip)";}
    if([platform isEqualToString:@"iPad2,5"])
    {str =  @"iPadMini 1G (A1432)";}
    if([platform isEqualToString:@"iPad2,6"])
    {str =  @"iPadMini 1G (A1454)";}
    if([platform isEqualToString:@"iPad2,7"])
    {str =  @"iPadMini 1G (A1455)";}
    if([platform isEqualToString:@"iPad3,1"])
    {str =  @"iPad3 (A1416)";}
    if([platform isEqualToString:@"iPad3,2"])
    {str =  @"iPad3 (A1403)";}
    if([platform isEqualToString:@"iPad3,3"])
    {str =  @"iPad3 (A1430)";}
    if([platform isEqualToString:@"iPad3,4"])
    {str =  @"iPad4 (A1458)";}
    if([platform isEqualToString:@"iPad3,5"])
    {str =  @"iPad4 (A1459)";}
    if([platform isEqualToString:@"iPad3,6"])
    {str =  @"iPad4 (A1460)";}
    if([platform isEqualToString:@"iPad4,1"])
    {str =  @"iPadAir (A1474)";}
    if([platform isEqualToString:@"iPad4,2"])
    {str =  @"iPadAir (A1475)";}
    if([platform isEqualToString:@"iPad4,3"])
    {str =  @"iPadAir (A1476)";}
    if([platform isEqualToString:@"iPad4,4"])
    {str =  @"iPadMini 2G (A1489)";}
    if([platform isEqualToString:@"iPad4,5"])
    {str =  @"iPadMini 2G (A1490)";}
    if([platform isEqualToString:@"iPad4,6"])
    {str =  @"iPadMini 2G (A1491)";}
    if([platform isEqualToString:@"i386"])
    {str =  @"iPhoneSimulator";}
    if([platform isEqualToString:@"x86_64"])
    {str =  @"iPhoneSimulator";}
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject: str forKey:@"device"];
    //NSLog(@"device:%@",str);
    [ud synchronize];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
