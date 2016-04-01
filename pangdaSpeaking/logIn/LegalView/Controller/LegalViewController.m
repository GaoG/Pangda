//
//  LegalViewController.m
//  IELTSNine
//
//  Created by 王英东 on 15/2/10.
//  Copyright (c) 2015年 王英东. All rights reserved.
//
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO
#define FONT_NAME @"CenturyGothic"
#define TITLE_FONT 17

#import "LegalViewController.h"
//#import "MobClick.h"
@interface LegalViewController ()
{
    int _statusBarHeight;
}
@end

@implementation LegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    if (IOS7_OR_LATER ) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        _statusBarHeight = 20;
    }
    else{
        _statusBarHeight = 0;
    }
    //self.callTest = @"0";
    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44+_statusBarHeight)];
    //barView.image = [UIImage imageNamed:@"titleImage.png"];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((KSCREENWIDTH-120)*0.5, _statusBarHeight, 120, 44)];
    
    titleNameLabel.text = @"条款";
    titleNameLabel.textAlignment = NSTextAlignmentCenter;
    titleNameLabel.textColor = [UIColor whiteColor];
    titleNameLabel.textColor = [UIColor blackColor];
    
    
    titleNameLabel.font = [UIFont fontWithName:FONT_NAME size:TITLE_FONT];
    [barView addSubview:titleNameLabel];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,_statusBarHeight,44,44)];
    [leftButton setImage:[UIImage imageNamed:@"nav_arrow_n"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"nav_arrow_h"] forState:UIControlStateHighlighted];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [leftButton addTarget:self action:@selector(backButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIImageView *imageLineViewTop = [[UIImageView alloc]init];
    imageLineViewTop.frame = CGRectMake(0, barView.frame.size.height - 1, self.view.frame.size.width,1 );
    imageLineViewTop.backgroundColor = [UIColor lightGrayColor];
    [barView addSubview:imageLineViewTop];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
    textView.frame = CGRectMake(0, barView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    textView.text = @"       胖达雅思是国内唯一提供浸泡式雅思课程的专业机构。胖达雅思通过全日制讲练循环的高密度集训帮助雅思考生在短期内获取理想分数。相比于其他机构按天或按节来划分课程，胖达雅思的雅思课程是按分钟和小时来规划的。这能确保考生每时每刻都有人监督和指导，不会出现一分钟的放羊式学习，所以胖达雅思的提分速度相比于同业机构至少快3倍。胖达雅思连续3年获得中国雅思考生评选的“考生最信赖的雅思学校”称号。胖达雅思由中国雅思培训界著名领军人物及雅思教学界权威专家联合创办。自成立以来，以构建中国雅思教育完美体系为目标，提倡“化繁为简，短期高效提分”，以“为学员1分的进步，付出10分的努力”为教学精神，提出并坚持专业、高效、创新、优质的教育理念，为考生提供定制化的一站式雅思整体解决方案。";
    textView.font = [UIFont systemFontOfSize:16];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [self.view addSubview:textView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LegalViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LegalViewController"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backButtonTap
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
