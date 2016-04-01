//
//  PartTwoPlayfirstCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/13.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartTwoPlayfirstCell.h"
#import "ILFileDownloader.h"
#import "ILHttpTool.h"
@implementation PartTwoPlayfirstCell{
    NSUserDefaults *user;
    NSString * cachePath;
    NSString *playUrl;
    NSString *mp3dizhi;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSMutableDictionary *)dataDic{

    user = [NSUserDefaults standardUserDefaults];
    _dataDic = dataDic;
    _contentLabel.text = [dataDic objectForKey:@"title"];
    
    
    _hearBut.hidden = YES;
    
    
    if ([[_dataDic objectForKey:@"id"]isEqualToString:[user objectForKey:@"P2_hearId"]]) {
        _hearBut.hidden = NO;
        
        if ([[user objectForKey:@"P2_hearButBool"]isEqualToString:@"1"]) {
            _hearBut.selected = YES;
        }else{
        _hearBut.selected = NO;
            
        }
        
    }
    

}


/*
 **** 播放音频
 */

- (IBAction)playButAction:(id)sender {
    user = [NSUserDefaults standardUserDefaults];
    if (!_playBut.selected){
        _hearBut.selected = NO;
        _recordBut.selected = NO;
        _playBut.selected = YES;
        
    [user setObject:nil forKey:@"P2_hearButBool"];
    [user setObject:nil forKey:@"P2_hearId"];
     [user setObject:nil forKey:@"P2_recordId"];
    [user setObject:[_dataDic objectForKey:@"id"] forKey:@"playButId"];
        
        [user synchronize];
//        z暂停录音
        _playOrRecodeBlock (@"1",nil);
//        播放
    [self theAudioAcquisitionAndPlayback:[_dataDic objectForKey:@"problem_audio"]];
        
    }else{
    
    _playBut.selected = NO;
        
        [user setObject:nil forKey:@"playButId"];
        
        [user synchronize];
//            暂停
        [self postNotificationAction:nil];
    }
  
}

/*
 *** 录音按钮的事件
 */
- (IBAction)recordButAction:(id)sender {
    
    user = [NSUserDefaults standardUserDefaults];
    
    
    if (!_recordBut.selected) {
        _recordBut.selected = YES;
        _playBut.selected = NO;
        _hearBut.selected = NO;
        _hearBut.hidden = YES;
        
        
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"P2_recordId"];
        [user setObject:nil forKey:@"P2_hearId"];
         [user setObject:nil forKey:@"playButId"];
    
        [user synchronize];
        
      
        
//         暂停播放录音
        _playOrRecodeBlock (@"2",nil);
//        开始录音
        _playOrRecodeBlock (@"1",@"1");
        //            暂停播放
          [self postNotificationAction:nil];
        
    }else{
        
        _recordBut.selected = NO;
        _hearBut.hidden = NO;
        
        [user setObject:nil forKey:@"P2_recordId"];
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"P2_hearId"];
        
        [user synchronize];
//        暂停录音
          _playOrRecodeBlock (@"1",nil);
        
    }
}


/*
 *** 播放录音按钮的事件
 */
- (IBAction)hearButAction:(id)sender {
    
    user = [NSUserDefaults standardUserDefaults];
    
    if (!_hearBut.selected) {
        _hearBut.selected = YES;
        
        
        [user setObject:@"1" forKey:@"P2_hearButBool"];
        [user synchronize];
//        播放录音
        _playOrRecodeBlock (@"2",@"1");
        
    }else{
        _hearBut.selected = NO;
         [user setObject:nil forKey:@"P2_hearButBool"];
        [user synchronize];
//        暂停播放录音
        _playOrRecodeBlock (@"2",nil);
    }
    
}



#pragma mark 音频的获取和播放
- (void)theAudioAcquisitionAndPlayback:(NSString*)urlStr{
    
    
    ILFileDownloader  *ILFileDown=[[ILFileDownloader alloc]init];
    
    //  当音频下载完成后的回调
    
    if (!ILFileDown.completionHandler) {
        
        __block typeof(self) mySelf = self;
        ILFileDown.completionHandler = ^(NSString *str){
            NSLog(@"%@",str);
            mp3dizhi = str ;
            NSDictionary *dic= @{
                                 @"location":mp3dizhi
                                 
                                 };
            //            发送通知
            [mySelf postNotificationAction:dic];
        };
        
    };
    
    
    //        判断本地是否已存在此音频
    if (![ILFileDown isOrNoTherLocation:urlStr]) {
        ILFileDown.url = urlStr;
        [ILFileDown start];
        
    }else{
        
        cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        mp3dizhi = [NSString stringWithFormat:@"%@/%@%@.mp3",cachePath,mp3Location,[ILHttpTool md5:urlStr]];
        
        //            mp3dizhi = [NSString stringWithFormat: @"%@%@%@"];
        NSDictionary *dic= @{
                             @"location":mp3dizhi
                             };
        
        //            发送通知
        [self postNotificationAction:dic];
    }
    
}

#pragma mark 发送通知
- (void)postNotificationAction:(NSDictionary*)dic{
    
    
    NSNotification * notice = [NSNotification notificationWithName:@"partTwoReloadTableView" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [[NSNotificationCenter defaultCenter] removeObserver:notice name:nil object:self];
    
}




@end
