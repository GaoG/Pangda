//
//  FeedbackViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/12.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>{
    
    UITextField *textField;
    UITextView *mytextView;
    UIButton *submitBut;
    UILabel *hintLabel;
    NSUserDefaults *user;
    
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [NSUserDefaults standardUserDefaults];
    
    [self addTitleViewWithTitle:@"意见反馈"];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    [self initUI];
    // Do any additional setup after loading the view.
}


/*
 ** 初始化ui
 */
- (void)initUI{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 75, self.view.width-30, 242)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, view.width, 1)];
    lin.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:lin];
    
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(25, 75, self.view.width-50, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"  联系方式";
    textField.font = [UIFont systemFontOfSize:15];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    
    
    
    mytextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 117, self.view.width-40, 200)];
    hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, mytextView.width-10, 20)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:15];
    hintLabel.text = @"有何意见或建议，请在这开告诉我们...";
    hintLabel.textColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
    
    [mytextView addSubview:hintLabel];
    mytextView.backgroundColor = [UIColor whiteColor];
    mytextView.font = [UIFont systemFontOfSize:15];
    mytextView.delegate = self;
    mytextView.keyboardType
    = UIKeyboardTypeDefault;
    [self.view addSubview:mytextView];
    
    
    submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBut.frame = CGRectMake(15, 330, self.view.width-30, 40);
    
    submitBut.layer.masksToBounds = YES;
    submitBut.layer.cornerRadius = 5;
    [submitBut setTitle:@"提交" forState:UIControlStateNormal];
    [submitBut setTitle:@"提交" forState:UIControlStateHighlighted];
    
    
    [submitBut setBackgroundImage:[UIImage imageNamed:@"sign_"] forState:UIControlStateNormal];
    [submitBut setBackgroundImage:[UIImage imageNamed:@"sign_"] forState:UIControlStateHighlighted];
    
    [submitBut addTarget:self action:@selector(submitButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBut];
    
}


/*
 **** 提交按钮的事件
 */
- (void)submitButAction{
    
    [textField resignFirstResponder];
    [mytextView resignFirstResponder];
    
    NSString *f_mobile = textField.text;
    NSString *f_content = mytextView.text;
    
    f_mobile =  [f_mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    f_content =  [f_content stringByReplacingOccurrencesOfString:@" " withString:@""];
    [MBProgressHUD showMessage:@"提交成功"];
    
    NSString *httpUrl = [NSString stringWithFormat:@"%@m=api&c=feedback&a=infoSubmit&appid=1&mobile=%@&f_mobile=%@&f_content=%@&version=%@",REQUSTHTTPURL,[user objectForKey:@"user_name"],f_mobile,f_content,appCurVersion];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[starDic objectForKey:@"state"]integerValue] == 0) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [MBProgressHUD showSuccess:@"提交成功"];
        }
        
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        
        [ILShowError showError:@"提交失败" titleName:@"提示" WithView:self.view];
        
    }];
    
}

/*
 ** textViewDelegate
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;{
    
    
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    if (text.length>0) {
        
        hintLabel.hidden = YES;
    }else{
        hintLabel.hidden = NO;
        
    }
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FeedbackViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FeedbackViewController"];
}



/*
 ** 返回上一级
 */
- (void)leftBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
