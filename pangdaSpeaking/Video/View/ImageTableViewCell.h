//
//  ImageTableViewCell.h
//  familyTest
//
//  Created by Gao on 14-12-25.
//  Copyright (c) 2014年 huangxiaoya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) UICollectionView *_collectionview;

@property (nonatomic,strong) NSMutableArray *dataarr;

@property(nonatomic,retain) NSTimer *adLoopTimer;
@property(nonatomic,retain) NSMutableArray *adDataArray;  //广告图片数组
@property(nonatomic,retain) NSMutableArray *DataArray;  //广告图片数组
@property(nonatomic,assign) CGFloat adPeriodTime; //切换广告时间,默认2秒
@property(nonatomic,assign) BOOL adAutoplay;  //是否自动播放广告,默认yes
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIPageControl *MyPage;

-(void)initContent;

@end
