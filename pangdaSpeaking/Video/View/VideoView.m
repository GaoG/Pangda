//
//  VideoView.m
//  shipT
//
//  Created by jinbangtiming on 14/12/1.
//  Copyright (c) 2014年 huangxiaoya. All rights reserved.
//

#import "VideoView.h"
#import "MBProgressHUD+CZ.h"

static int k;
@interface VideoView (){
    UISlider *_progressSlider;//用于指示和调节进度
//    AVPlayer *_player;//视频播放器
    CGSize _size;
    UIButton *playBtn;
    UIButton *pauseBtn;
    BOOL isPlay;// 播放
    BOOL isFull;//全屏

//    UIButton*downBtn;
    NSString *folder;
    NSString*videName;
    UIAlertView*baseAlert;

    BOOL isRemove;
    UIAlertView*alert;
    NSTimer*myTimer;
    UIButton *bigPlayBtn;
    UIImageView *newAddImageView;
    NSString * newAddImageViewURL;
    
    MBProgressHUD *HUD;

    
    
}
//@property(nonatomic,strong)DownVideoMode*Dmodel;
@end
@implementation VideoView
@synthesize bgV;
@synthesize timeLabel,timeALabel;

-(void)tapInView:(UITapGestureRecognizer*)ges
{
    if (_player==nil) {
        return;
    }
    bgV.hidden=!bgV.hidden;
    if (!bgV.hidden) {
        myTimer=[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(closeBar) userInfo:nil repeats:NO];
    }
}
-(void)configUI
{
    
    self.backgroundColor= [UIColor whiteColor];
    
    _size=[UIScreen mainScreen].bounds.size;
    //uiview
    bgV=[[UIView alloc]initWithFrame:CGRectMake(0,_size.width*9/16-40,_size.width, 40)];
    bgV.backgroundColor=[UIColor blackColor];
    bgV.backgroundColor=[bgV.backgroundColor colorWithAlphaComponent:0.3];
    [self addSubview:bgV];
    
    
    if (!playBtn) {
        
    playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_s"] forState:UIControlStateNormal];
    
    [playBtn setFrame:CGRectMake(10,8,15,22)];
    [playBtn addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
    playBtn.hidden = YES;
        if (!newAddImageViewURL) {
            playBtn.hidden = NO;
        }
    [bgV addSubview:playBtn];
        
        
        
    }
/*
 ** 新添加图片
 */
    
    if(!newAddImageView){
    newAddImageView = [[UIImageView alloc]initWithFrame:self.bounds];

    [newAddImageView setImageWithURL:[NSURL URLWithString:newAddImageViewURL]];
        
//        [newAddImageView setImageWithURL:[NSURL URLWithString:newAddImageViewURL] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    
    [self addSubview:newAddImageView];

    
    }
    
    if (!bigPlayBtn) {
        bigPlayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [bigPlayBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_"] forState:UIControlStateNormal];
        
        [bigPlayBtn setFrame:CGRectMake(KSCREENWIDTH/2-22,(self.bounds.size.height)/2-22,45,45)];
        [bigPlayBtn addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigPlayBtn];
        if(!newAddImageViewURL){
            bigPlayBtn.hidden = YES;
        }
        
    }
    
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(100,12,_size.width-210,15)];
    //设置最值
    _progressSlider.maximumValue = 1.0;
    _progressSlider.minimumValue = 0.0;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"dot_"] forState:UIControlStateNormal];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"dot_"] forState:UIControlStateHighlighted];
//    _progressSlider.minimumTrackTintColor=FontRGBA;
    
    [_progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    [bgV addSubview:_progressSlider];
    
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,15,55, 10)];
    timeLabel.text=@"00:00";
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont boldSystemFontOfSize:13];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [bgV addSubview:timeLabel];
    
    timeALabel=[[UILabel alloc]initWithFrame:CGRectMake(_size.width-100,15,60, 10)];
    timeALabel.text=@"00:00";
    
    timeALabel.textAlignment=NSTextAlignmentLeft;
    timeALabel.font=[UIFont boldSystemFontOfSize:13];
    [timeALabel setTextColor:[UIColor whiteColor]];
    [bgV addSubview:timeALabel];
//    全屏
    pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseBtn setBackgroundImage:[UIImage imageNamed:@"icon_amplification"] forState:UIControlStateNormal];
    [pauseBtn setFrame:CGRectMake(_size.width-30,5,20,20)];
    [pauseBtn addTarget:self action:@selector(fullGreen) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:pauseBtn];
    
    
//    取消显示视屏的控制栏
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInView:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self addGestureRecognizer:tap];
    
    
    
    //开启定时器
    myTimer=[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(closeBar) userInfo:nil repeats:NO];
}



-(void)closeBar
{
    if (!bgV.hidden) {
        bgV.hidden=YES;
    }
    [myTimer invalidate];
    myTimer=nil;
}
- (id)initWithFrame:(CGRect)frame andVIdeoUrl:(NSString*)path andPName:(NSString*)pName andfree:(BOOL)free andIsAlbum:(BOOL)isAlbum andImageURL:(NSString *)imageURL
{
    
    self=[super initWithFrame:frame];
    


    if (self) {
        self.backgroundColor=[UIColor blackColor];
//        isPlay=YES;
        
        
        newAddImageViewURL = imageURL;
        isFull=NO;
        isRemove=NO;
        
        k=0;
        self.video_url=path;
        videName=pName;
        

        [self configUI ];

            [self playVideo:self.video_url];
        
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame andVIdeoUrl:(NSString*)path andPName:(NSString*)pName andfree:(BOOL)free
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
//        isPlay=YES;
        isFull=NO;
        isRemove=NO;
        
        k=0;
        self.video_url=path;
        videName=pName;
        
        [self configUI];
            [self playVideo:self.video_url];
        
    }
    return self;
}


-(void)dismissAlertView
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark-BuyViewDelegate

// 点击全屏按钮的事件
-(void)fullGreen
{
    if (!isFull) {

        isFull=YES;
        
         [self changeFrame:YES andFrame:CGRectMake(0, 0, KSCREENHEIGHT,KSCREENWIDTH)];
        
        
        return;
    }else if (isFull)
    {

        isFull=NO;
        [self changeFrame:NO andFrame:CGRectMake(0, 0, KSCREENWIDTH,KSCREENHEIGHT)];
        
    }
}



#pragma mark  当切换横屏是 的事件
-(void)changeFrame:(BOOL)isf andFrame:(CGRect)frame
{
    

    isFull=isf;
    
    if (isf) {
//        downBtn.hidden=YES;
        bigPlayBtn.frame = CGRectMake(_size.height/2-20, _size.width/2-20, 45, 45);
//        [_player play];
        [pauseBtn setBackgroundImage:[UIImage imageNamed:@"narrow_"] forState:UIControlStateNormal];
        [pauseBtn setFrame:CGRectMake(_size.height-30,5,20,20)];
        _progressSlider.frame=CGRectMake(100, 5, _size.height-210, 30);
        timeLabel.frame=CGRectMake(40, 15, 55, 10);
        timeALabel.frame=CGRectMake(_size.height-110, 15, 55, 10);
        self.frame=CGRectMake(0,0,_size.height,_size.width);
        bgV.frame=CGRectMake(0,_size.width-40, _size.height, 40);
        newAddImageView.frame = CGRectMake(0,0, _size.height, _size.width);

        
        if ([self.delegate respondsToSelector:@selector(isFullGreen)]) {
            [self.delegate isFullGreen];
        }
        
    }else
    {
        [bigPlayBtn setFrame:CGRectMake(KSCREENWIDTH/2-22,(KSCREENWIDTH*9/16)/2-22,45,45)];
//        downBtn.hidden=NO;
        timeLabel.frame=CGRectMake(40,15,55, 10);
        timeALabel.frame=CGRectMake(_size.width-100,15,60, 10);
        [pauseBtn setBackgroundImage:[UIImage imageNamed:@"icon_amplification"] forState:UIControlStateNormal];
//
        [pauseBtn setFrame:CGRectMake(_size.width-30,5,20,20)];
        _progressSlider.frame=CGRectMake(100,12,_size.width-210,15);
        
        self.frame = CGRectMake(0,64,KSCREENWIDTH,KSCREENWIDTH*9/16);
        bgV.frame=CGRectMake(0,_size.width*9/16-40,_size.width, 40);
        newAddImageView.frame = CGRectMake(0,0,_size.width, _size.width*9/16);;
        
        isFull=NO;
        

        if ([self.delegate respondsToSelector:@selector(isNFullGreen)]) {
            [self.delegate isNFullGreen];
        }
        
    }
}
//视频播放
-(void)playVideo:(NSString*)path
{

    if (_player!=nil) {
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
    
    _progressSlider.value=0;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_s"] forState:UIControlStateNormal];
    [self loadVideoWithPath:path];
//    isPlay=YES;

}
-(void)removePlayingVideo
{
    if (_player==nil) {
        
    }
    isRemove=YES;
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player=nil;
}
//根据播放路径,播放视频
- (void)loadVideoWithPath:(NSString *)path{
    self.isEnd=NO;
    
//    path =  [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString* encodedString = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSURL*url=[NSURL URLWithString:path];
    
    NSURL*url=[NSURL URLWithString:encodedString];
    
    
    AVAsset *aset = [AVAsset assetWithURL:url];
    [aset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        //得到对视频预加载的状态
        AVKeyValueStatus status = [aset statusOfValueForKey:@"tracks" error:nil];
        if (status == AVKeyValueStatusLoaded) {
            
            //收集资源完成(视频格式、总时长等)
            //AVPlayerItem 一个视频播放的项目
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:aset];
            //视频播放器通过Item能拿到视频播放的进度和总时长
            _player = [[AVPlayer alloc] initWithPlayerItem:item];
            [self setVideoPlayer:_player];
            if (!newAddImageViewURL) {
                [_player play];
                isPlay=YES;
                [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_suspended_s"] forState:UIControlStateNormal];
            }
            
            
            //播放
            if (!isRemove) {
//                [_player play];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_suspended_s"] forState:UIControlStateNormal];
//
                });
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            }else
                [_player replaceCurrentItemWithPlayerItem:nil];
            
            __weak AVPlayer *weakPlayer = _player;
            __weak UISlider *slider = _progressSlider;
            __block VideoView*weakSelf=self;
            
            [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time ) {
                //当前播放时间
                CMTime current = weakPlayer.currentItem.currentTime;
                //获取视频总时间
                CMTime total = weakPlayer.currentItem.duration;
                CGFloat cur;
                if (current.timescale!=0) {
                    
                    cur=current.value/current.timescale-8*3600;
                }
                CGFloat allTime;
                if (total.timescale!=0) {
                    
                    allTime=total.value/total.timescale-8*3600;
                }else
                    allTime=cur;
                
                NSString*cuS=[weakSelf convertTime:cur];
                NSString*alS=[weakSelf convertTime:allTime];
                
                float progress = CMTimeGetSeconds(current)/CMTimeGetSeconds(total);
                //回到主线程 刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakPlayer) {
                        weakSelf.timeLabel.text=[[NSString alloc] initWithFormat:@"%@",cuS];
                        weakSelf.timeALabel.text=[[NSString alloc] initWithFormat:@"%@",alS];
                    }
                    
                    if (progress>=0.0&&progress<=1.0) {
                        slider.value = progress;
                    }
                });
            }];
        }
    }];
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        //        [self updateVideoSlider:0.0];
        //    _progressSlider
        self.isEnd=YES;
        [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_s"] forState:UIControlStateNormal];
        
    }];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm:ss"];
    [formatter setDateFormat:@"mm:ss"];
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
-(void)pausePlayVideo
{
    if (isPlay) {
        if (_player) {
            //暂停视频
            [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_s"] forState:UIControlStateNormal];
            [_player pause];
            isPlay=NO;
        }
    }
}


#pragma mark  暂停
-(void)pauseVideo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"user_name"]) {
        [self login];
        return;
    }
    
    if (isPlay) {
        if (_player) {
            //暂停视频
            
            [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_play_s"] forState:UIControlStateNormal];
            
            [_player pause];
            isPlay=NO;
        }
    }else
    {
        if (_player) {
            
        [newAddImageView removeFromSuperview];
        newAddImageView = nil;
            [_player play];
            playBtn.hidden = NO;
            bigPlayBtn.hidden = YES;
            [playBtn setBackgroundImage:[UIImage imageNamed:@"icon_suspended_s"] forState:UIControlStateNormal];
            isPlay=YES;
            return;
        }
    }
}




#pragma mark  改变滑条位置

- (void)changeProgress:(UISlider *)sl
{
    if (_player) {
        //获取总时间
        CMTime total = _player.currentItem.duration;
        float progress = sl.value;
        //让播放器跳转到指定时间
        [_player seekToTime:CMTimeMultiplyByFloat64(total, progress)];
    }}
+(Class)layerClass{
    return [AVPlayerLayer class];
}
- (void)setVideoPlayer:(AVPlayer *)myPlayer{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    [playerLayer setPlayer:myPlayer];
    
}
#pragma mark-
#pragma mark-alert delegate
- (void) performDismiss: (NSTimer *)timer {
    [baseAlert dismissWithClickedButtonIndex:0 animated:NO];//important
}


#pragma mark 登录
- (void)login{
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 显示主控制器（登录界面）
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    
    UINavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"navgationController"];
    
        UIViewController *VC = (UIViewController *)self.nextResponder.nextResponder;
    if (!newAddImageViewURL) {
        VC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder;
    }
    

    
    [VC presentViewController:nav animated:YES completion:^{
        
    }];
    
    
    
}



@end
