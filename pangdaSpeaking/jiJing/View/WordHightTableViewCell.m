//
//  WordHightTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/26.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "WordHightTableViewCell.h"

@implementation WordHightTableViewCell{

    UILabel *label;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    _myContent.editable = NO;
//    _myContent.scrollEnabled = NO;
    // Configure the view for the selected state
    
}


- (void)setDataArr:(NSMutableArray *)dataArr{

    _dataArr = dataArr;
}

- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
//    _myContent.hidden = YES;
    

    
    NSInteger tempHight =0;
    for (int i=0; i<[[_dataDic objectForKey:@"ci"]count]; i++) {
        //        i*[[_dataArr objectAtIndex:i]integerValue]
        
        label = [[UILabel alloc]initWithFrame: CGRectMake(20, 50+tempHight, KSCREENWIDTH-40, [[_dataArr objectAtIndex:i]integerValue])];
        tempHight += [[_dataArr objectAtIndex:i]integerValue];
        
        label.font = [UIFont systemFontOfSize:15];
        label.text = [[_dataDic objectForKey:@"ci"] objectAtIndex:i];
        label.numberOfLines = 0;
        label.alpha = .5;
        [self.contentView addSubview:label];
    }
    
    
    
    
//    
//    for (int i=0; i<[[_dataDic objectForKey:@"ci"]count]; i++) {
//        
//        label = [[UILabel alloc]initWithFrame: CGRectMake(20, 50+i*35, self.width-40, 35)];
//        
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = [[_dataDic objectForKey:@"ci"] objectAtIndex:i];
//        label.numberOfLines = 0;
//        [self.contentView addSubview:label];
//    }
    
 
    
    _myTitle.text = [_dataDic objectForKey:@"title"];
//    _myContent.text = [[_dataDic objectForKey:@"ci"]lastObject];
    
    
}

@end
