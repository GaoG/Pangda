//
//  PartDetailedTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/30.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PartDetailedTableViewCell.h"

@implementation PartDetailedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
    

    
    if ([[dataDic objectForKey:@"upType" ] isEqualToString:@"1"]) {
        NSString *thumb_img =[_dataDic objectForKey:@"thumb_img"];
        if (thumb_img&&![thumb_img isEqualToString:@""]) {
//            [_heardimage setImageWithURL:[NSURL URLWithString:thumb_img]];
            [_heardimage setImageWithURL:[NSURL URLWithString:thumb_img] placeholderImage:[UIImage imageNamed:@"pic_default"] options:SDWebImageRetryFailed];
            
        }
        
        _contentLabel.text =[NSString stringWithFormat:@"%@ - %@", [_dataDic objectForKey:@"chinese"],[_dataDic objectForKey:@"english"]];
        
    }else if ([[dataDic objectForKey:@"upType" ] isEqualToString:@"2"]){
        
        NSString *thumb_img =[_dataDic objectForKey:@"images"];
        if (thumb_img&&![thumb_img isEqualToString:@""]) {
//            [_heardimage setImageWithURL:[NSURL URLWithString:thumb_img]];
            [_heardimage setImageWithURL:[NSURL URLWithString:thumb_img] placeholderImage:[UIImage imageNamed:@"pic_default"] options:SDWebImageRetryFailed];
            
        }
        
        _contentLabel.text =  [_dataDic objectForKey:@"question"];
    }
    
    
    
    UILabel *lin = [[UILabel alloc]initWithFrame:CGRectMake(10, 59, KSCREENWIDTH-20, 1)];
    lin.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.contentView addSubview:lin];

}







@end
