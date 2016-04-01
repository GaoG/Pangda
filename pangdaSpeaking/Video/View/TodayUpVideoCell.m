//
//  TodayUpVideoCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "TodayUpVideoCell.h"
#import "ExpoundViewController.h"
#import "PlayVideoViewController.h"
@implementation TodayUpVideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)moreAction:(id)sender {
    
    ExpoundViewController *ExpoundVC = [[ExpoundViewController alloc]init];
    
    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    ExpoundVC.titleName = @"今日更新";
    [vc.navigationController pushViewController:ExpoundVC animated:YES];
    
    
}

- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
    _titleName.text = [_dataDic objectForKey:@"categoryname"];
    _detailedName.text = [_dataDic objectForKey:@"categoryname_e"];
    _image.image = [UIImage imageNamed:@"pic_default"];
    
}




- (IBAction)buttonAction:(id)sender {
    
    
    PlayVideoViewController *PlayVideoVC = [[PlayVideoViewController alloc]init];
    
    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    
    [vc.navigationController pushViewController:PlayVideoVC animated:YES];
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _bjView.layer.borderWidth = .5;
    _bjView.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1]CGColor];
    // Configure the view for the selected state
}

@end
