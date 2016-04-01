//
//  PlayVideoViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayVideoInterrelatedCell.h"
#import "PartOnePlayViewController.h"
#import "PartTwoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>



@interface PlayVideoViewController ()

@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation PlayVideoViewController{

    UIView *bjView;
    MBProgressHUD *HUD;
    UILabel *titleName;
    UILabel *contentName;
    NSMutableDictionary *starDic;

    NSMutableArray *relevantArray;
    NSMutableDictionary *waijiao;
    NSMutableDictionary *jijing;
    NSMutableDictionary *silu;
    NSString *playUrlStr;
    NSString *newImageURL;
    NSUserDefaults *user;
    float isShowBattery;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    
    user = [NSUserDefaults standardUserDefaults];
    relevantArray = [[NSMutableArray alloc]init];
    waijiao = [[NSMutableDictionary alloc]init];
    jijing = [[NSMutableDictionary alloc]init];
    silu = [[NSMutableDictionary alloc]init];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    
    [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrames:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
 

    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];
    
    NSLog(@"%@", self.part);
    NSString *myTitle;
    if ([self.part isEqualToString:@"jijing"]) {
        myTitle = @"机经讲解";
    }else if ([self.part isEqualToString:@"waijiao"]) {
        myTitle = @"外教示范";
    }else if ([self.part isEqualToString:@"silu"]) {
        myTitle = @"更多思路";
    }else{
    
         myTitle = @"视频详情";
    }
    
    
    [self addTitleViewWithTitle:myTitle];
    [self initTableView];
//    [self initVideoView];
    

    [self initVodeiTitleName];
    [self requstData];
    
    
}







- (void)requstData{

    HUD = [MBProgressHUD showMessage:@"加载中...." toView:[[UIApplication sharedApplication]keyWindow]];
    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&m=api&c=Video&a=infoVideo&part=%@&type=%@&mobile=%@&version=%@&devtype=iOS&id=%@",REQUSTHTTPURL,_part,_type,[user objectForKey:@"user_name"],appCurVersion,_myId];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        starDic = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil]];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            
            
            [self sortingData];
            
            if ([_part isEqualToString:@"jijing"]) {

                [self initVideoView:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_jijing"]andImageURL:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"jijing_img"]];
                
                contentName.text = [NSString stringWithFormat:@"机经讲解 - %@",[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"part"]];
                
                [relevantArray removeObject:jijing];
            }else if ([_part isEqualToString:@"waijiao"]){
            [self initVideoView:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_waijiao"] andImageURL:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"waijiao_img"]];
                
                contentName.text = [NSString stringWithFormat:@"外教示范 - %@",[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"part"]];
                
            [relevantArray removeObject:waijiao];
                
            }else if ([_part isEqualToString:@"silu"]){
                [self initVideoView:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_silu"]andImageURL:[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"silu_img"]];
                
                contentName.text = [NSString stringWithFormat:@"更多思路 - %@",[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"part"]];
                [relevantArray removeObject:silu];
            }
            
           
            titleName.text = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"problem"];
            
        }
        
        [_myTableView reloadData];
        
        [HUD removeFromSuperview];
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [HUD removeFromSuperview];
    }];

}



#pragma mark 播放器的创建
//
- (void)initVideoView:(NSString *)videoUrl andImageURL:(NSString *)imageURL{
    
    playUrlStr = videoUrl;
    newImageURL = imageURL;
    [_videoView removePlayingVideo];
    [_videoView removeFromSuperview];
    _videoView = nil;
    
    
    _videoView=[[VideoView alloc]initWithFrame:CGRectMake(0,64,KSCREENWIDTH,KSCREENWIDTH*9/16) andVIdeoUrl:videoUrl andPName:nil andfree:nil andIsAlbum:nil andImageURL:imageURL];
    _videoView.delegate=self;
    [self.view addSubview:_videoView];

  }


/*
 ***创建vodel上面的名称
 */
- (void)initVodeiTitleName{


    
    bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+KSCREENWIDTH*9/16, self.view.width, 70)];
    
    [self.view addSubview:bjView];
    
    
    
    titleName = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, bjView.width-16, 20)];
    titleName.font = [UIFont systemFontOfSize:15];
    titleName.textColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1];
    [bjView addSubview:titleName];
    
    contentName = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 200, 20)];
    contentName.font = [UIFont systemFontOfSize:12];
    contentName.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    [bjView addSubview:contentName];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, bjView.height-.5, bjView.width-20, .5)];
    line.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [bjView addSubview:line];
    
    
    UIButton *seeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeBut setFrame:CGRectMake(bjView.width-70, 30, 60, 20)];
    seeBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [seeBut setTitleColor:[UIColor colorWithRed:255/255.0 green:81/255.0 blue:21/255.0 alpha:1] forState:UIControlStateNormal];
    [ seeBut setTitle:@"查看题目" forState:UIControlStateNormal];
    
    
    [seeBut addTarget:self action:@selector(seeButAction) forControlEvents:UIControlEventTouchUpInside];
    [bjView addSubview:seeBut];
    
    
    UIButton *imageBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBut setFrame:CGRectMake(bjView.width-100, 34, 14, 13)];
    [imageBut setImage:[UIImage imageNamed:@"icon_write_"] forState:UIControlStateNormal];
    [imageBut setImage:[UIImage imageNamed:@"icon_write_"] forState:UIControlStateHighlighted];
    [imageBut addTarget:self action:@selector(seeButAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bjView addSubview:imageBut];
    


}


// 当屏幕的重力方向改变时调用
//
//-(void)changeFrames:(NSNotification *)notification
//{
//    float width=[[UIScreen mainScreen]bounds].size.width;
//    float height=[[UIScreen mainScreen]bounds].size.height;
//    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait
//        )
//    {
//        [[self navigationController] setNavigationBarHidden:NO animated:YES];
//
//        
//        [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
//        
//        [UIView animateWithDuration:.3 animations:^{
//           
////             [_videoView changeFrame:NO andFrame:CGRectMake(0, 0, height,width)];
//        }];
//       
//    }
//    else if( [[UIDevice currentDevice] orientation]== UIInterfaceOrientationLandscapeRight)
//    {
////        [[UIDevice currentDevice] orientation]== UIInterfaceOrientationLandscapeRight||
//        
////        [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(0, 0, 0, 0) selector:nil location:YES];
//        
//        [UIView animateWithDuration:.3 animations:^{
//            [[self navigationController] setNavigationBarHidden:YES animated:YES];
//        }];
//        
//        
////        [_videoView changeFrame:YES andFrame:CGRectMake(0, 0, height,width)];
//    }
//    
//}



#pragma 相关视频

- (void)initTableView{
    
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 110+KSCREENWIDTH*9/16, self.view.width-20, self.view.height-(120+KSCREENWIDTH*9/16)) style:UITableViewStylePlain];
    }
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.scrollEnabled =NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_myTableView];
    
    UILabel *correlationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,145+KSCREENWIDTH*9/16, KSCREENWIDTH, 20)];
    correlationLabel.text = @"相关视频";
    correlationLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:correlationLabel];
    
    
    
}


#pragma tableViewDeletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return relevantArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"PlayVideoInterrelatedCell";

    PlayVideoInterrelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        
    }

    
    cell.dataDic = relevantArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
    
}


/*
 *
 **** tableviewDeletage
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSString *title = [[relevantArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    if([title isEqualToString:@"外教示范"]){
        

        [relevantArray removeAllObjects];
        [relevantArray addObjectsFromArray:@[silu,jijing]];
        [self initVideoView:[waijiao objectForKey:@"mp4url"]andImageURL:[waijiao objectForKey:@"waijiao_img"]];
        contentName.text = [NSString stringWithFormat:@"%@ - %@",[waijiao objectForKey:@"title"],[waijiao objectForKey:@"part"]];
    }else if ([title isEqualToString:@"机经讲解"]){

        [relevantArray removeAllObjects];
        [relevantArray addObjectsFromArray:@[silu,waijiao]];
        [self initVideoView:[jijing objectForKey:@"mp4url"]andImageURL:[jijing objectForKey:@"jijing_img"]];
        contentName.text = [NSString stringWithFormat:@"%@ - %@",[jijing objectForKey:@"title"],[jijing objectForKey:@"part"]];
        
    }else if ([title isEqualToString:@"更多思路"]){

        
        [relevantArray removeAllObjects];
        [relevantArray addObjectsFromArray:@[jijing,waijiao]];
         [self initVideoView:[silu objectForKey:@"mp4url"]andImageURL:[silu objectForKey:@"silu_img"]];
        contentName.text = [NSString stringWithFormat:@"%@ - %@",[silu objectForKey:@"title"],[silu objectForKey:@"part"]];
        
    }
        
    
    [_myTableView reloadData];


}


#pragma mark 查看题目

- (void)seeButAction{

    [_videoView removePlayingVideo];
    [_videoView removeFromSuperview];
    _videoView = nil;
    
    NSString *idType = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"part"];
    if ([idType isEqualToString:@"part1"]) {
      
        PartOnePlayViewController *PartOnePlayVC = [[PartOnePlayViewController alloc]init];
//        PartOnePlayVC.titleName = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"categoryname"];
        PartOnePlayVC.titleName = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"problem"];
        PartOnePlayVC.playBlock = ^(){
            [self initVideoView:playUrlStr andImageURL:newImageURL];
            
        };
        PartOnePlayVC.upClass = @"1";
        
        PartOnePlayVC.myId = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"cateid"];
        
        [self.navigationController pushViewController:PartOnePlayVC animated:YES];
        
    }else if ([idType isEqualToString:@"part2"]){
    
        PartTwoPlayViewController *PartTwoPlayVC = [[PartTwoPlayViewController alloc]init];
        
//        PartTwoPlayVC.titleName = [NSString stringWithFormat:@"%@ - %@",[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"categoryname"],[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"categoryname_e"]];
        
        PartTwoPlayVC.titleName = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"problem"];
        PartTwoPlayVC.playBlock = ^(){
            [self initVideoView:playUrlStr andImageURL:newImageURL];
        
        };
        PartTwoPlayVC.upClass = @"1";
        PartTwoPlayVC.myId = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"id"];
        
        
        [self.navigationController pushViewController:PartTwoPlayVC animated:YES];

    }
}

#pragma mark 返回上一级
- (void)leftBackAction{
    [_videoView removePlayingVideo];
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
 **** 整理数据
 */
- (void)sortingData{
    NSString *image = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"images"];
    if (!image) {
        image = @"";
    }
    NSString *part = [[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"part"];
    
    if (!part) {
        part = @"";
    }
    
    NSString *problem =[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"problem"];
    
    if (!problem) {
        problem = @"";
    }
    
    waijiao = [[NSMutableDictionary alloc]initWithObjects:@[@"外教示范",image,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_waijiao"],part,problem,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"waijiao_img"]] forKeys:@[@"title",@"image",@"mp4url",@"part",@"problem",@"waijiao_img"]];

    
    [relevantArray addObject:waijiao];
    
    jijing = [[NSMutableDictionary alloc]initWithObjects:@[@"机经讲解",image,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_jijing"],part,problem,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"jijing_img"]] forKeys:@[@"title",@"image",@"mp4url",@"part",@"problem",@"jijing_img"]];
    

    
    [relevantArray addObject:jijing];
    
    
      silu = [[NSMutableDictionary alloc]initWithObjects:@[@"更多思路",image,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"answers_silu"],part,problem,[[[starDic objectForKey:@"edata"]lastObject]objectForKey:@"silu_img"]] forKeys:@[@"title",@"image",@"mp4url",@"part",@"problem",@"silu_img"]];

    
//    
    [relevantArray addObject:silu];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PlayVideoViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    

    [MobClick endLogPageView:@"PlayVideoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)isFullGreen;{

    
    self.navigationController.navigationBarHidden=YES;
    
    isShowBattery = 2;

    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    [UIView animateWithDuration:.25 animations:^{
        
        _videoView.transform = CGAffineTransformMakeRotation(M_PI*-1.5);
        _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}
-(void)isNFullGreen;{


    isShowBattery = 1;
    
     self.navigationController.navigationBarHidden=NO;
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    
    [UIView animateWithDuration:.25 animations:^{
        _videoView.transform = CGAffineTransformMakeRotation(2.0f * M_PI);
        _videoView.frame = CGRectMake(0,64,KSCREENWIDTH,KSCREENWIDTH*9/16);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
