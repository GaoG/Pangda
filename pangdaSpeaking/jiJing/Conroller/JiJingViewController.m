//
//  JiJingViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/20.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "JiJingViewController.h"
#import "PartOneDetailedController.h"
#import "NewTopicViewController.h"
#import "PartTwoPlayViewController.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "AVFoundation/AVFoundation.h"
@interface JiJingViewController (){
    
//    存放ecode 的数据
    NSMutableDictionary *edataDic;
    NSMutableArray *partOneArray;
    NSMutableArray *partTwoArray;
    MBProgressHUD *HUD;
    UIWindow *window;
    NSUserDefaults *user;
    

}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic, strong) AVAudioPlayer *player;


@end

@implementation JiJingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];
    edataDic =[[NSMutableDictionary alloc]init];
    partOneArray = [[NSMutableArray alloc]init];
    partTwoArray = [[NSMutableArray alloc]init];
    window = [[UIApplication sharedApplication]keyWindow];
    
    [self addTitleViewWithTitle:@"机经"];
    
//    [self addItemWithTitle:@"只看新题" imageName:nil andFrame:CGRectMake(0, 20, 80, 40) selector:@selector(RightItemAction) location:NO];
    [self requstData];
    [self initTableView];
    
   
 
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"JiJingViewController"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"no"];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JiJingViewController"];
}

#pragma mark 数据请求
- (void)requstData{

    
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:window];
    
    NSString *httpUrl = [NSString stringWithFormat:@"%@m=api&c=category&a=listcategory&appid=1&mobile=%@&version=%@$devtype=iOS",REQUSTHTTPURL,[user objectForKey:@"user_name"],appCurVersion];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
//        判断当ecode为0时正常
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            
             edataDic = [starDic objectForKey:@"edata"];
            partOneArray = [edataDic objectForKey:@"part1"];
            partTwoArray = [edataDic objectForKey:@"part2"];
            [_myTableView reloadData];
 
        }
       [HUD removeFromSuperview];

    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [HUD removeFromSuperview];
    }];

}



- (void)initTableView{

    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    }
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{

    return [[edataDic allKeys] count];

}



#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return partOneArray.count;
    }
    if (section ==1) {
        return partTwoArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identify = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            
        }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setUpCellContent:cell.contentView withfig:indexPath];
        return cell;
        
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 62;
}



//头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0,200, 30)];

    if(section == 0){
    label.text = @"Part 1";
    }else if(section == 1){
        label.text = @"Part 2&3";
    }
    else{
    label.text = @"";
    }
    [view addSubview:label];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return .1;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LoginViewController *loginVC = [[LoginViewController alloc]init];
//    [self presentViewController:loginVC animated:YES completion:^{
//        
//    }];
    
     PartOneDetailedController *partOneDetailedVC = [[PartOneDetailedController alloc]init];
    if (indexPath.section ==0) {

        partOneDetailedVC.titleName = [NSString stringWithFormat:@"Part 1 - %@",[partOneArray[indexPath.row]objectForKey:@"ename"]];
        partOneDetailedVC.upType = @"1";
        partOneDetailedVC.evalue = [partOneArray[indexPath.row]objectForKey:@"evalue"];
        
    } else if(indexPath.section ==1){
    
        partOneDetailedVC.titleName = [NSString stringWithFormat:@"Part 2&3 - %@",[partTwoArray[indexPath.row]objectForKey:@"ename"]];
        
        partOneDetailedVC.evalue = [partTwoArray[indexPath.row]objectForKey:@"evalue"];
        partOneDetailedVC.upType = @"2";
        
    }
      [self.navigationController pushViewController:partOneDetailedVC animated:YES];

}


- (void)RightItemAction{

    NewTopicViewController *NewTopicVC = [[NewTopicViewController alloc]init];
//    [self presentViewController:NewTopicVC animated:YES completion:^{
//        nil;
//    }];
    
    [self.navigationController pushViewController:NewTopicVC animated:YES];
}


- (void)setUpCellContent:(UIView *)subView withfig:(NSIndexPath*)dexpath{
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 50, 50)];
    image.image = [UIImage imageNamed:@"pic_default"];
    [subView addSubview:image];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,20, 200, 20)];
    contentLabel.textColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1];

    [subView addSubview:contentLabel];
    if (dexpath.section ==0) {
        NSString *thumb_img =[partOneArray[dexpath.row] objectForKey:@"thumb_img"];
        if (thumb_img&&![thumb_img isEqualToString:@""]) {
            [image setImageWithURL:[NSURL URLWithString:thumb_img]];
        }
        
        contentLabel.text = [partOneArray[dexpath.row] objectForKey:@"ename"];
        
    }else if (dexpath.section ==1){
    
        NSString *thumb_img =[partTwoArray[dexpath.row] objectForKey:@"thumb_img"];
        if (thumb_img&&![thumb_img isEqualToString:@""]) {
            [image setImageWithURL:[NSURL URLWithString:thumb_img]];
        }

        
         contentLabel.text =  [partTwoArray[dexpath.row] objectForKey:@"ename"];
    }
    
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
