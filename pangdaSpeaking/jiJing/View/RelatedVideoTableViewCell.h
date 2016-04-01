//
//  RelatedVideoTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/13.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedVideoTableViewCell : UITableViewCell

@property (nonatomic,copy)NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bjImage;


@end
