//
//  VideoView.h
//  shipT
//
//  Created by jinbangtiming on 14/12/1.
//  Copyright (c) 2014年 huangxiaoya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoViewDelegate <NSObject>

-(void)isFullGreen;
-(void)isNFullGreen;
//-(void)monthPay:(BOOL)isLogin;//购买前判断用户有没有登陆

@end
@interface VideoView : UIView


@property (nonatomic,weak)AVPlayer *player;//视频播放器
@property(nonatomic,strong)NSString*video_url;//视频id
@property(nonatomic,strong)NSString*video_name;//视频所属的类
@property(nonatomic,strong)NSString*video_photo;//视频所属的类
@property(nonatomic,strong)NSString*videoName;//视频所属的类
@property(nonatomic,strong)UIView*bgV;
@property(nonatomic,strong)NSString*video_id;//视频id
@property(nonatomic,retain)UILabel*timeLabel;
@property(nonatomic,retain) UILabel* timeALabel;
@property(nonatomic,assign)BOOL isEnd;//视频是否播放完
@property(nonatomic,assign)id<VideoViewDelegate>delegate;

@property (nonatomic,copy)NSString *myTage;

- (void)setVideoPlayer:(AVPlayer *)myPlayer;

- (id)initWithFrame:(CGRect)frame andVIdeoUrl:(NSString*)path andPName:(NSString*)pName andfree:(BOOL)free;
- (id)initWithFrame:(CGRect)frame andVIdeoUrl:(NSString*)path andPName:(NSString*)pName andfree:(BOOL)free andIsAlbum:(BOOL)isAlbum andImageURL:(NSString *)imageURL;
-(void)playVideo:(NSString*)path;//播放视频
-(void)pausePlayVideo;//暂停视频
-(void)removePlayingVideo;

-(void)changeFrame:(BOOL)isf andFrame:(CGRect)frame;
@end
