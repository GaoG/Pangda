//
//  MeOneTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/12.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeOneTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *heardImge;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreImage;


@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end
