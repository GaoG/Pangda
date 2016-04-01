//
//  ILMessageWebViewController.h
//  IELTSListening
//
//  Created by benniaoyasi on 15/8/18.
//  Copyright (c) 2015年 笨鸟雅思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILMessageWebViewController : UIViewController

@property (nonatomic,strong)UIWebView *myWeb;

@property (nonatomic,copy)NSString *url;

@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (nonatomic,copy)NSString *upType;

@end
