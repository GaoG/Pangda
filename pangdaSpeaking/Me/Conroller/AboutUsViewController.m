//
//  AboutUsViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/12.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    
    [self addTitleViewWithTitle:@"关于我们"];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正泽睿学（北京）科技有限公司";
    
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AboutUsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AboutUsViewController"];
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
