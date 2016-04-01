//
//  ILRegisteredController.m
//  IELTSListening
//
//  Created by L on 15/4/15.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//  注册

#import "ILRegisteredController.h"
#import "LegalViewController.h"
//#import "ILHomePageController.h"
//#import "ILRootViewController.h"
#import "GeneralHelper.h"
#import "MBProgressHUD.h"
//#import "MobClick.h"

@interface ILRegisteredController ()<UIScrollViewDelegate,UITextFieldDelegate>{

//加载框
    MBProgressHUD *HUD;

}
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *confirmationCode;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIScrollView *registeredScrollView;
//获取验证码
- (IBAction)getConfirmationCode;
//验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmationCodeButton;
//勾选按钮
- (IBAction)checkboxClick:(UIButton *)sender;
//定时器
@property (nonatomic, strong)NSTimer *buttonTimer;
@property (nonatomic)BOOL isReading;
@property (nonatomic)BOOL send;
@property (nonatomic)NSUInteger sendCount;
@property (nonatomic, strong)NSString *phoneNum;

@property (nonatomic, strong) NSString *confirmation;


- (IBAction)legalButton;

/**
 *  返回按钮
 */
- (IBAction)backBtn;

- (IBAction)registerButton;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic)NSUInteger randomNumber;


@end

@implementation ILRegisteredController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isReading = YES;
    self.send = NO;
    self.sendCount = 60;
    
    self.registeredScrollView.delegate = self;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector: @selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.registeredScrollView addGestureRecognizer:tapGestureRecognizer];
    
//    [self textChange];
    
    self.confirmationCodeButton.enabled = YES;
    [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ILRegisteredController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ILRegisteredController"];
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumber resignFirstResponder];
    [self.confirmationCode resignFirstResponder];
    [self.passWord resignFirstResponder];
}

-(void)keyboardAppear:(NSNotification*)notification{
    
    //获取键盘相对于自己VC的View的坐标信息
    CGRect frameOfKeyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue ];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    frameOfKeyboard = [self.view convertRect:frameOfKeyboard fromView:window];
    //2.计算输入框的结束的坐标信息
    CGRect frameOfInputView = self.registeredScrollView.frame;
    UIEdgeInsets insets = self.registeredScrollView.contentInset;
    insets.bottom = frameOfKeyboard.size.height ;
    //3.
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration -=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.registeredScrollView.frame = frameOfInputView;
        self.registeredScrollView.contentInset = insets;
        self.registeredScrollView.scrollIndicatorInsets = insets;
    } completion:nil];
}

-(void)keyboardDisappear:(NSNotification*)notification{
    
    CGRect frameOfInputView = self.view.frame;
    frameOfInputView.origin.y = 66;
    //键盘消失View
    UIEdgeInsets insets = self.registeredScrollView.contentInset;
    insets.bottom = self.registeredScrollView.frame.size.height - self.view.frame.size.height + 66;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration +=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.registeredScrollView.contentInset = insets;
        self.registeredScrollView.scrollIndicatorInsets = insets;
        self.registeredScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.origin.y + self.view.frame.size.height + 20);
    } completion:nil];
    
}

#pragma mark ~~~~~~~~~~监听UITextFiled输入状态~~~~~~~~~~
-(void)textChange{
    
//    NSString *phoneStr = self.phoneNumber.text;
//    
//    BOOL isPhoneNum = [GeneralHelper isMobileNumber:phoneStr];
//    if (isPhoneNum) {
//        self.confirmationCodeButton.enabled = YES;
//        [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];
//    }else{
//        
//        self.confirmationCodeButton.enabled = NO;
//        [self.confirmationCodeButton setTitleColor:[UIColor colorWithHexString:@"#BABABA"] forState:UIControlStateNormal];
//        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma"] forState:UIControlStateNormal];
//    }
    
}


/**
 *  返回
 */
- (IBAction)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ~~~~~~~~~~注册~~~~~~~~~~
- (IBAction)registerButton {
    
    NSString *phoneNumberStr = self.phoneNumber.text;
    if (phoneNumberStr.length==0 || [phoneNumberStr isEqualToString:@""]) {
        [ILShowError showError:@"手机号不能为空,请输入" titleName:@"注册失败" WithView:self.registeredScrollView];
        return;
    }
    
    NSString *confirmationCodeStr = self.confirmationCode.text;
    if (confirmationCodeStr.length==0 || [confirmationCodeStr isEqualToString:@""]) {
        [ILShowError showError:@"验证码不能为空,请输入" titleName:@"注册失败" WithView:self.registeredScrollView];
        return;
    }
    NSString *passWordStr = self.passWord.text;
    if (passWordStr.length==0 || [passWordStr isEqualToString:@""]) {
        [ILShowError showError:@"密码不能为空,请输入" titleName:@"注册失败" WithView:self.registeredScrollView];
        return;
    }
    
    // 做一下手机号的验证
    
    if (![GeneralHelper isMobileNumber:phoneNumberStr]){
        
        [ILShowError showError:@"请输入正确的手机号" titleName:@"登录失败" WithView:self.registeredScrollView];
        
        return;
    }
    
    // 做一下登录密码的验证
    if (![GeneralHelper checkInputPassword:self.passWord.text]) {
        // 密码不合法
        
        [ILShowError showError:@"请输入长度为6-20位的密码" titleName:@"登录失败" WithView:self.registeredScrollView];
        
        return;
    }
    
    if (self.isReading) {
        //点击注册后不可点击
        self.registerBtn.enabled = NO;
        
//                if ([self.phoneNumber.text isEqualToString:self.phoneNum]) {
        if ([self.confirmationCode.text isEqualToString:self.confirmation]){
            
            HUD = [MBProgressHUD showMessage:@"加载中...." toView:self.view];
            
            NSString *str3 = [appCurDevice stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            //针对（tl）MD5加密
            NSString *MD5Str = @"tl";
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//            UIDevice *device=[[UIDevice alloc] init];
            
            
              NSString *httpURL = [NSString stringWithFormat:@"%@m=api&c=user&a=registered&mobile=%@&appid=1&pwd=%@&version=%@&devtype=iOS&uuid=%@&device=%@&version=%@&deviceToke=%@",REQUSTHTTPURL,self.phoneNumber.text,self.passWord.text,appCurVersion,MD5Str.md5String,str3,appVersion,[ud objectForKey:@"Token"]];
            
            NSLog(@"requestUrl：%@",httpURL);
            [ILHttpTool requestWithUrlString:httpURL finished:^(AFHTTPRequestOperation *oper, id responseObj) {
                NSDictionary *statDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
                [HUD removeFromSuperview];

                NSString *ecode = statDic[@"ecode"];
                NSString *emessage = statDic[@"emessage"];
                if ([ecode isEqualToString:@"2"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:self cancelButtonTitle:@"一键登录" otherButtonTitles:nil, nil];
                    alert.tag = 10101;
                    [alert show];
                }else if ([ecode isEqualToString:@"-10"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.registerBtn.enabled = YES;
                }else if ([ecode isEqualToString:@"-11"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.registerBtn.enabled = YES;
                }else if ([ecode isEqualToString:@"-12"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.registerBtn.enabled = YES;
                }else if ([ecode isEqualToString:@"-13"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.registerBtn.enabled = YES;
                }else if ([ecode isEqualToString:@"-14"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    self.registerBtn.enabled = YES;
                }else{
                    [ILShowError showError:@"连接超时" titleName:@"注册失败" WithView:self.registeredScrollView];
                    self.registerBtn.enabled = YES;
                }

                
            } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
                
                NSLog(@"%@",error.localizedDescription);
                [HUD removeFromSuperview];

            }];
            
        }else{
            [ILShowError showError:@"您输入的验证码有误,请重新输入" titleName:@"注册失败" WithView:self.registeredScrollView];
            self.registerBtn.enabled = YES;
        }
    }else{
        
        [ILShowError showError:@"请阅读使用条款和隐私政策" titleName:@"注册失败" WithView:self.registeredScrollView];
        self.registerBtn.enabled = YES;
    }
}


#pragma mark ~~~~~~~~~~获取验证码~~~~~~~~~~
- (IBAction)getConfirmationCode {
    
    
#pragma mark 获取验证码。。。。。。。。。。。。。。。。
    
    
    // 做一下手机号的验证
    
    if (![GeneralHelper isMobileNumber:self.phoneNumber.text]){
        
        [ILShowError showError:@"请输入正确的手机号" titleName:@"" WithView:self.registeredScrollView];
        
        return;
    }
    
// 随机生成6位数字
    NSInteger randomNumber = (arc4random()%99999)+100000;
    self.confirmation =[NSString stringWithFormat:@"%ld",(long)randomNumber];
    
    

    self.confirmationCodeButton.userInteractionEnabled = NO;
    
    
    if (!self.send) {
        NSString *phoneNum = self.phoneNumber.text;

          NSString *path = [NSString stringWithFormat:@"%@m=api&c=Phonemessage&a=sendSMS&rpwd=0&appid=1&devtype=iOS&msg=%@&mobile=%@",REQUSTHTTPURL, self.confirmation,phoneNum ];
        
       [ILHttpTool requestWithUrlString:path finished:^(AFHTTPRequestOperation *oper, id responseObj) {
           
          NSDictionary*startDic=[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
           
           
           NSString *ecode = [startDic objectForKey:@"ecode"];
           NSString *emessage = [startDic objectForKey:@"emessage"];
           
           if ([ecode isEqualToString:@"0"]) {
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               
               [alert show];
               
           }else if ([ecode isEqualToString:@"1"]){
               
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:emessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               [alert show];
               
           }

            self.buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonText) userInfo:Nil repeats:YES];
           
       } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
           
           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
           [alert show];
       }];

    }
}

#pragma mark ~~~~~~~~~~倒计时~~~~~~~~~~
-(void)changeButtonText{
    
    if (self.sendCount >0) {
        
        [self.confirmationCodeButton setTitle:[NSString stringWithFormat:@"%lus后重新获取",(unsigned long)self.sendCount] forState:UIControlStateNormal];
        self.sendCount -= 1;
        self.send = YES;
        
        self.confirmationCodeButton.enabled = NO;
        
        self.confirmationCodeButton.userInteractionEnabled = NO;

        [self.confirmationCodeButton setTitleColor:[UIColor colorWithHexString:@"#BABABA"] forState:UIControlStateNormal];
        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma"] forState:UIControlStateNormal];
    }else{
        [self.buttonTimer invalidate];
        self.buttonTimer = nil;
        self.send = NO;
        self.sendCount = 60;
        [self.confirmationCodeButton addTarget:self action:@selector(getConfirmationCode) forControlEvents:UIControlEventTouchUpInside];
        
        [self.confirmationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        
        self.confirmationCodeButton.userInteractionEnabled = YES;
        
        [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];
        
    }
}



- (IBAction)checkboxClick:(UIButton *)sender {
    //每次点击都改变按钮的状态
    sender.selected=!sender.selected;
    
    if(sender.selected){
        //在此实现不打勾时的方法
        self.isReading = NO;
        
    }else{
        //在此实现打勾时的方法
        self.isReading = YES;
    }
}

#pragma mark ~~~~~~~~~~条款和隐私协议~~~~~~~~~~
- (IBAction)legalButton {
    LegalViewController *le = [[LegalViewController alloc]init];
    [self.navigationController pushViewController:le animated:YES];
}

#pragma mark ~~~~~~~~~~UIAlertView代理方法实现~~~~~~~~~~
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10101) {
        
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%@",self.phoneNumber.text] forKey:@"user_name"];
    [ud synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    }
    //跳转页面
#pragma mark 跳转
//    ILRootViewController *rootC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
//    [self.navigationController pushViewController:rootC animated:YES];
    
}


#pragma mark ~~~~~~~~~~取消通知~~~~~~~~~~
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark ~~~~~~~~~~UITextFiled代理方法实现~~~~~~~~~~

@end
