//
//  MeOneTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/12.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "MeOneTableViewCell.h"

@implementation MeOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    _heardImge.layer.masksToBounds = YES;
    _heardImge.layer.cornerRadius = 5;
    
    // Configure the view for the selected state
}

@end
