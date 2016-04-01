//
//  HightWordViewController.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/25.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ViewController.h"

@interface HightWordViewController : /*ViewController*/UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,copy)NSString *myTitle;
@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end
