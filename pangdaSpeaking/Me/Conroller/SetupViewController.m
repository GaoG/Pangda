//
//  SetupViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/10.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "SetupViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "MobClick.h"
@interface SetupViewController ()<UIAlertViewDelegate>{
    NSMutableArray *array;

}
@property (nonatomic, strong)UITableView *myTableView;
@end

@implementation SetupViewController{

    UIButton *removeLogBut;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    array = [[NSMutableArray alloc]initWithObjects:@"版本号",@"关于胖达雅思",@"意见反馈", nil];
    [self addTitleViewWithTitle:@"设置"];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];

    [self initTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SetupViewController"];
    
    [self initRemoveLogBut];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SetupViewController"];
    
}

- (void)initTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 260) style:UITableViewStyleGrouped];
    }
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.scrollEnabled = NO;
    [self.view addSubview:_myTableView];
    
    
}

#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = array[indexPath.row];
    if (indexPath.row == 0) {
        UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 13, 40, 20)];
        vLabel.font = [UIFont systemFontOfSize:12];
        vLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        vLabel.text = [NSString stringWithFormat:@"%@",appCurVersion];
        [cell.contentView addSubview:vLabel];
    }else {
    
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCREENWIDTH-30, 15, 11, 18)];
        imageView.image = [UIImage imageNamed:@"na_arrow_n"];
        [cell.contentView addSubview:imageView];
    
    }
    
    
    return cell;
    
}

/*
 **** tableviewDeletaget
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.row == 1) {
        
        AboutUsViewController *AboutUsViewVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:AboutUsViewVC animated:YES];
    }
    if (indexPath.row == 2) {
        FeedbackViewController *FeedbackViewVC = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:FeedbackViewVC animated:YES];
    }
    
    

}



- (void)initRemoveLogBut{

    if (!removeLogBut) {
        
    
    removeLogBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [removeLogBut setFrame:CGRectMake(10,300 , self.view.width-20, 40)];
    
    [removeLogBut setTitle:@"退出" forState:UIControlStateNormal];
    [removeLogBut setBackgroundImage:[UIImage imageNamed:@"sign_"] forState:UIControlStateNormal];
    [removeLogBut addTarget:self action:@selector(removeLogButAction) forControlEvents:UIControlEventTouchUpInside];
        removeLogBut.layer.masksToBounds = YES;
        removeLogBut.layer.cornerRadius = 5;
    
    [self.view addSubview:removeLogBut];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:@"user_name"]) {
        
        removeLogBut.hidden = NO;
    }else  {
    
    removeLogBut.hidden = YES;
    }
    

}

#pragma amrk 退出登录
- (void)removeLogButAction{
    
    
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alerView.delegate = self;
    alerView.tag = 10101;
    [alerView show];
    
    

//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    
//    [user removeObjectForKey:@"user_name"];
//    removeLogBut.hidden = YES;

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10101&&buttonIndex ==1){
    
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user removeObjectForKey:@"user_name"];
        removeLogBut.hidden = YES;
        
        [self leftBackAction];
    
    }
    
    
    


}



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
