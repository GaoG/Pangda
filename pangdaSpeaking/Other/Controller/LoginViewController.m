//
//  LoginViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/14.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "LoginViewController.h"
#import "MeViewController.h"
@interface LoginViewController ()

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapAction{
    
    [_phoneNumber resignFirstResponder];
    [_passWord resignFirstResponder];

    [self resignFirstResponder];
}

#pragma mark 找回密码
- (IBAction)findPassWord:(id)sender {
    
    
    
}



#pragma mark  登录
- (IBAction)loginAction:(id)sender {
    
    
    
}




- (IBAction)registeredAction:(id)sender {
    
    
    
    
}



//  返回
- (IBAction)backUp:(id)sender {
//    MeViewController *vc = [[MeViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];

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
