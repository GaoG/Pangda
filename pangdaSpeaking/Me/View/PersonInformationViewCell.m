//
//  PersonInformationViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/10.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PersonInformationViewCell.h"

@implementation PersonInformationViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 5;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
