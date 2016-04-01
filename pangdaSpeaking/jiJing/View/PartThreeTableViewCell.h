//
//  PartThreeTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/27.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartThreeTableViewCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *myTitle;

@property (weak, nonatomic) IBOutlet UITextView *myContent;



@end
