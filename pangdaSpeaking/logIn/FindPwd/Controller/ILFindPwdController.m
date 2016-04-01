//
//  ILFindPwdController.m
//  IELTSListening
//
//  Created by L on 15/4/14.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILFindPwdController.h"
#import "ILUpdatePwdController.h"
#import "GeneralHelper.h"
#import "MBProgressHUD.h"
//#import "MobClick.h"
@interface ILFindPwdController (){
//    加载框
    MBProgressHUD *HUD;

}

//输入手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
//获取验证码
- (IBAction)getConfirmationCode;
//验证码按钮属性
@property (weak, nonatomic) IBOutlet UIButton *confirmationCodeButton;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *confirmationCode;
//下一步
- (IBAction)next;
//下一步属性
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIView *findPwdView;

@property (nonatomic)NSUInteger confirmCode;
@property (nonatomic)BOOL send;
@property (nonatomic)NSUInteger randomNumber;
@property (nonatomic, strong)NSString *phoneNum;
//定时器
@property (nonatomic, strong)NSTimer *buttonTimer;
@property (nonatomic)NSUInteger sendCount;

@property (nonatomic, strong) NSString *confirmation;

/**
 *  返回按钮
 */
- (IBAction)backBtn;
@end

@implementation ILFindPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.send = NO;
    self.sendCount = 60;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector: @selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.findPwdView addGestureRecognizer:tapGestureRecognizer];
    
    
    
    self.confirmationCodeButton.enabled = YES;
    
//    self.confirmationCodeButton.userInteractionEnabled = YES;
    
    [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];

}

#pragma mark ~~~~~~~~~~监听UITextFiled输入状态~~~~~~~~~~
-(void)textChange{
    
    NSString *phoneStr = self.phoneNumber.text;
    
    BOOL isPhoneNum = [ILRegularExpression validateMobile:phoneStr];
    if (isPhoneNum) {
        self.confirmationCodeButton.enabled = YES;
        [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];
    }else{
        
        self.confirmationCodeButton.enabled = NO;
        [self.confirmationCodeButton setTitleColor:[UIColor colorWithHexString:@"#BABABA"] forState:UIControlStateNormal];
        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma"] forState:UIControlStateNormal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"ILFindPwdController"];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ILFindPwdController"];
    
}


#pragma mark ~~~~~~~~~~获取验证码~~~~~~~~~~
- (IBAction)getConfirmationCode {
    

    
    // 做一下手机号的验证
    
    if (![GeneralHelper isMobileNumber:self.phoneNumber.text]){

        [ILShowError showError:@"请输入正确的手机号" titleName:@"" WithView:self.findPwdView];
        
        return;
    }
    
    self.confirmationCodeButton.userInteractionEnabled = NO;
    
    
    // 随机生成6位数字
    NSInteger randomNumber = (arc4random()%99999)+100000;
    self.confirmation =[NSString stringWithFormat:@"%ld",(long)randomNumber];
    
    
    if (!self.send) {
        NSString *phoneNum = self.phoneNumber.text;
        
        NSString *path = [NSString stringWithFormat:@"%@m=api&c=Phonemessage&a=sendSMS&rpwd=1&appid=1&devtype=iOS&msg=%@&mobile=%@",REQUSTHTTPURL, self.confirmation,phoneNum ];
        
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
                [self.confirmationCodeButton.titleLabel setAlpha:1];
        self.confirmationCodeButton.enabled = YES;
        
        self.confirmationCodeButton.userInteractionEnabled = YES;
        
        self.confirmationCodeButton.userInteractionEnabled = YES;
        
        [self.confirmationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmationCodeButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma_jihuo"] forState:UIControlStateNormal];
    }
}

#pragma mark ~~~~~~~~~~下一步~~~~~~~~~~
- (IBAction)next {
    
    NSString *phoneNumberStr = self.phoneNumber.text;
    if (phoneNumberStr.length == 0 || [phoneNumberStr isEqualToString:@""]) {
        [ILShowError showError:@"手机号不能为空,请输入" titleName:nil WithView:self.findPwdView];
        return;
    }
    NSString *confirmationCodeStr = self.confirmationCode.text;
    if (confirmationCodeStr.length==0|| [confirmationCodeStr isEqualToString:@""]) {
        [ILShowError showError:@"验证码不能为空,请输入" titleName:nil WithView:self.findPwdView];
        return;
    }
    
    if ([self.confirmation isEqualToString:confirmationCodeStr]) {
        
        
//        发布
        NSString *requestUrl =[NSString stringWithFormat:@"%@apptype=2&m=api&c=user&a=getPassword&mobile=%@",REQUSTHTTPURL,phoneNumberStr];
        
        HUD = [MBProgressHUD showMessage:@"加载中...." toView:self.view];
        
         NSLog(@"httpURL:%@",requestUrl);
        [ILHttpTool requestWithUrlString:requestUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
            NSDictionary *statDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            
            [HUD removeFromSuperview];
            NSString *ecode = [NSString stringWithFormat:@"%@",statDic[@"ecode"]];
            NSString *emessage = [NSString stringWithFormat:@"%@",statDic[@"emessage"]];
            if ([ecode isEqualToString:@"0"]) {
                ILUpdatePwdController *updatePwdController = [self.storyboard instantiateViewControllerWithIdentifier:@"updatePwdController"];
                
                updatePwdController.mobile = self.phoneNumber.text;
                updatePwdController.encrypt = self.confirmationCode.text;
                
                [self.navigationController pushViewController:updatePwdController animated:YES];
            }else if ([ecode isEqualToString:@"-3"]){
                
                [ILShowError showError:emessage titleName:nil WithView:self.findPwdView];
                
            }
            
        } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
            
             [HUD removeFromSuperview];
            
             [ILShowError showError:@"请稍后再试" titleName:nil WithView:self.findPwdView];
            
        }];
        
   
    }else{
        [ILShowError showError:@"您输入的验证码有误,请重新输入" titleName:nil WithView:self.findPwdView];
        self.nextBtn.enabled = YES;
    }
    

}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumber resignFirstResponder];
    [self.confirmationCode resignFirstResponder];
}

-(void)keyboardAppear:(NSNotification*)notification{
    
    //获取键盘相对于自己VC的View的坐标信息
    CGRect frameOfKeyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue ];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    frameOfKeyboard = [self.view convertRect:frameOfKeyboard fromView:window];
    //2.计算输入框的结束的坐标信息
    CGRect frameOfInputView = self.findPwdView.frame;

    //3.
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration -=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.findPwdView.frame = frameOfInputView;

    } completion:nil];
}

-(void)keyboardDisappear:(NSNotification*)notification{
    
    CGRect frameOfInputView = self.view.frame;
    frameOfInputView.origin.y = 66;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    duration +=0.1;
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{

    } completion:nil];
    
}

/**
 *  返回按钮
 */
- (IBAction)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
