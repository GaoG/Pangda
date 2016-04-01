//
//  PartOnePlayCell.h
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCurrentCountIndexBlock)(NSString *str);

typedef void(^myRecordBlock)(NSString *str,NSString *file) ;
@interface PartOnePlayCell : UITableViewCell


@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIView *answerBjView;

@property (weak, nonatomic) IBOutlet UILabel *englishAnswer;

@property (weak, nonatomic) IBOutlet UILabel *ChineseAnswer;

@property (weak, nonatomic) IBOutlet UIImageView *flgImageView;

@property (weak, nonatomic) IBOutlet UIButton *playButOne;

@property (weak, nonatomic) IBOutlet UIButton *recordButOne;

@property (weak, nonatomic) IBOutlet UIButton *playButTwo;

@property (weak, nonatomic) IBOutlet UIButton *recordButTwo;


@property (weak, nonatomic) IBOutlet UIButton *haerOneBut;

@property (weak, nonatomic) IBOutlet UIButton *hearTwoBut;



@property(nonatomic,strong)selectCurrentCountIndexBlock selectBlock;

@property (nonatomic,strong)myRecordBlock recordBlock;



@end
