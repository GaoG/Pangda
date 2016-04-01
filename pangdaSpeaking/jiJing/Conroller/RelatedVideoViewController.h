//
//  RelatedVideoViewController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/13.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"
@interface RelatedVideoViewController :/* ViewController*/ UIViewController<VideoViewDelegate>


@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)VideoView *videoView;
@property (nonatomic,strong)UITableView *myTableView;

@end
