//
//  PartTwoPlaySecondCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/13.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^cellPlayOrRecode) (NSString *strOne,NSString *strTwo);
@interface PartTwoPlaySecondCell : UITableViewCell


@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *contentEnglish;

@property (weak, nonatomic) IBOutlet UILabel *chineseContent;


@property (weak, nonatomic) IBOutlet UIButton *playBut;


@property (weak, nonatomic) IBOutlet UIButton *recodrBut;


@property (weak, nonatomic) IBOutlet UIButton *hearBut;


@property (nonatomic,strong)cellPlayOrRecode playOrRecodeBlock;


@end
