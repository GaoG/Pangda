//
//  RelatedVideoViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/13.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "RelatedVideoViewController.h"
#import "RelatedVideoTableViewCell.h"

@interface RelatedVideoViewController ()<UITableViewDataSource,UITableViewDelegate>{


    UIView *mySuperView;
    float isShowBattery;
    
    
}


@end

@implementation RelatedVideoViewController{
// 记录下标
    NSInteger index;
// 记录下标
    NSInteger myIdentify;
//   titleView
    
    UIView *titleView;
//    线
    UILabel *lin;
//    返回按钮
    
    UIButton *backBut;
//     标题
    UILabel *titleLabel;
    
    NSString *viedoStr;
    NSUserDefaults *user;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user = [NSUserDefaults standardUserDefaults];
    
    
//    创建头部ui
    [self initTitleViewUI];
  
    
    
    
    index = 100000;
//    [self addTitleViewWithTitle:@"相关视频"];
//     [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    [self initTableView];
    
}


- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
}

/*
 ** 创建头部ui
 */
- (void)initTitleViewUI{


    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    titleView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:titleView];
    
    lin = [[UILabel alloc]initWithFrame:CGRectMake(0, titleView.height-.5, titleView.width, .5)];
    lin.backgroundColor = [UIColor lightGrayColor];
    [titleView addSubview:lin];
    
    backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(self.view.width-50, 32, 40, 20);
    [backBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
    [backBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateHighlighted];
    [backBut setTitle:@"取消" forState:UIControlStateNormal];
    backBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBut addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];

    [titleView addSubview:backBut];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.view.width, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"相关视频";
    [titleView addSubview:titleLabel];
}



- (void)initTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    }
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_myTableView];
    
}

/*
 **** tableviewDelegate
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *identify = @"RelatedVideoTableViewCell";
    RelatedVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil] lastObject];
    }
    

    if(indexPath.row == index){
        if (_videoView) {
      
            if (myIdentify == index) {
                
                [cell.contentView addSubview:_videoView];
                
            }else{
                
            
                [self initVideoView:viedoStr WithUpView:cell.contentView withindexPath:indexPath];
            
        }

        }else{
       
        [self initVideoView:viedoStr WithUpView:cell.contentView withindexPath:indexPath];
        }
        
        myIdentify = index;
    }
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"机经讲解";
        cell.detailsLabel.text = @"机经讲解 - patr2";
        cell.imageUrl = [_dataDic objectForKey:@"jijing_img"];
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"外教示范";
        cell.detailsLabel.text = @"外教示范 - patr2";
        cell.imageUrl = [_dataDic objectForKey:@"waijiao_img"];
        
    }else{
        cell.titleLabel.text = @"更多思路";
        cell.detailsLabel.text = @"更多思路 - patr2";
        cell.imageUrl = [_dataDic objectForKey:@"silu_img"];
    }
    cell.contentLabel.text = [_dataDic objectForKey:@"title"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{

    return KSCREENWIDTH*9/16+55;

    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

//    if (![user objectForKey:@"user_name"]) {
//        [self login];
//        return;
//    }
    
    
  
    
    index = indexPath.row;
    
    
    switch (indexPath.row) {
        case 0:
            viedoStr = [_dataDic objectForKey:@"answers_jijing"];
            break;
        case 1:
            viedoStr = [_dataDic objectForKey:@"answers_waijiao"];
            break;
        case 2:
            viedoStr = [_dataDic objectForKey:@"answers_silu"];
            break;
            
        default:
            break;
    }
//    if (indexPath.row ==0) {
//        
//    }
    
    

    [_myTableView reloadData];
}



#pragma mark 播放器的创建
- (void)initVideoView:(NSString *)videoUrl WithUpView:(UIView*)upView withindexPath:(NSIndexPath*)path{



    [_videoView removePlayingVideo];
    [_videoView removeFromSuperview];
    _videoView = nil;
    _videoView=[[VideoView alloc]initWithFrame:CGRectMake(0,0,KSCREENWIDTH,KSCREENWIDTH*9/16) andVIdeoUrl:videoUrl andPName:nil andfree:nil andIsAlbum:nil andImageURL:nil];
    _videoView.delegate=self;
    [upView addSubview:_videoView];
    
  
    
}


- (void)isFullGreen{
    
    mySuperView =  _videoView.superview;
    
    [_videoView removeFromSuperview];
    [self.view addSubview:_videoView];

    self.navigationController.navigationBarHidden=YES;
    
    isShowBattery = 2;
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    
    [UIView animateWithDuration:.25 animations:^{
        
        _videoView.transform = CGAffineTransformMakeRotation(M_PI*-1.5);
        _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    
}



- (void)isNFullGreen{


    [_videoView removeFromSuperview];
    [mySuperView addSubview:_videoView];
    
    isShowBattery = 1;
    self.navigationController.navigationBarHidden=NO;
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    
    [UIView animateWithDuration:.15 animations:^{
        _videoView.transform = CGAffineTransformMakeRotation(2.0f * M_PI);
        _videoView.frame = CGRectMake(0,0,KSCREENWIDTH,KSCREENWIDTH*9/16);
    }];
    
    

}

- (BOOL)prefersStatusBarHidden{
    
    
    if (isShowBattery == 2) {
        
        return YES;//隐藏为YES，显示为NO
    }else if(isShowBattery == 1) {
        return NO;
        
    }
    
    return nil;
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"RelatedVideoViewController"];
    
    [_myTableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RelatedVideoViewController"];
}




/*
 **** 返回上一级
 */

- (void)leftBackAction{

    [_videoView  removePlayingVideo];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//
//#pragma mark 登录
//- (void)login{
//    
//    
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    
//    // 显示主控制器（登录界面）
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
//    
//    UINavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"navgationController"];
//    
////    UIViewController *VC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
//    
//    
//    [self presentViewController:nav animated:YES completion:^{
//        
//    }];
//    
//    
//    
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
