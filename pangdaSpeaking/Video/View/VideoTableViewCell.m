//
//  VideoTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "ExpoundViewController.h"
#import "PlayVideoViewController.h"
@implementation VideoTableViewCell{

    UIImageView *imageViewOne;
    UILabel *labelOne;
    UIImageView *imageViewTwo;
    UILabel *labelTwo;
    UIImageView *imageViewThree;
    UILabel *labelThree;
    UIImageView *partOneImage;
    UIImageView *partTwoImage;
    UIImageView *partThreeImage;
    NSInteger imageWidth;

}



- (void)awakeFromNib {
    // Initialization code
    imageWidth = (KSCREENWIDTH-44)/3;
    [self addTouchAction];
    
}

- (IBAction)lookMore:(id)sender {
    ExpoundViewController *ExpoundVC = [[ExpoundViewController alloc]init];

    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    ExpoundVC.titleName = _titleName.text;
    [vc.navigationController pushViewController:ExpoundVC animated:YES];
}


- (void)setPart:(NSString *)part{

    _part = part;
}


- (void)addTouchAction{
    
    imageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(12, 35, imageWidth, imageWidth)];
    imageViewOne.image = [UIImage imageNamed:@"pic_default"];
    imageViewOne.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *touchOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOneAction)];
    [imageViewOne addGestureRecognizer:touchOne];
    [self addSubview:imageViewOne];
    
    imageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(22+imageWidth, 35, imageWidth, imageWidth)];
    imageViewTwo.image = [UIImage imageNamed:@"pic_default"];
    imageViewTwo.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *touchTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTwoAction)];
    [imageViewTwo addGestureRecognizer:touchTwo];
    [self addSubview:imageViewTwo];
    
    
    imageViewThree = [[UIImageView alloc]initWithFrame:CGRectMake(32+2*imageWidth, 35, imageWidth, imageWidth)];
    imageViewThree.image = [UIImage imageNamed:@"pic_default"];
    imageViewThree.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *touchThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchThreeAction)];
    [imageViewThree addGestureRecognizer:touchThree];
    [self addSubview:imageViewThree];
    
    
    labelOne = [[UILabel alloc]initWithFrame:CGRectMake(12, 40+imageWidth, imageWidth, 35)];
    labelOne.font = [UIFont systemFontOfSize:13];
    labelOne.numberOfLines = 0;
//    labelOne.text = @"uhvdksj";
    labelOne.userInteractionEnabled = YES;
    

    [self addSubview:labelOne];
    
    
    labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(22+imageWidth, 40+imageWidth, imageWidth, 35)];
    labelTwo.font = [UIFont systemFontOfSize:13];
    labelTwo.numberOfLines = 0;
//    labelTwo.text = @"uhvdksj";
    labelTwo.userInteractionEnabled = YES;
    

    [self addSubview:labelTwo];
    
    
    
    labelThree = [[UILabel alloc]initWithFrame:CGRectMake(32+2*imageWidth, 40+imageWidth, imageWidth, 35)];
    labelThree.font = [UIFont systemFontOfSize:13];
    labelThree.numberOfLines = 0;
//    labelThree.text = @"uhvdksj";
    labelThree.userInteractionEnabled = YES;
    
    [self addSubview:labelThree];
    
    partOneImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewOne.width-26, 0, 26, 26)];
    [imageViewOne addSubview:partOneImage];
    partTwoImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewTwo.width-26, 0, 26, 26)];
    [imageViewTwo addSubview:partTwoImage];
    partThreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewThree.width-26, 0, 26, 26)];
    [imageViewThree addSubview:partThreeImage];
    
    
    
    
}


- (void)touchOneAction{

    PlayVideoViewController *PlayVideoVC = [[PlayVideoViewController alloc]init];
    
    
    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    PlayVideoVC.myId = [_dataArray[0] objectForKey:@"id"];
    PlayVideoVC.type = [_dataArray[0] objectForKey:@"part"];
    PlayVideoVC.part = _part;
    [vc.navigationController pushViewController:PlayVideoVC animated:YES];

}

- (void)touchTwoAction{
    
    PlayVideoViewController *PlayVideoVC = [[PlayVideoViewController alloc]init];
    
    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    PlayVideoVC.type = [_dataArray[1] objectForKey:@"part"];
    PlayVideoVC.myId = [_dataArray[1] objectForKey:@"id"];
    PlayVideoVC.part = _part;
    [vc.navigationController pushViewController:PlayVideoVC animated:YES];
    
}

- (void)touchThreeAction{
    
    PlayVideoViewController *PlayVideoVC = [[PlayVideoViewController alloc]init];
    
    UIViewController *vc = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    
    PlayVideoVC.myId = [_dataArray[2] objectForKey:@"id"];
    PlayVideoVC.type = [_dataArray[2] objectForKey:@"part"];
    PlayVideoVC.part = _part;
    [vc.navigationController pushViewController:PlayVideoVC animated:YES];
    
}






- (void)setDataArray:(NSMutableArray *)dataArray{

    _dataArray = dataArray;
    
    labelOne.text = [_dataArray[0] objectForKey:@"title"];
    labelTwo.text = [_dataArray[1] objectForKey:@"title"];
    labelThree.text = [_dataArray[2] objectForKey:@"title"];
    
    [imageViewOne setImageWithURL:[NSURL URLWithString:[_dataArray[0] objectForKey:@"images"]]];
    [imageViewTwo setImageWithURL:[NSURL URLWithString:[_dataArray[1] objectForKey:@"images"]]];
    [imageViewThree setImageWithURL:[NSURL URLWithString:[_dataArray[2] objectForKey:@"images"]]];
    
    
    if ([[_dataArray[0] objectForKey:@"part"]isEqualToString:@"1"]) {
        
        partOneImage.image = [UIImage imageNamed:@"sign_p1"];
    }else  {
    partOneImage.image = [UIImage imageNamed:@"sign_p2"];
    
    }
    
    if ([[_dataArray[1] objectForKey:@"part"]isEqualToString:@"1"]) {
        
        partTwoImage.image = [UIImage imageNamed:@"sign_p1"];
    }else  {
        partTwoImage.image = [UIImage imageNamed:@"sign_p2"];
        
    }
    
    if ([[_dataArray[2] objectForKey:@"part"]isEqualToString:@"1"]) {
        
        partThreeImage.image = [UIImage imageNamed:@"sign_p1"];
    }else  {
        partThreeImage.image = [UIImage imageNamed:@"sign_p2"];
        
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
