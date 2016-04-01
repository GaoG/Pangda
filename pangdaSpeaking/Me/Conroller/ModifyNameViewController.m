//
//  ModifyNameViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/12.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "ModifyNameViewController.h"
#import "MobClick.h"
@interface ModifyNameViewController ()

@end

@implementation ModifyNameViewController{

    UITextField *textField;
    UILabel *line;
    NSUserDefaults *user;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     user = [NSUserDefaults standardUserDefaults];
    
    [self addTitleViewWithTitle:@"修改名字"];
    [self addItemWithTitle:@"保存" imageName:nil andFrame:CGRectMake(0, 0,30 ,20) selector:@selector(saveAction) location:NO];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    
    [self initUI];
    // Do any additional setup after loading the view.
}

/*
 ** 初始化ui
 */
- (void)initUI{
    textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, self.view.width-10, 50)];

    if ([user objectForKey:@"user_chinesename"]) {
        textField.placeholder = [user objectForKey:@"user_chinesename"];
    }else{
   
    textField.placeholder = @"名字";
    }
    [self.view addSubview:textField];
    line = [[UILabel alloc]initWithFrame:CGRectMake(-10, textField.height-1, textField.width, 1)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    [textField addSubview:line];
    

}


/*
 ** 保存的事件
 */
- (void)saveAction{
   
    
    if (textField.text.length >0) {
        
    [user setObject:textField.text forKey:@"user_chinesename"];
    
    [user synchronize];
    if ([[user objectForKey:@"user_chinesename"] isEqualToString:textField.text]) {
        
        [MBProgressHUD showSuccess:@"保存成功"];
    }

    [self leftBackAction];
    }
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ModifyNameViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ModifyNameViewController"];
}
/*
 ** 返回上一级
 */
- (void)leftBackAction{
    
    [textField resignFirstResponder];
    
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
