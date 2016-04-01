//
//  PlayVideoViewController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"
@interface PlayVideoViewController : ViewController<UITableViewDelegate,UITableViewDataSource,VideoViewDelegate>


@property (nonatomic,strong)VideoView *videoView;

@property (nonatomic,copy)NSString *myId;

@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *part;

@end
