//
//  PartOnePlayViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartOnePlayViewController.h"
#import "PartOnePlayCell.h"
#import "ILHttpTool.h"
#import "MBProgressHUD+CZ.h"
#import "AVFoundation/AVFoundation.h"
#import "HightWordViewController.h"
@interface PartOnePlayViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (nonatomic,strong)UIView *bJbottomView;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIButton *answerBut;
@property (nonatomic,strong)UIButton *wordBut;
@property (nonatomic,strong)UIButton *videoBut;
@property (nonatomic,copy) AVAudioPlayer *player;


@end

@implementation PartOnePlayViewController{

    CGSize _size;
    
    BOOL isShowAnswer;
    UIWindow *window;
    MBProgressHUD *HUD;
    NSMutableArray *edataArray;
    NSUserDefaults *user;
    NSMutableArray *gaofenciArray;

    
    
    
//    录音
    BOOL recording;
    AVAudioRecorder *recorder;
    NSURL *tmpFile;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requstData];
    user = [NSUserDefaults standardUserDefaults];
    
    window = [[UIApplication sharedApplication]keyWindow];
    edataArray = [[NSMutableArray alloc]init];
    gaofenciArray = [[NSMutableArray alloc]init];
    _size = [UIScreen mainScreen].bounds.size;
   
    
     [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    [self initTableView];
    [self initbottomView];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadTableViewAction:) name:@"reloadTableView" object:nil];
    
    
    
    
   
}


#pragma mark 数据请求
- (void)requstData{
    
    HUD = [MBProgressHUD showMessage:@"加载中...." toView:window];
   
    NSString *httpUrl = [NSString stringWithFormat:@"%@appid=1&c=content&a=listcontent&mobile=%@&version=%@&devtype=iOS&leval=%@&pageindex=0&pagenum=10",REQUSTHTTPURL,[user objectForKey:@"user_name"],appCurVersion,_myId];
    
    [ILHttpTool requestWithUrlString:httpUrl finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSMutableDictionary *starDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([[NSString stringWithFormat:@"%@",[starDic objectForKey:@"ecode"]]isEqualToString:@"0"]) {
            edataArray = [[starDic objectForKey:@"edata"]objectForKey:@"data"];
            
            gaofenciArray = [[starDic objectForKey:@"edata"]objectForKey:@"gaofenci"];
            
            [_myTableView reloadData];
        }
        
        [HUD removeFromSuperview];
        
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [HUD removeFromSuperview];
    }];
    
}




#pragma mark tableView
- (void)initTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _size.height) style:UITableViewStylePlain];
    }
    //    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc]init];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_myTableView];


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self addTitleViewWithTitle:_titleName];
    [MobClick beginLogPageView:@"PartOnePlayViewController"];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];

}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PartOnePlayViewController"];
}

#pragma mark 底部的背景
- (void)initbottomView{
    _bJbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _size.height-46, _size.width, 46)];
    
    _bJbottomView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:.95];
    
    [self.view addSubview:_bJbottomView];

    
    _answerBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    _answerBut.frame = CGRectMake(42, 7, 35, 32);
    _answerBut.frame = CGRectMake((_bJbottomView.width/4)-16, 7, 35, 32);
    [_answerBut setBackgroundImage:[UIImage imageNamed:@"icon_answer_n"] forState:UIControlStateNormal];
    [_answerBut setBackgroundImage:[UIImage imageNamed:@"icon_answer_h"] forState:UIControlStateHighlighted];
    [_answerBut addTarget:self action:@selector(answerButAction) forControlEvents:UIControlEventTouchUpInside];
    [_bJbottomView addSubview:_answerBut];

    
    
    _wordBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    _wordBut.frame = CGRectMake(_size.width/2-17, 7, 35, 32);
    _wordBut.frame = CGRectMake(3*(_bJbottomView.width/4)-16, 7, 35, 32);
    [_wordBut setBackgroundImage:[UIImage imageNamed:@"icon_word_n"] forState:UIControlStateNormal];
    [_wordBut setBackgroundImage:[UIImage imageNamed:@"icon_word_h"] forState:UIControlStateHighlighted];
    
    [_wordBut addTarget:self action:@selector(gaofenciAction) forControlEvents:UIControlEventTouchUpInside];
    [_bJbottomView addSubview:_wordBut];
    
    
    _videoBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoBut.frame = CGRectMake(_size.width-80, 7, 35, 32);
    
    [_videoBut setBackgroundImage:[UIImage imageNamed:@"icon_video_n"] forState:UIControlStateNormal];
    [_videoBut setBackgroundImage:[UIImage imageNamed:@"icon_video_h"] forState:UIControlStateHighlighted];
    
//    [_bJbottomView addSubview:_videoBut];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  edataArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"PartOnePlayCell";
    
    PartOnePlayCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        
    }
    
    /*
     ** cell 中block中的实现
     */
    if (!cell.recordBlock) {
    
        cell.recordBlock = ^(NSString *str,NSString *isShow){
            
            [self recoderOrplayRecoder:str withId:isShow];
        };
        
    }
    
    /*
     **** 是否显示答案
     */
    
    if (isShowAnswer) {
        cell.answerBjView.hidden = NO;
    }else{
        cell.answerBjView.hidden = YES;
    }
    cell.dataDic = edataArray[indexPath.row];
    
    /*
     **** 播放第一个按钮
     */
    
    if ([[user objectForKey:@"playButOneId"]isEqualToString:[edataArray[indexPath.row]objectForKey:@"id"]]) {
        
        
        cell.playButOne.selected = YES;
        
    }
    
    /*
     **** 播放第二个按钮
     */
    if ([[user objectForKey:@"playButTwoId"]isEqualToString:[edataArray[indexPath.row]objectForKey:@"id"]]) {
        
        cell.playButTwo.selected = YES;
    }
/*
 **** 第一个录音按钮
 */
    if ([[user objectForKey:@"recordButOneId"]isEqualToString:[edataArray[indexPath.row]objectForKey:@"id"]]) {
        
        cell.recordButOne.selected = YES;
    }
    
    /*
    **** 第二个录音按钮
    */
    if ([[user objectForKey:@"recordButTwoId"]isEqualToString:[edataArray[indexPath.row]objectForKey:@"id"]]) {
        
        cell.recordButTwo.selected = YES;
    }
    
    
/*
 **** 听录音按钮
 */
    
//    if ([[user objectForKey:@"hearOneButId"]isEqualToString:[edataArray[indexPath.row]objectForKey:@"id"]]) {
//        
////        cell.haerOneBut.selected = YES;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isShowAnswer) {
        
    return   [self calculateTheWarriorContent: [edataArray[indexPath.row] objectForKey:@"p1_english"]].height+
       [self calculateTheWarriorContent:  [edataArray[indexPath.row] objectForKey:@"p1_chines"]].height+
      [self calculateTheWarriorContent:   [edataArray[indexPath.row] objectForKey:@"question"]].height+150;
        
    }
    

   return  120;

}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//}

#pragma mark 答案按钮的事件
- (void)answerButAction{
   
    isShowAnswer = !isShowAnswer;
 [_myTableView reloadData];
    

}

#pragma mark 高分词的事件
- (void)gaofenciAction{
    HightWordViewController *HightWordVC = [[HightWordViewController alloc]init];

    HightWordVC.dataArr = gaofenciArray;
    HightWordVC.myTitle = @"Part 1 高分词汇";
    [self presentViewController:HightWordVC animated:YES completion:^{
        
    }];
   


}

#pragma mark 返回上一级
- (void)leftBackAction{
    
    if ([_upClass isEqualToString:@"1"]) {
        
        self.playBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [_player pause];
    _player = nil;
    
}


#pragma mark 通知的事件的实现
- (void)reloadTableViewAction:(NSNotification*)center{
    
    
    
    NSLog(@"%@",center.userInfo);

       [_myTableView reloadData];

    
    
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

#pragma mark 音频播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;{
    
    
    [user setObject:nil forKey:@"playButOneId"];
    [user setObject:nil forKey:@"playButTwoId"];
    
    [user setObject:nil forKey:@"hearOneButBool"];
    [user setObject:nil forKey:@"hearTwoButBool"];
    [user synchronize];
    [_myTableView reloadData];
    
    
}


#pragma mark 录音或播放录音
- (void)recoderOrplayRecoder:(NSString *)str withId:(NSString *)isShow{

    if ([str isEqualToString:@"1"]) {
        [self recordAction:@"1" withId:isShow];
    }else if ([str isEqualToString:@"2"]){
        [self playRecoderAction:@"2" withIsShow:isShow];
    
    }
    

}


#pragma mark 录音功能的实现
/*
 *** 录音功能的实现
 */

- (void)recordAction:(NSString *)str withId:(NSString *)isShow{


    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    if (isShow) {
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
        recording = NO;
        [audioSession setActive:NO error:nil];
        [recorder stop];

    }
    
}

#pragma mark 播放录音功能的实现
/*
 *** 播放录音功能的实现
 */

- (void)playRecoderAction:(NSString *)str withIsShow:(NSString *)isShow{

    if (!isShow) {
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



- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [_player pause];
    _player = nil;
      [recorder stop];
    recorder = nil;
    
    [user setObject:nil forKey:@"playButOneId"];
    [user setObject:nil forKey:@"playButTwoId"];
    [user setObject:nil forKey:@"recordButOneId"];
    [user setObject:nil forKey:@"recordButTwoId"];
    [user setObject:nil forKey:@"hearOneButBool"];
    [user setObject:nil forKey:@"hearTwoButBool"];
    [user synchronize];

}



- (CGSize )calculateTheWarriorContent:(NSString *)text{
    

    CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(KSCREENWIDTH-20, CGFLOAT_MAX)];
    
    return sizeToFit;
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
