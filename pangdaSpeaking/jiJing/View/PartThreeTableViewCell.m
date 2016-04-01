//
//  PartThreeTableViewCell.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/27.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "PartThreeTableViewCell.h"

@implementation PartThreeTableViewCell{

    UILabel *label;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

}


- (void)setDataArr:(NSMutableArray *)dataArr{

    _dataArr = dataArr;
}
- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
    

    
    _myTitle.text = [_dataDic objectForKey:@"p2_english"];
    

    
    NSArray *tempArr = [[_dataDic objectForKey:@"p2_chines"]componentsSeparatedByString:@"\n"];
    NSInteger tempHight =0;
    for (int i=0; i<tempArr.count; i++) {
//        i*[[_dataArr objectAtIndex:i]integerValue]
        
        label = [[UILabel alloc]initWithFrame: CGRectMake(20, 50+tempHight, KSCREENWIDTH-40, [[_dataArr objectAtIndex:i]integerValue])];
        tempHight += [[_dataArr objectAtIndex:i]integerValue];

        label.font = [UIFont systemFontOfSize:15];
        label.text = [tempArr objectAtIndex:i];
        
        label.numberOfLines = 0;
        label.alpha = .5;
        [self.contentView addSubview:label];
    }
    
    
}
@end
