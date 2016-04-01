//
//  ExpoundTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpoundTableViewCell : UITableViewCell

@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UILabel *titleName;




@end
