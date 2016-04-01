//
//  ExpoundTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "ExpoundTableViewCell.h"

@implementation ExpoundTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
    
    if ([_dataDic objectForKey:@"title"]&&![[_dataDic objectForKey:@"title"]isEqualToString:@""]) {
      _titleName.text = [_dataDic objectForKey:@"title"];
    }else{
    
     _titleName.text = [_dataDic objectForKey:@"problem"];
    }
    
    if ([_dataDic objectForKey:@"images"]) {
        
       [ _image setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"images"]]];
    }
    
   
    
    
    
   
    
    
    
}


@end
