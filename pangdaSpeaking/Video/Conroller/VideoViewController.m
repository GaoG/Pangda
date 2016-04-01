//
//  VideoViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/20.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
#import "TodayUpVideoCell.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
#import "ImageTableViewCell.h"
@interface VideoViewController (){

   
    CGSize _size;
    NSMutableDictionary *edataDic;
    NSMutableArray *titleArr;
    MBProgressHUD *HUD;
    NSMutableArray *imagearr;
    NSInteger newSign;
    NSUserDefaults *user;
    
    

}



@property (nonatomic,strong)UITableView *myTableView;
@end


@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];
    imagearr = [[NSMutableArray alloc]init];
    edataDic = [[NSMutableDictionary alloc]init];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"机经讲解",@"外教示范",@"更多思路", nil];
    
    
    _size = [UIScreen mainScreen].bounds.size;
    [self addTitleViewWithTitle:@"视频"];
    [self  requstData];
    [self imageRequstData];
   
    

    [self inittableView];
    
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
    [self.view addSubview:_myTableView];

}

- (void)imageRequstData{


     NSString *httpUrl = [NSString stringWithFormat:@"%@m=api&c=Advert&a=index&devtype=iOS&appid=1&mobile=%@",REQUSTHTTPURL,[user objectForKey:@"user_name"]];
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            imagearr = [starDic objectForKey:@"edata"];
            
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        }
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);

    }];
    

}


#pragma mark 数据请求
- (void)requstData{

     HUD = [MBProgressHUD showMessage:@"加载中...." toView:[[UIApplication sharedApplication]keyWindow]];
    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&m=api&c=Video&a=indexVideo&mobile=%@&version=%@&devtype=iOS",REQUSTHTTPURL,[user objectForKey:@"usre_name"],appCurVersion];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            edataDic = [starDic objectForKey:@"edata"];
            [edataDic removeObjectForKey:@"new"];
//            if ([[edataDic objectForKey:@"new"]count]==0){
//                newSign = 1;
//            }else{
//                newSign = 0;
//            }
            
            [_myTableView reloadData];
        }
        
        [HUD removeFromSuperview];
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
          [HUD removeFromSuperview];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"VideoViewController"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"no"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"VideoViewController"];
}



#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (edataDic) {
//        if ([[edataDic objectForKey:@"new"]count]>1){
//            return 5;
//        }
        
      return 4;
    }
    return 0;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {

        static NSString *identifi = @"ImageTableViewCell";
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ImageTableViewCell" owner:self options:nil]lastObject];
        }
        
               cell.dataarr = imagearr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


        return cell;
    }
//    if ([[edataDic objectForKey:@"new"]count]>1) {
//        
//    
//     if(indexPath.row == 1){
//    
//    static NSString *identify = @"TodayUpVideoCell";
//        TodayUpVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.dataDic = [edataDic objectForKey:@"new"];
//        return cell;
//        
//    }
//    }
        static NSString *identify = @"VideoTableViewCell";
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[edataDic objectForKey:@"new"]count]>1){
        cell.titleName.text =titleArr[indexPath.row-2];
    }else{
    cell.titleName.text =titleArr[indexPath.row-1];
    }
    
        if (indexPath.row ==1) {
        cell.dataArray = [edataDic objectForKey:@"jijing"];
        cell.part = @"jijing";
        }else if (indexPath.row ==2){
        cell.dataArray = [edataDic objectForKey:@"waijiao"];
            cell.part = @"waijiao";
        }else if (indexPath.row ==3){
            cell.dataArray = [edataDic objectForKey:@"silu"];
            cell.part = @"silu";
        }
    
    
        return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 160;
    }
//    if ([[edataDic objectForKey:@"new"]count]>1) {
//        if(indexPath.row == 1){
//            
//            return 120;
//        }
//    }
    
    

    return 200;
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
