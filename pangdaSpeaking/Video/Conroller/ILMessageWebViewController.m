//
//  ILMessageWebViewController.m
//  IELTSListening
//
//  Created by benniaoyasi on 15/8/18.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import "ILMessageWebViewController.h"

@interface ILMessageWebViewController (){

    UIView  *navView;
    UILabel *titleLabel;

}

@end

@implementation ILMessageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initHeartView];
//    web
    [self initWeb];
}





- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"ILMessageWebViewController"];
    
//    
//    if ([_upType isEqualToString:@"2"]) {
//
//    if (_dataDic&&[_dataDic objectForKey:@"title"]) {
//        titleLabel.text= [_dataDic objectForKey:@"title"];
//        [self shareButton];
//        }
//    }else if([_upType isEqualToString:@"1"]){
//        
//        if (_model&&_model.title){
//    
//    titleLabel.text= _model.title;
//        //    当有分享时，才添加分享按钮
//    if ([_model.m_share isEqualToString:@"1"]){
//        [self shareButton];
//        }
//    }
//}
    
    }
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"ILMessageWebViewController"];
}

#pragma mark 头部的view 标题和返回键
- (void)initHeartView{
    
    // 标题
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navView.backgroundColor=[UIColor colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:navView];
    
   titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 40)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor blackColor];
    [navView addSubview:titleLabel];
    
    //    返回按钮
    UIButton *back=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70,30,50, 20)];
//    [back setBackgroundImage:[UIImage imageNamed:@"fanhuijian"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setTitle:@"取消" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:16];
    [back addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, self.view.width, .7)];
    line.backgroundColor = [UIColor colorWithHexString:@"#AAAAAA"];
//    [navView addSubview:line];
    
   
}

#pragma mark web
- (void)initWeb{
    
    _myWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];

    [self.view addSubview:_myWeb];


     NSURL *URL = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_myWeb loadRequest:request];
    
}

//#pragma mark 分享按钮
//
//- (void)shareButton{
//
//    
//    UIButton *shareBut=[[UIButton alloc]initWithFrame:CGRectMake(navView.width-60,25,50, 30)];
////    [shareBut setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    [shareBut setTitle:@"分享" forState:UIControlStateNormal];
//    [shareBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [shareBut addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:shareBut];
//    
//    
//
//
//}
//#pragma mark  分享
//- (void)shareAction{
//
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *shareURL;
//        NSString *shareTitle;
//        NSString *shareText;
//        NSString *shareImg;
//// 分享的连接
//        if ([_upType isEqualToString:@"1"]){
//            
//        shareURL = [NSString stringWithFormat:@"%@&appid=2",_model.share_url];
//            shareTitle = _model.share_title;
//            shareText = _model.share_content;
//            shareImg = _model.shareimg_url;
//            
//        } else if([_upType isEqualToString:@"2"]){
//            shareURL = [NSString stringWithFormat:@"%@&appid=2",[_dataDic objectForKey:@"share_url"]];
//            shareTitle = [_dataDic objectForKey:@"share_title"];
//            shareText = [_dataDic objectForKey:@"share_content"];
//            shareImg = [_dataDic objectForKey:@"share_img"];
//        }
////         图片
//
//        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareImg];
//        
//        //        新浪
//        
//        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",shareText,shareURL];
//
//        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = shareURL;
//        
//        //        qq空间
//        [UMSocialData defaultData].extConfig.qzoneData.title=shareTitle;
//        [UMSocialData defaultData].extConfig.qzoneData.url=shareURL;
//
//        [UMSocialData defaultData].extConfig.qzoneData.shareText = shareText;
//
//        
//                //        微信好友
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//        [UMSocialData defaultData].extConfig.wechatSessionData.url=shareURL;
//        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareText;
//
//        
//                //        朋友圈
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title=shareTitle;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url=shareURL;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText =  shareText;
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:UMENG_APPKEY
//                                          shareText:nil
//                                         shareImage:nil
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,nil]
//                                           delegate:self];
//        });
//    
//
//}





#pragma mark 返回上级
- (void)backVC{
    
//    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
