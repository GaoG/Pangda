//
//  TodayUpVideoCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayUpVideoCell : UITableViewCell

@property (nonatomic,strong)NSMutableDictionary *dataDic;


@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UILabel *titleName;


@property (weak, nonatomic) IBOutlet UILabel *detailedName;

@property (weak, nonatomic) IBOutlet UIView *bjView;





@end
