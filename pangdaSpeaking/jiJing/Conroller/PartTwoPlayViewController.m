//
//  PartTwoPlayViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartTwoPlayViewController.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
#import "PartTwoPlayfirstCell.h"
#import "PartTwoPlaySecondCell.h"
#import "AVFoundation/AVFoundation.h"
#import "RelatedVideoViewController.h"
#import "HightWordViewController.h"
#import "PartThreeViewController.h"
@interface PartTwoPlayViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>


@property (nonatomic,strong)UIView *bJbottomView;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIButton *answerBut;
@property (nonatomic,strong)UIButton *wordBut;
@property (nonatomic,strong)UIButton *videoBut;
@property (nonatomic,strong)UIButton *mp3But;
@property (nonatomic,copy) AVAudioPlayer *player;

@end

@implementation PartTwoPlayViewController{

    CGSize _size;
    NSMutableArray *ecodeArray;
    MBProgressHUD *HUD;
    UIWindow *window;
    UIButton *recordBut;
    UIButton *playBut;
    NSMutableArray *partListArray;
    BOOL isShow;
    NSUserDefaults *user;
    
    
    NSMutableArray *gaofenciTwoArray;
    NSMutableArray *partListThreeArray;
    
    AVAudioRecorder *recorder;
    NSURL *tmpFile;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user = [NSUserDefaults standardUserDefaults];
    ecodeArray = [[NSMutableArray alloc]init];
    gaofenciTwoArray = [[NSMutableArray alloc]init];
    partListThreeArray = [[NSMutableArray alloc]init];
    partListArray = [[NSMutableArray alloc]init];
    _size = [UIScreen mainScreen].bounds.size;
    window = [[UIApplication sharedApplication]keyWindow];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];
    
    
    
     [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    [self initbottomView];
    [self requstData];
    [self initTableView ];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadTableViewAction:) name:@"partTwoReloadTableView" object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PartTwoPlayViewController"];
    [self addTitleViewWithTitle:_titleName];
}


#pragma mark 数据请求
- (void)requstData{
    
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:window];

    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&m=api&c=content&a=contentinfo&mobile=%@&version=%@&devtype=iOS&id=%@",REQUSTHTTPURL,[user objectForKey:@"user_name"],appCurVersion,_myId];
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            ecodeArray = [starDic objectForKey:@"edata"];
            
            gaofenciTwoArray = [[ecodeArray lastObject]objectForKey:@"gaofenci"];
            [self addArray:partListArray withFromArray:[[ecodeArray lastObject]objectForKey:@"part2List"]];
        partListThreeArray = [[ecodeArray lastObject]objectForKey:@"part3List"];
            
            
//            NSLog(@"%@",  partListArray);
            
            [_myTableView reloadData];
            
        }
        
        [HUD removeFromSuperview];
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
         [HUD removeFromSuperview];
    }];

}


#pragma mark 底部的背景
- (void)initbottomView{
    _bJbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _size.height-46, _size.width, 46)];
    
    _bJbottomView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:.95];
    
    [self.view addSubview:_bJbottomView];
    
    
    _answerBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerBut.frame = CGRectMake(_size.width/12, 7, 35, 32);
    
    [_answerBut setBackgroundImage:[UIImage imageNamed:@"icon_answer_n"] forState:UIControlStateNormal];
    [_answerBut setBackgroundImage:[UIImage imageNamed:@"icon_answer_h"] forState:UIControlStateHighlighted];
    [_answerBut addTarget:self action:@selector(answerButAction) forControlEvents:UIControlEventTouchUpInside];
    [_bJbottomView addSubview:_answerBut];
    
    
    _wordBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _wordBut.frame = CGRectMake((_size.width/12)*4, 7, 35, 32);
    
    [_wordBut setBackgroundImage:[UIImage imageNamed:@"icon_word_n"] forState:UIControlStateNormal];
    [_wordBut setBackgroundImage:[UIImage imageNamed:@"icon_word_h"] forState:UIControlStateHighlighted];
     [_wordBut addTarget:self action:@selector(gaofenciAction) forControlEvents:UIControlEventTouchUpInside];
    [_bJbottomView addSubview:_wordBut];
    
    
    _videoBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoBut.frame = CGRectMake((_size.width/12)*7, 7, 35, 32);
    
    [_videoBut setBackgroundImage:[UIImage imageNamed:@"icon_video_n"] forState:UIControlStateNormal];
    [_videoBut setBackgroundImage:[UIImage imageNamed:@"icon_video_h"] forState:UIControlStateHighlighted];
    [_videoBut addTarget:self action:@selector(videoButAction) forControlEvents:UIControlEventTouchUpInside];
    [_bJbottomView addSubview:_videoBut];
    
    
    
    _mp3But = [UIButton buttonWithType:UIButtonTypeCustom];
    _mp3But.frame = CGRectMake((_size.width/12)*10, 7, 35, 32);
    
    [_mp3But setBackgroundImage:[UIImage imageNamed:@"icon_P3_n"] forState:UIControlStateNormal];
    [_mp3But setBackgroundImage:[UIImage imageNamed:@"icon_P3_h"] forState:UIControlStateHighlighted];
    
    [_mp3But addTarget:self action:@selector(mp3ButAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_bJbottomView addSubview:_mp3But];
    
    
}


- (void)initTableView{


    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-110) style:UITableViewStylePlain];
    }
    //    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
  
       return  [self calculateTheWarriorContent:[[ecodeArray lastObject]objectForKey:@"title"]].height+75;
        
    }
    
   return  [self calculateTheWarriorContent:[partListArray[indexPath.row-1] objectForKey:@"p2_english"]].height+
    [self calculateTheWarriorContent:[partListArray[indexPath.row-1] objectForKey:@"p2_chines"]].height+80;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isShow) {
        return  partListArray.count+1;
    }
   
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *identify = @"PartTwoPlayfirstCell";
        PartTwoPlayfirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        }

        cell.dataDic = [ecodeArray lastObject];
        
//        block 的实现
        if (!cell.playOrRecodeBlock) {
            cell.playOrRecodeBlock = ^(NSString *strOne,NSString *strTwo){
                
                [self recoderOrplayRecoder:strOne withId:strTwo];
            };
        };
        
        
        /*
         **播放按钮
         */
        if ([[user objectForKey:@"playButId"]isEqualToString:[[ecodeArray lastObject] objectForKey:@"id"]]){
        
            cell.playBut.selected = YES;
        }
        
        /*
         **录音按钮
         */
        if ([[user objectForKey:@"P2_recordId"]isEqualToString:[[ecodeArray lastObject] objectForKey:@"id"]]){
            
            cell.recordBut.selected = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *identify = @"PartTwoPlaySecondCell";
    PartTwoPlaySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    }
    
    /*
     **播放按钮
     */
    cell.dataDic = partListArray[indexPath.row-1];
    
    if ([[user objectForKey:@"playButId"]isEqualToString:[partListArray[indexPath.row-1] objectForKey:@"id"]]){
        

        cell.playBut.selected = YES;
    }
    
    /*
     **录音按钮
     */
    
    if ([[user objectForKey:@"P2_recordId"]isEqualToString:[partListArray[indexPath.row-1] objectForKey:@"id"]]){
        
        cell.recodrBut.selected = YES;
    }
    
    
    //        block 的实现
    if (!cell.playOrRecodeBlock) {
        cell.playOrRecodeBlock = ^(NSString *strOne,NSString *strTwo){
            
            [self recoderOrplayRecoder:strOne withId:strTwo];
        };
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}



- (void)addArray:(NSMutableArray *)manArray withFromArray:(NSMutableArray *)subArray{

    for (id sub in subArray) {
        [manArray addObject:sub];
    }
    
}


- (void)answerButAction{

    isShow = !isShow;
    
    [_myTableView reloadData];


}


#pragma mark 返回上一级
- (void)leftBackAction{
    
    [_player pause];
    _player = nil;
    if ([_upClass isEqualToString:@"1"]) {
        
        self.playBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}
#pragma mark 通知的事件的实现
- (void)reloadTableViewAction:(NSNotification*)center{
    
    
    
    NSLog(@"%@",center.userInfo);
    
    if (_myTableView){
    
    [_myTableView reloadData];
    
    }
    
    [self initplayer:center.userInfo];
}


- (void)initplayer:(NSDictionary *)dic{
    
    if (dic&&[[dic allKeys]count]>0) {
        
        
        _player = nil;
        
        NSString * playUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"location"]];
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:playUrl] error:nil];
        
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
         _player.delegate = self;
        [_player play];
       
    }else{
        
        [_player pause];
    }
}


- (CGSize )calculateTheWarriorContent:(NSString *)text{
    
    
    CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(KSCREENWIDTH-20, CGFLOAT_MAX)];
    
    return sizeToFit;
}


#pragma mark 音频播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;{

    [user setObject:nil forKey:@"P2_hearButBool"];
    [user setObject:nil forKey:@"playButId"];
    [user synchronize];
    [_myTableView reloadData];

}


#pragma mark 录音或播放录音
- (void)recoderOrplayRecoder:(NSString *)str withId:(NSString *)strTwo{
    
    
    if ([str isEqualToString:@"1"]) {
        [self recordAction:@"1" withId:strTwo];
    }else if ([str isEqualToString:@"2"]){
        [self playRecoderAction:@"2" withStrTwo:strTwo];
        
    }
    
    
}

/*
 *** 录音的实现
 */
#pragma mark 录音功能的实现
/*
 *** 录音功能的实现
 */

- (void)recordAction:(NSString *)str withId:(NSString *)strTwo{
    
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    if (strTwo) {
        //        recording = YES;
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
        //然后直接把文件保存成.wav就好了
        NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        //        tmpFile = [NSURL fileURLWithPath:
        //                   [ NSHomeDirectory() stringByAppendingPathComponent:
        //                    [NSString stringWithFormat: @"%@.%@",
        //                     file,
        //                     @"caf"]]];
        tmpFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",cachePath,[NSString stringWithFormat: @"luyin.%@",@"caf"]]];
        [user setObject:[NSString stringWithFormat:@"%@",tmpFile] forKey:@"tmpFile"];
        recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:setting error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    } else {

        [audioSession setActive:NO error:nil];
        [recorder stop];
        
    }
    
}


#pragma mark 播放录音功能的实现
/*
 *** 播放录音功能的实现
 */

- (void)playRecoderAction:(NSString *)str withStrTwo:(NSString *)strTwo{
    
    if (!strTwo) {
        [_player pause];
        return;
    }
    
    
    _player = nil;
    NSError *error;
    
    
    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"tmpFile"]]error:&error];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _player.volume=1;
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    _player.delegate = self;
    //准备播放
    [_player prepareToPlay];
    //播放
    [_player play];
    
    
}


/*
 ** 高分词的实现
 */
#pragma mark 高分词的事件
- (void)gaofenciAction{
    HightWordViewController *HightWordVC = [[HightWordViewController alloc]init];

    HightWordVC.dataArr = gaofenciTwoArray;
    HightWordVC.myTitle = @"Part 2&3 高分词汇";
    [self presentViewController:HightWordVC animated:YES completion:^{
        
    }];
    
    
    
}
/*
 **** part3 的事件的实现
 */

- (void)mp3ButAction{

    PartThreeViewController *PartThreeVC = [[PartThreeViewController alloc]init];

    PartThreeVC.dataArr = partListThreeArray;
    [self presentViewController:PartThreeVC animated:YES completion:^{
        
    }];

}



/*
 **** 视频事件
 */
- (void)videoButAction{
    
    RelatedVideoViewController *RelatedVideoVC = [[RelatedVideoViewController alloc]init];
    
    if (ecodeArray.count>0) {
         RelatedVideoVC.dataDic = [self setUpDictionary];
    }
   
    [self presentViewController:RelatedVideoVC animated:YES completion:^{
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  

}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"PartTwoPlayViewController"];
    [_player pause];
    _player = nil;
    [recorder stop];
    recorder = nil;
    [user setObject:nil forKey:@"playButId"];
    
    [user setObject:nil forKey:@"P2_recordId"];
    
    [user setObject:nil forKey:@"P2_hearId"];
    
    [user setObject:nil forKey:@"P2_hearButBool"];
    [user synchronize];
}


/*
 **** 设置相关视频数据的字典
 */


- (NSMutableDictionary *)setUpDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[[ecodeArray lastObject]objectForKey:@"jijing_img"] forKey:@"jijing_img"];
    [dic setObject:[[ecodeArray lastObject]objectForKey:@"answers_jijing"] forKey:@"answers_jijing"];
    [dic setObject:[[ecodeArray lastObject]objectForKey:@"silu_img"] forKey:@"silu_img"];
     [dic setObject:[[ecodeArray lastObject]objectForKey:@"answers_silu"] forKey:@"answers_silu"];
    
    [dic setObject:[[ecodeArray lastObject]objectForKey:@"waijiao_img"] forKey:@"waijiao_img"];
    [dic setObject:[[ecodeArray lastObject]objectForKey:@"answers_waijiao"] forKey:@"answers_waijiao"];
    
    
    [dic setObject:_titleName forKey:@"title"];
    
    return dic;
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
