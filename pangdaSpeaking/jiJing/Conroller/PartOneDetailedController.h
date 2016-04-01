//
//  PartOneDetailedController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ViewController.h"

@interface PartOneDetailedController : ViewController<UITableViewDelegate,UITableViewDataSource>
//标题的名字
@property (nonatomic ,copy)NSString *titleName;

@property (nonatomic,copy)NSString *upType;

@property (nonatomic,copy)NSString *evalue;

@end
