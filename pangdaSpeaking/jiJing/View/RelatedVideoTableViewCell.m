//
//  RelatedVideoTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/13.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "RelatedVideoTableViewCell.h"

@implementation RelatedVideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    [_bjImage addGestureRecognizer:tap];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}

- (void)setImageUrl:(NSString *)imageUrl{

    _imageUrl = imageUrl;
    
    [_bjImage setImageWithURL:[NSURL URLWithString:_imageUrl]];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"user_name"]){
    
        _bjImage.userInteractionEnabled = YES;
    }else{
    
        _bjImage.userInteractionEnabled = NO;
    
    }

}


-(void)tapAction{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"user_name"]) {
        [self login];
        return;
    }


}


#pragma mark 登录
- (void)login{
    
    
        [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 显示主控制器（登录界面）
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    
    UINavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"navgationController"];
    
        UIViewController *VC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    
    [VC presentViewController:nav animated:YES completion:^{
        
    }];
    
    
    
}


@end
