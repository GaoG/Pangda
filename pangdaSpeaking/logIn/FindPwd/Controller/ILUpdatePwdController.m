//
//  ILUpdatePwdController.m
//  IELTSListening
//
//  Created by L on 15/4/15.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILUpdatePwdController.h"
//#import "ILHomePageController.h"
//#import "ILRootViewController.h"
#import "GeneralHelper.h"
#import "MBProgressHUD.h"
//#import "MobClick.h"
@interface ILUpdatePwdController (){

    MBProgressHUD *HUD;

}

/**
 *  返回按钮
 */
- (IBAction)backBtn;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *newsPwd;
//再次输入
@property (weak, nonatomic) IBOutlet UITextField *secondPwd;
//完成属性
@property (weak, nonatomic) IBOutlet UIButton *Complete;
//完成
- (IBAction)CompleteBtn;

@property (strong, nonatomic) IBOutlet UIView *updatePwdView;


@end

@implementation ILUpdatePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ILUpdatePwdController"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ILUpdatePwdController"];


}

#pragma mark 完成 （提交新的密码）
- (IBAction)CompleteBtn {
    
    
    
    // 做一下登录密码的验证
    if (![GeneralHelper checkInputPassword:self.newsPwd.text]) {
        // 密码不合法
        
        [ILShowError showError:@"请输入长度为6-20位的密码" titleName:@"" WithView:self.updatePwdView];
        
        return;
    }
    
    self.Complete.enabled = NO;

    
    NSString *newOnePwd = self.newsPwd.text;
    if (newOnePwd.length == 0 || [newOnePwd isEqualToString:@""]) {
        [ILShowError showError:@"密码不能为空,请输入" titleName:@"修改失败" WithView:self.updatePwdView];
        self.Complete.enabled = YES;
        return;
        
    }
    NSString *newAgainPwd = self.secondPwd.text;
    if (newAgainPwd.length == 0 || [newAgainPwd isEqualToString:@""]) {
        [ILShowError showError:@"密码不能为空,请输入" titleName:@"修改失败" WithView:self.updatePwdView];
        self.Complete.enabled = YES;
        return;
    }else if (![newAgainPwd isEqualToString:newOnePwd]){
        [ILShowError showError:@"两次密码不一致,请重新输入" titleName:@"修改失败" WithView:self.updatePwdView];
        self.Complete.enabled = YES;
        
        return;
    }
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:self.view];
    

    
    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&m=api&c=user&a=updatepassword&mobile=%@&encrypt=%@&pwd=%@&device=%@",REQUSTHTTPURL,self.mobile,self.encrypt,self.newsPwd.text,appCurDevice];
    
    NSLog(@"requestUrl：%@",httpUrl);
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSDictionary *statDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        [HUD removeFromSuperview];
        
        if ([[statDic objectForKey:@"ecode"]integerValue] == 0) {
          
            self.Complete.enabled = YES;
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSString stringWithFormat:@"%@",self.mobile] forKey:@"user_num"];
#pragma mark    跳转
//            ILRootViewController *rootC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
//              [self.navigationController pushViewController:rootC animated:YES];
            
            [self.navigationController popToRootViewControllerAnimated:YES ];
        }else{
        
            UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alview show];
        }
        
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        [HUD removeFromSuperview];
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alview show];
        
    }];
    
}



/**
 *  返回按钮
 */
- (IBAction)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
