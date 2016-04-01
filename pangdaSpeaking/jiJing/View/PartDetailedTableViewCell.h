//
//  PartDetailedTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/30.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartDetailedTableViewCell : UITableViewCell



@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *heardimage;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end
