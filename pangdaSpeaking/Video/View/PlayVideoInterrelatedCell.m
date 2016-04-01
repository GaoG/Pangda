//
//  PlayVideoInterrelatedCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PlayVideoInterrelatedCell.h"

@implementation PlayVideoInterrelatedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.backgroundColor = [UIColor clearColor];
    _bjView.layer.borderWidth = .5;
    _bjView.layer.borderColor = [[UIColor colorWithRed:58/255.0 green:58/255.0  blue:58/255.0  alpha:.3]CGColor];
    
    // Configure the view for the selected state
}


- (void)setDataDic:(NSMutableDictionary *)dataDic {

    _dataDic = dataDic;
    

    [_titleImage setImageWithURL: [NSURL URLWithString:[_dataDic objectForKey:@"image"]]];
    
    _titleName.text = [_dataDic objectForKey:@"problem"];
    
    _detailsName.text = [NSString stringWithFormat:@"%@ - %@",[_dataDic objectForKey:@"title"],[_dataDic objectForKey:@"part"]];

}

@end
