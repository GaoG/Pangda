//
//  PartOneDetailedController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartOneDetailedController.h"
#import "PartOnePlayViewController.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
#import "PartTwoPlayViewController.h"
#import "UIImageView+WebCache.h"
#import "PartDetailedTableViewCell.h"
@interface PartOneDetailedController ()
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation PartOneDetailedController{

    NSMutableArray *edataArray;
    MBProgressHUD *HUD;
    UIWindow *window;
    
}
        
- (void)viewDidLoad {
    [super viewDidLoad];
    edataArray = [[NSMutableArray alloc]init];
    window = [[UIApplication sharedApplication]keyWindow];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];
//    数据请求
    [self requstData];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    [self inittableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PartOneDetailedController"];
    [self addTitleViewWithTitle:_titleName];

}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PartOneDetailedController"];

}
#pragma mark  数据请求
- (void)requstData{
    
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:window];
    NSString *httpUrl;
    if ([_upType isEqualToString:@"1"]) {
        httpUrl = [NSString stringWithFormat:@"%@m=api&c=category&a=listcategory&appid=1&leval=%@&mobile=18610905643&version=1.0.0$devtype=iOS",REQUSTHTTPURL,_evalue];
    }else if ([_upType isEqualToString:@"2"]){
        httpUrl = [NSString stringWithFormat:@"%@m=api&c=content&a=listcontent_part2_3&mobile=18610905643&version=4.3.1&devtype=iOS&leval=%@&appid=1&pageindex=0&pagenum=10",REQUSTHTTPURL,_evalue];
    
    }

    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            
            edataArray = [starDic objectForKey:@"edata"];
            
            [_myTableView reloadData];
        }
       [HUD removeFromSuperview];
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [HUD removeFromSuperview];
    }];

}


- (void)inittableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    }
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_myTableView];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

   return  edataArray.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"PartDetailedTableViewCell";
    
    PartDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        
        
    }
    
    NSMutableDictionary *tempDic = [edataArray objectAtIndex:indexPath.row];
    [tempDic setObject:_upType forKey:@"upType"];
    cell.dataDic = tempDic;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_upType isEqualToString:@"1"]) {
        PartOnePlayViewController *PartOnePlayVC = [[PartOnePlayViewController alloc]init];
        PartOnePlayVC.titleName = [NSString stringWithFormat:@"%@ - %@",[edataArray[indexPath.row]objectForKey:@"chinese"],[edataArray[indexPath.row]objectForKey:@"english"]];
        
        PartOnePlayVC.myId = [edataArray[indexPath.row]objectForKey:@"id"];
        [self.navigationController pushViewController:PartOnePlayVC animated:YES];
    }else if ([_upType isEqualToString:@"2"]){
    
        PartTwoPlayViewController *PartTwoPlayVC = [[PartTwoPlayViewController alloc]init];
        PartTwoPlayVC.titleName = [edataArray[indexPath.row]objectForKey:@"question"];
        PartTwoPlayVC.myId = [edataArray[indexPath.row]objectForKey:@"id"];
        [self.navigationController pushViewController:PartTwoPlayVC animated:YES];
    
    }
  
}
#pragma mark 返回上一级
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
