//
//  VideoTableViewCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/28.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleName;


@property (nonatomic,copy)NSString *part;
@property (nonatomic,strong)NSMutableArray *dataArray;



//@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
//
//@property (weak, nonatomic) IBOutlet UILabel *labelOne;
//
//
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
//@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
//
//
//
//
//
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewThree;
//
//
//@property (weak, nonatomic) IBOutlet UILabel *labelThree;


@end
