//
//  ILloginController.m
//  IELTSListening
//
//  Created by L on 15/4/14.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILloginController.h"
#import "RootTabBarController.h"
#import "ILRegisteredController.h"
#import "ILFindPwdController.h"
//#import "ILHomePageController.h"
//#import "ILRootViewController.h"
#import "GeneralHelper.h"
//#import "MobClick.h"
@interface ILloginController ()<UIScrollViewDelegate>
/**
 *  电话号码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;

@property (nonatomic, strong)NSString *ip;
/**
 *  登录按钮
 */
- (IBAction)login;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *resgisteredBtn;

@end

@implementation ILloginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 35, 40, 40) ;
    [but setImage:[UIImage imageNamed:@"nav_arrow_n"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"nav_arrow_h"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    
    self.loginScrollView.delegate = self;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector: @selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.loginScrollView addGestureRecognizer:tapGestureRecognizer];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ILloginController"];


}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ILloginController"];

}




-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumber resignFirstResponder];
    [self.passWord resignFirstResponder];
}

-(void)keyboardAppear:(NSNotification*)notification{
    
    //获取键盘相对于自己VC的View的坐标信息
    CGRect frameOfKeyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue ];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    frameOfKeyboard = [self.view convertRect:frameOfKeyboard fromView:window];
    //2.计算输入框的结束的坐标信息
    CGRect frameOfInputView = self.loginScrollView.frame;
    UIEdgeInsets insets = self.loginScrollView.contentInset;
    insets.bottom = frameOfKeyboard.size.height ;
    //3.
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration -=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.loginScrollView.frame = frameOfInputView;
        self.loginScrollView.contentInset = insets;
        self.loginScrollView.scrollIndicatorInsets = insets;
    } completion:nil];
}

-(void)keyboardDisappear:(NSNotification*)notification{
    
    CGRect frameOfInputView = self.view.frame;
    frameOfInputView.origin.y = 66;
    //键盘消失View
    UIEdgeInsets insets = self.loginScrollView.contentInset;
    insets.bottom = self.loginScrollView.frame.size.height - self.view.frame.size.height + 66;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration +=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.loginScrollView.contentInset = insets;
        self.loginScrollView.scrollIndicatorInsets = insets;
        self.loginScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.origin.y + self.view.frame.size.height + 20);
    } completion:nil];
    
}
#pragma mark ~~~~~~~~~~登录~~~~~~~~~~
- (IBAction)login {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *Token = [NSString stringWithFormat:@"%@",[ud objectForKey:@"Token"]];
    
    NSString *phoneNumberStr = self.phoneNumber.text;
    if (phoneNumberStr.length==0 || [phoneNumberStr isEqualToString:@""]) {
        [ILShowError showError:@"手机号不能为空,请重新输入" titleName:@"登录失败" WithView:self.loginScrollView];
        return;
    }
    NSString *passWordStr = self.passWord.text;
    if (passWordStr.length==0||[passWordStr isEqualToString:@""]) {
        [ILShowError showError:@"密码不能为空,请重新输入" titleName:@"登录失败" WithView:self.loginScrollView];
        return;
    }
    
    // 做一下手机号的验证
    
    if (![GeneralHelper isMobileNumber:phoneNumberStr]){
        
        [ILShowError showError:@"请输入正确的手机号" titleName:@"登录失败" WithView:self.loginScrollView];
        
        return;
    }
    
    // 做一下登录密码的验证
    if (![GeneralHelper checkInputPassword:self.passWord.text]) {
        // 密码不合法

        [ILShowError showError:@"请输入长度为6-20位的密码" titleName:@"登录失败" WithView:self.loginScrollView];
        
        return;
    }

    long long i = [self.phoneNumber.text longLongValue];
    if ((i / 10000000000) == 1) {
        [MBProgressHUD showMessage:@"正在加载中..."];
        
            NSString *str1 = [self.phoneNumber.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *str2 = [self.passWord.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *str3 = [appCurDevice stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
//            NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            UIDevice *device=[[UIDevice alloc] init];
            NSString *uuid = [NSString stringWithFormat:@"TL-%@",device.identifierForVendor.UUIDString];
            
            //发布地址
            
            NSString *requestPath = [NSString stringWithFormat:@"%@appid=1&m=api&c=user&a=login&mobile=%@&password=%@&device=%@&devtype=iOS&version=%@&uuid=%@&deviceToke=%@",REQUSTHTTPURL,str1,str2,str3,appCurVersion,uuid,Token];

        [ILHttpTool requestWithUrlString:requestPath finished:^(AFHTTPRequestOperation *oper, id responseObj) {
    
            
            NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];

            NSString *str = [starDic objectForKey:@"ecode"];
            
            NSString *emessage = [starDic objectForKey:@"emessage"];
            
            if ([str isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                [ud setObject:[NSString stringWithFormat:@"%@",self.phoneNumber.text] forKey:@"user_name"];

                if(![ud objectForKey:@"user_chinesename"]){
                [ud setObject:@"panda" forKey:@"user_chinesename"];
                }
                [ud synchronize];
                
                [self ReturnTo];
                
                //跳转
//                ILRootViewController *rootC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
//                [self.navigationController pushViewController:rootC animated:YES];
                
            }else if ([str isEqualToString:@"-1"]){
                [ILShowError showError:emessage titleName:@"登录失败" WithView:self.loginScrollView];
                [MBProgressHUD hideHUD];
                
            }else if ([str isEqualToString:@"-2"]){
                [ILShowError showError:emessage titleName:@"登录失败" WithView:self.loginScrollView];
                [MBProgressHUD hideHUD];
                
            }else{
                [ILShowError showError:emessage titleName:@"登录失败" WithView:self.loginScrollView];
                [MBProgressHUD hideHUD];
                
            }
 
        } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
    
            NSLog(@"%@",error.localizedDescription);
            [ILShowError showError:@"请稍候重试" titleName:error.localizedDescription WithView:self.loginScrollView];
            [MBProgressHUD hideHUD];

            
        }];
        
        
    }else{
        [ILShowError showError:@"请输入正确的手机号" titleName:@"登录失败" WithView:self.loginScrollView];
        [MBProgressHUD hideHUD];
    }
}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    self.phoneNumber.text = nil;
    self.passWord.text = nil;
    self.loginBtn.enabled = YES;
    [self.view endEditing:YES];
    
}


#pragma mark 返回上一级
- (void)ReturnTo{
    
   [self dismissViewControllerAnimated:YES completion:^{
       
   }];
    

}


@end
