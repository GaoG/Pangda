//
//  PartOnePlayCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartOnePlayCell.h"
#import "ILFileDownloader.h"
#import "ILHttpTool.h"

@implementation PartOnePlayCell{

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
    
    user = [NSUserDefaults standardUserDefaults];
    

    
    
    

//   CGSize englishSize =  [self calculateTheWarriorContent:[_dataDic objectForKey:@"p1_english" ]];
//    
//    _englishAnswer.height = englishSize.height;
//    
//    _playButTwo.y = englishSize.height+20;
//    _recordButTwo.y = englishSize.height+20;
//    _hearTwoBut.y = englishSize.height+20;
//    
//    CGSize chinesSize = [self calculateTheWarriorContent:[_dataDic objectForKey:@"p1_chines" ]];
//    _ChineseAnswer.y = _playButTwo.height+20+_playButTwo.y;
//    _ChineseAnswer.height = chinesSize.height;
//    
//    BOOL aaa =   _answerBjView.hidden;
//    NSLog(@"这是一个bool值     %d",aaa);
    
    
    
    // Configure the view for the selected state
}
/*
 ** 设置datadic set方法
 */

- (void)setDataDic:(NSMutableDictionary *)dataDic{

    user = [NSUserDefaults standardUserDefaults];
    _dataDic = dataDic;
    
    _flgImageView.hidden = YES;
    _questionLabel.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"question" ]];
    
    
    _englishAnswer.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"p1_english" ]];
    
    _ChineseAnswer.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"p1_chines" ]];
    
    
    
    _haerOneBut.hidden = YES;
    _hearTwoBut.hidden = YES;


/*
 **** 修改第一个听录音的按钮的状态
 */
    if ([[user objectForKey:@"hearOneButId"] isEqualToString:[_dataDic objectForKey:@"id"] ]) {
        _haerOneBut.hidden = NO;
         _haerOneBut.selected = NO;
        
        if ([[user objectForKey:@"hearOneButBool"] isEqualToString:@"1"]) {
            _haerOneBut.selected = YES;
        }else{
            _haerOneBut.selected = NO;
        }
        
    }
    
    /*
     **** 修改第二个听录音的按钮的状态
     */
    
   
    if ([[user objectForKey:@"hearTwoButId"] isEqualToString:[_dataDic objectForKey:@"id"] ]){
    
    
        _hearTwoBut.hidden = NO;
        _hearTwoBut.selected = NO;
    
        if ([[user objectForKey:@"hearTwoButBool"] isEqualToString:@"1"]) {
            _hearTwoBut.selected = YES;
        }else{
            _hearTwoBut.selected = NO;
        }
        
        
    }
    
    [user synchronize];
}


/*
 **** 第一个播放按钮的事件
 */
- (IBAction)playButOneAction:(id)sender {
    


     user = [NSUserDefaults standardUserDefaults];
    
    
    if (!_playButOne.selected) {
        _playButOne.selected = YES;
        _haerOneBut.selected = NO;
        _recordButOne.selected = NO;
        _hearTwoBut.selected = NO;
        _recordButTwo.selected = NO;
        
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"playButOneId"];
        [user setObject:nil forKey:@"playButTwoId"];
        
        [user setObject:nil forKey:@"recordButOneId"];
        
         [user setObject:nil forKey:@"hearOneButId"];
        
         [user setObject:nil forKey:@"recordButTwoId"];
        
        [user setObject:nil forKey:@"hearTwoButId"];
        
        [user synchronize];
//        暂停录音
        _recordBlock(@"1",nil);
        
//         播放音频
        [self theAudioAcquisitionAndPlayback:[_dataDic objectForKey:@"audio"]];
        
        
    
        
    }else{
        _playButOne.selected = NO;
        
        [user setObject:nil forKey:@"playButOneId"];

        [user synchronize];
//     NSLog(@"%@",[user objectForKey:@"playButId"]);
        [self postNotificationAction:nil];
    }
    
}

/*
 *** 第一个录音按钮的事件
 */

- (IBAction)recordButOneAction:(id)sender {
    
    user = [NSUserDefaults standardUserDefaults];
    
    if ( !_recordButOne.selected) {
        _recordButOne.selected = YES;
        _playButOne.selected = NO;
        _haerOneBut.selected = NO;
        _playButTwo.selected = NO;
        
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"recordButOneId"];
        [user setObject:nil forKey:@"playButOneId"];
        [user setObject:nil forKey:@"playButTwoId"];
        
        [user setObject:nil forKey:@"hearOneButId"];
        [user setObject:nil forKey:@"hearTwoButId"];
        [user setObject:nil forKey:@"recordButTwoId"];
        
        [user synchronize];
        
//         block 实现录音功能
        _recordBlock(@"1",[_dataDic objectForKey:@"id"]);
        
        [self postNotificationAction:nil];
        
        
    }else {
        
        [user setObject:nil forKey:@"recordButOneId"];
        _recordButOne.selected = NO;
        _haerOneBut.hidden = NO;
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"hearOneButId"];
        [user synchronize];
    }
    
    
}

/*
 **** 第一个听录音案按钮的事件
 */

- (IBAction)hearOneButAction:(id)sender {
    
    user = [NSUserDefaults standardUserDefaults];

    if (_haerOneBut.selected) {
        _haerOneBut.selected = NO;
        [user setObject:nil forKey:@"hearOneButBool"];
        
        [user synchronize];
       _recordBlock(@"2",nil);
        
    
    }else{
        _haerOneBut.selected = YES;
        
        _playButOne.selected = NO;
        _recordButOne.selected = NO;
        _playButTwo.selected = NO;
        _recordButTwo.selected = NO;
        _hearTwoBut.selected = NO;
        
        [user synchronize];
        
    [user setObject:@"1" forKey:@"hearOneButBool"];
    _recordBlock(@"2",[_dataDic objectForKey:@"id"]);
    
    }
    
}


/*
 ** 第二个播放按钮的事件
 */
- (IBAction)playButTwoAction:(id)sender {
    
    
    user = [NSUserDefaults standardUserDefaults];
    
    if (!_playButTwo.selected) {
        
        _playButTwo.selected = YES;
        
        _playButOne.selected = NO;
        _haerOneBut.selected = NO;
        _recordButOne.selected = NO;
        _hearTwoBut.selected = NO;
        _recordButTwo.selected = NO;
        
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"playButTwoId"];
        [user setObject:nil forKey:@"playButOneId"];
    

        
        [user setObject:nil forKey:@"recordButOneId"];
        
        [user setObject:nil forKey:@"hearOneButId"];
        
        [user setObject:nil forKey:@"recordButTwoId"];
        
        [user setObject:nil forKey:@"hearTwoButId"];
        
        [user synchronize];
        //        暂停录音
        _recordBlock(@"1",nil);
        
        [self theAudioAcquisitionAndPlayback:[_dataDic objectForKey:@"answers_audio"]];
//        暂停录音
//        _recordBlock(@"1",nil);
        
    }else{
    
        _playButTwo.selected = NO;
        [user setObject:nil forKey:@"playButTwoId"];

        [user synchronize];
        
        [self postNotificationAction:nil];
    }
    
}


/*
 ** 第二个录音按钮的事件
 */

- (IBAction)recordButAction:(id)sender {
    user = [NSUserDefaults standardUserDefaults];
    
    if ( !_recordButTwo.selected) {
        _recordButTwo.selected = YES;
        _hearTwoBut.selected = NO;
        _hearTwoBut.hidden = YES;
        _playButOne.selected = NO;
        
        
        [user setObject:nil forKey:@"recordButOneId"];
        [user setObject:nil forKey:@"playButOneId"];
        [user setObject:nil forKey:@"playButTwoId"];
        
        [user setObject:nil forKey:@"hearOneButId"];
        [user setObject:nil forKey:@"hearTwoButId"];
    
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"recordButTwoId"];
          [user setObject:nil forKey:@"hearTwoButId"];
        
        [user synchronize];
        
        
//        暂停录音
//        _recordBlock(@"1",nil);
//        开始录音
        _recordBlock(@"1",@"1");
         [self postNotificationAction:nil];
        
    }else {
        _recordButTwo.selected = NO;
        
        _hearTwoBut.hidden = NO;
        [user setObject:nil forKey:@"recordButTwoId"];
        [user setObject:[_dataDic objectForKey:@"id"] forKey:@"hearTwoButId"];
        [user synchronize];
        
    }
    
}


/*
 *** 第二个听录音案按钮的事件
 */

- (IBAction)hearTwoButAction:(id)sender {
    
    user = [NSUserDefaults standardUserDefaults];
    
    if (_hearTwoBut.selected) {
        
        _hearTwoBut.selected = NO;
        [user setObject:nil forKey:@"hearTwoButBool"];
        
        [user synchronize];

        _recordBlock(@"2",nil);
        
    }else{
        
        _haerOneBut.selected = NO;
        _playButOne.selected = NO;
        _recordButOne.selected = NO;
        _playButTwo.selected = NO;
        _recordButTwo.selected = NO;
        _hearTwoBut.selected = NO;
        _hearTwoBut.selected = YES;
        [user setObject:@"1" forKey:@"hearTwoButBool"];
        
        _recordBlock(@"2",[_dataDic objectForKey:@"id"]);
        
        
    
    }
}



#pragma mark 发送通知
- (void)postNotificationAction:(NSDictionary*)dic{


    NSNotification * notice = [NSNotification notificationWithName:@"reloadTableView" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [[NSNotificationCenter defaultCenter] removeObserver:notice name:nil object:self];
    
}


#pragma mark 音频的获取和播放
- (void)theAudioAcquisitionAndPlayback:(NSString*)urlStr{


    ILFileDownloader  *ILFileDown=[[ILFileDownloader alloc]init];
    
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
    
    //  当音频下载完成后的回调
    
    
    NSLog(@"%@",ILFileDown.completionHandler);
    

//    




}


- (CGSize )calculateTheWarriorContent:(NSString *)text{

    
       CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(KSCREENWIDTH-20, CGFLOAT_MAX)];
    
    return sizeToFit;
}



@end
