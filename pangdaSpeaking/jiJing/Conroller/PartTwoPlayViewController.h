//
//  PartTwoPlayViewController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ViewController.h"
/*
 *** 返回视频播放界面的视频播放block
 */
typedef void (^playVideo) ();

@interface PartTwoPlayViewController : ViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSString *titleName;

@property (nonatomic,copy)NSString *myId;

@property (nonatomic,copy)playVideo playBlock;

@property (nonatomic,copy)NSString *upClass;


@end
