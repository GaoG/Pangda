//
//  MeViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/20.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "MeViewController.h"
#import "PersonInformationViewController.h"
#import "SetupViewController.h"
#import "UIImageView+WebCache.h"
#import "AVFoundation/AVFoundation.h"
#import "ILloginController.h"
#import "MeOneTableViewCell.h"
#import "MeTwoTableViewCell.h"
#import "MobClick.h"
@interface MeViewController (){

    UILabel *label;
    BOOL isshow;
    NSInteger number;
    NSMutableArray *array;
    NSMutableArray *imageArray;
    AVPlayer *newPlayer;
    NSUserDefaults *user;

}


@property (nonatomic, strong) UITableView *myTableView;


@end

@implementation MeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTitleViewWithTitle:@"我的"];
    array = [[NSMutableArray alloc]initWithObjects:@"连续登录",@"学习机经",nil];
    user = [NSUserDefaults standardUserDefaults];
    imageArray  = [[NSMutableArray alloc]initWithObjects:@"icon_landing_", @"icon_book_",nil];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    [self initTableView];
    

    
    
    

}



- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MeViewController"];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"no"];
    
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//    [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_myTableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MeViewController"];

}


#pragma mark tableView 的chuangjian

- (void)initTableView{

    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    }
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];


}




#pragma mark tableView deleaget
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    
    return 3;
    
}



#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section ==1) {
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   
#pragma mark 第一种

        if (indexPath.section ==0) {
            
            static NSString *identify = @"MeOneTableViewCell";
            MeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
            }
            
            if (![user objectForKey:@"user_name"]) {
                cell.loginLabel.hidden = NO;
                cell.heardImge.image = [UIImage imageNamed:@"pic_default"];
            }else{
              
                cell.loginLabel.hidden = YES;

            cell.titleLabel.text = [user objectForKey:@"user_chinesename"];
                
                NSData *imageData = [user objectForKey:@"userHeadImage"];
                if (imageData) {
                    
                    cell.heardImge.image = [UIImage imageWithData:imageData];
                }else{
                    
                    cell.heardImge.image = [UIImage imageNamed:@"pic_default"];
                }
                
                
            }
            
            cell.detailsLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    
 #pragma mark 第二种
    
        else{
            
            static NSString *identify = @"MeTwoTableViewCell";
            MeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
            }
            
            
            if(indexPath.section ==1){
                
                cell.moreImage.hidden = YES;
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 49.5,KSCREENWIDTH-20 , .5)];
                line.backgroundColor = [UIColor grayColor];
                
                
                cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
                cell.titleLabel.text = array[indexPath.row];
                
                if (indexPath.row == 0) {
                    if ([user objectForKey:@"user_name"]){
                        cell.detailsLabel.text = @"3天";
                    }
                    [cell.contentView addSubview:line];
                }else if(indexPath.row == 1){
                    if ([user objectForKey:@"user_name"]){
                        cell.detailsLabel.text = @"23道";
                    }
                    
                }
                
            }   else{
                
                cell.detailsLabel.hidden = YES;
                cell.imageView.image = [UIImage imageNamed:@"icon_Set_"];
                cell.titleLabel.text = @"设置";
                
                return cell;
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 80;
    }
    return 50;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    
        if ([user objectForKey:@"user_name"]) {
            PersonInformationViewController *PersonInformationVC = [[PersonInformationViewController alloc]init];
            
            [self.navigationController pushViewController:PersonInformationVC animated:YES];
        }else{
        
            [self login];
        }
        
        
    }else if(indexPath.section == 2){
    
        SetupViewController *SetupVC = [[SetupViewController alloc]init];
        
        [self.navigationController pushViewController:SetupVC animated:YES];

        
    }

    

}



#pragma mark 登录
- (void)login{
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 显示主控制器（登录界面）
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    
    UINavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"navgationController"];
    
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    

    
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
