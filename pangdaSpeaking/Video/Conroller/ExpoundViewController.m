//
//  ExpoundViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ExpoundViewController.h"
#import "ExpoundTableViewCell.h"
#import "PlayVideoViewController.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
@interface ExpoundViewController (){

    UIView *bjView;
    UILabel *bjLabel;
    NSString *part;
    NSString *type;
    MBProgressHUD *HUD;
    NSMutableArray *edataArray;
    UILabel *lin;
    NSUserDefaults *user;

}

@property (nonatomic,strong)UIButton *PartOnebut;
@property (nonatomic,strong)UIButton *PartTwobut;
@property (nonatomic,strong)UITableView *myNewTableView;


@end

@implementation ExpoundViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];
    
    
    edataArray = [[NSMutableArray alloc]init];
    part = @"2";
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];
    
    
     [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    [self initSeledtBut];
    [self initTableView];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ExpoundViewController"];
    [self addTitleViewWithTitle:_titleName];
    [self stringFromString];
    [self requstData];
    
//    lin = [[UILabel alloc]initWithFrame:CGRectMake(0, 62, KSCREENWIDTH, 5)];
//    
//    lin.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
//   
//    [ [[UIApplication sharedApplication]keyWindow] addSubview:lin];
    
}




#pragma mark 创建按钮选项
- (void)initSeledtBut{
//    背景view
    
    
    if (!bjView) {
        bjView  = [[UIView alloc]initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width , 40)];
    }
    bjView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    bjView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bjView];
    

// part 1
    if (!_PartOnebut){
        _PartOnebut = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _PartOnebut.frame = CGRectMake(0, 0, bjView.bounds.size.width/2-.5, 40);
    [_PartOnebut setTitle:@"Part 1" forState:UIControlStateNormal];
    [_PartOnebut setTitleColor:[UIColor colorWithRed:58/255.0 green:58/255.0  blue:58/255.0  alpha:1] forState:UIControlStateNormal];

    [_PartOnebut setTitleColor:[UIColor colorWithRed:255/255.0 green:81/255.0 blue:19/255.0 alpha:1] forState:UIControlStateSelected];
    [_PartOnebut addTarget:self action:@selector(PartOnebutAction:) forControlEvents:UIControlEventTouchUpInside];
    _PartOnebut.selected = YES;
//    [bjView addSubview:_PartOnebut];
    
//    竖线
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(bjView.bounds.size.width/2-.5, 5, 1, 30)];
    lineImage.image = [UIImage imageNamed:@"sign_-1"];
//    [bjView addSubview:lineImage];
    
    
    
//    patrt 2
    if (!_PartTwobut){
        _PartTwobut = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _PartTwobut.frame = CGRectMake(bjView.bounds.size.width/2+.5, 0, bjView.bounds.size.width/2-1, 40);
    [_PartTwobut setTitle:@"Part 2" forState:UIControlStateNormal];
    [_PartTwobut setTitleColor:[UIColor colorWithRed:58/255.0 green:58/255.0  blue:58/255.0  alpha:1] forState:UIControlStateNormal];
    [_PartTwobut setTitleColor:[UIColor colorWithRed:255/255.0 green:81/255.0 blue:19/255.0 alpha:1] forState:UIControlStateSelected];
    [_PartTwobut addTarget:self action:@selector(PartTwobutAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bjView addSubview:_PartTwobut];
    
//    下划线
    if(!bjLabel){
    
        bjLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40 , bjView.bounds.size.width/2, 1)];
    
    }
    bjLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:81/255.0 blue:19/255.0 alpha:1];
    
//    [bjView addSubview:bjLabel];
    
    
}

#pragma mark 数据请求
- (void)requstData{

    
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:[[UIApplication sharedApplication]keyWindow]];
    
    
    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&m=api&c=Video&a=moreVideo&part=%@&type=%@&limit=20&mobile=%@&version=%@&devtype=iOS",REQUSTHTTPURL,part,type,[user objectForKey:@"user_name"],appCurVersion];
    
        [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
            NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            
            if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
                edataArray = [starDic objectForKey:@"edata"];
                [_myNewTableView reloadData];
            }

            [HUD removeFromSuperview];
        } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [HUD removeFromSuperview];
            
        }];

}


#pragma mark tableview 的创建
- (void)initTableView{

    if (!_myNewTableView) {
        
        _myNewTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    }
    _myNewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myNewTableView.dataSource = self;
    _myNewTableView.delegate = self;
    _myNewTableView.showsHorizontalScrollIndicator = NO;
    _myNewTableView.showsVerticalScrollIndicator = NO;
//    _myNewTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_myNewTableView];

}



#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return edataArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *identify = @"ExpoundTableViewCell";
        
        ExpoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
            
        }
    
    cell.dataDic = edataArray[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:253/255.0 green:244/255.0 blue:241/255.0 alpha:1];
        return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PlayVideoViewController *playVideoVC = [[PlayVideoViewController alloc]init];
    playVideoVC.myId = [edataArray[indexPath.row]objectForKey:@"id"];
    if ([type isEqualToString:@"gengduo"]) {
        playVideoVC.part = @"silu";
    }else{
     playVideoVC.part = type;
    }
    playVideoVC.type = [edataArray[indexPath.row]objectForKey:@"part"];
    [self.navigationController pushViewController:playVideoVC animated:YES];
}


#pragma mark partone点击事件
- (void)PartOnebutAction:(UIButton *)but{

    _PartOnebut.selected = YES;
    _PartTwobut.selected = NO;

//      part = @"1";
    [self BjLabelAnimation:1];
  
    
}

#pragma mark parttwo点击事件
- (void)PartTwobutAction:(UIButton *)but{

//    _PartOnebut.selected = NO;
//    _PartTwobut.selected = YES;
    
//    part = @"2";
//    [self BjLabelAnimation:2];
    
}


#pragma mark 下划线背景的动画
- (void)BjLabelAnimation:(NSInteger)identify{

    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:.35];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    if (identify ==1) {
        
    bjLabel.frame=CGRectMake(0,40 , bjView.bounds.size.width/2, 1);
        
    }else if (identify ==2){
    
    bjLabel.frame=CGRectMake(bjView.bounds.size.width/2,40 , bjView.bounds.size.width/2, 1);
    }
    [UIView commitAnimations];
    
    
    [self requstData];
    
}

#pragma mark 返回上一级
- (void)leftBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    [lin removeFromSuperview];
    
    
}

- (void)stringFromString{

    if ([_titleName isEqualToString:@"机经讲解"]) {
        type = @"jijing";
    }
    if ([_titleName isEqualToString:@"更多思路"]) {
        type = @"gengduo";
    }
    if ([_titleName isEqualToString:@"外教示范"]) {
        type = @"waijiao";
    }
}



- (void)viewWillDisappear:(BOOL)animated; {

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ExpoundViewController"];
    [lin removeFromSuperview];
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
