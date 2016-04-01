//
//  ImageTableViewCell.m
//  familyTest
//
//  Created by Gao on 14-12-25.
//  Copyright (c) 2014年 huangxiaoya. All rights reserved.
//

#define CGRectOrigin(v)    v.frame.origin
#define CGRectSize(v)      v.frame.size
#define CGRectX(v)         CGRectOrigin(v).x
#define CGRectY(v)         CGRectOrigin(v).y
#define CGRectW(v)         CGRectSize(v).width
#define CGRectH(v)         CGRectSize(v).height
#import "UIButton+WebCache.h"
#import "ImageTableViewCell.h"
#import "ILMessageWebViewController.h"
static NSString *iden = @"cell";
@implementation ImageTableViewCell{
    NSMutableArray*nameArr;//轮播图片的信息
     CGSize _size;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(void)setDataarr:(NSMutableArray *)dataarr{

    _dataarr = dataarr;
    if (dataarr.count >0) {
         [self initContent];
    }
   
    
}



-(void)initContent
{
    _size = [UIScreen mainScreen].bounds.size;
    self.MyPage.pageIndicatorTintColor = [UIColor grayColor];
    self.MyPage.currentPageIndicatorTintColor = [UIColor redColor];
    self.adPeriodTime=2.0f;
    
/*
 *** 隐藏desLabel
 */
    self.desLabel.hidden = YES;
    //清楚数据
    for ( UIView*vi in self.scrollView.subviews)
    {
        [vi removeFromSuperview];
    }
    self.MyPage.numberOfPages=0;
    self.desLabel.text=nil;
    if (self.dataarr.count==0) {
        return;
    }
    //轮播图片的信息
    nameArr=[[NSMutableArray alloc]init];
    self.adDataArray=[[NSMutableArray alloc]init];
    for (int i=0; i<_dataarr.count; i++) {
        NSMutableDictionary *dic = _dataarr[i];
        NSURL*url=[NSURL URLWithString:[dic objectForKey:@"img"]];
        [self.adDataArray addObject:url];
        NSString *name = [dic objectForKey:@"title"];
        [nameArr addObject:name];
    }
    if (self.adDataArray.count==1) {
        self.adAutoplay=NO;
        [self.adLoopTimer invalidate];
        self.adLoopTimer=nil;
        self.scrollView.scrollEnabled=NO;
        self.MyPage.numberOfPages=0;
    }else
    {
        self.adAutoplay=YES;
        self.scrollView.delegate=self;
        self.scrollView.scrollEnabled=YES;
        self.scrollView.pagingEnabled=YES;
        self.MyPage.numberOfPages=self.adDataArray.count;
    }
    for (int i=0; i<self.adDataArray.count; i++) {
        NSURL *im=self.adDataArray[i];
        UIImageView *addImage=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*_size.width, 0, _size.width, 160)];
        
        [self.scrollView addSubview:addImage];
         [addImage setImageWithURL:im placeholderImage:[UIImage imageNamed:@"pic_default"] options:SDWebImageLowPriority];
        
        UIButton *adBtn=[[UIButton alloc]initWithFrame:CGRectMake((i+1)*_size.width, 0, _size.width, 160)];
        [adBtn setContentMode:UIViewContentModeScaleAspectFill];
        adBtn.tag=i;
        [adBtn addTarget:self action:@selector(adBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:adBtn];
        
    }
    self.desLabel.text=nameArr[0];

    [self.scrollView setContentSize:CGSizeMake(_size.width*(self.adDataArray.count+2), 160)];
    NSURL*lastAdImg=self.adDataArray[self.adDataArray.count-1];

    UIButton *lastAdBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _size.width, 160)];

    [lastAdBtn setImageWithURL:lastAdImg placeholderImage:[UIImage imageNamed:@" "]];
    [lastAdBtn setContentMode:UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:lastAdBtn];
    
    NSURL *firstImg=self.adDataArray[0];

     UIButton *firstAdBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.adDataArray.count+1)*_size.width, 0, _size.width, 160)];

    [firstAdBtn setImageWithURL:firstImg placeholderImage:[UIImage imageNamed:@" "]];
    [firstAdBtn setContentMode:UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:firstAdBtn];
    
    [self.scrollView setContentOffset:CGPointMake(_size.width, 0)];
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
        }
    }
}
#pragma mark - 循环播放
-(void)loopAd{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = self.scrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.MyPage.currentPage = self.MyPage.numberOfPages-1;
    }
    else if (currentPage == self.MyPage.numberOfPages+1) {
        self.MyPage.currentPage = 0;
    }
    else {
        self.MyPage.currentPage = currentPage-1;
    }
    
    __block NSInteger currPageNumber = self.MyPage.currentPage;
    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.scrollView scrollRectToVisible:rect animated:NO];
    } completion:^(BOOL finished) {
        currPageNumber++;
        if (currPageNumber == self.MyPage.numberOfPages) {
            [self.scrollView setContentOffset:CGPointMake(_size.width, 0)];
            currPageNumber = 0;
        }
    }];
    
    currentPage = self.scrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.MyPage.currentPage = self.MyPage.numberOfPages-1;
    }
    else if (currentPage == self.MyPage.numberOfPages+1) {
        self.MyPage.currentPage = 0;
    }
    else {
        self.MyPage.currentPage = currentPage-1;
    }
    self.desLabel.text=nameArr[self.MyPage.currentPage];
}
#pragma mark---- UIScrollView delegate methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentAdPage;
    currentAdPage=self.scrollView.contentOffset.x/_size.width;
    if (currentAdPage==0) {
//        [scrollView scrollRectToVisible:CGRectMake(_size.width*self.MyPage.numberOfPages, 0, _size.width, CGRectH(self.scrollView)) animated:NO];
        [scrollView scrollRectToVisible:CGRectMake(_size.width*self.MyPage.numberOfPages, 0, _size.width, 160) animated:NO];
        
        currentAdPage=self.MyPage.numberOfPages-1;
    }
    else if (currentAdPage==(self.MyPage.numberOfPages+1)) {
//        [scrollView scrollRectToVisible:CGRectMake(_size.width, 0, _size.width, CGRectH(self.scrollView)) animated:NO];
        [scrollView scrollRectToVisible:CGRectMake(_size.width, 0, _size.width, 160) animated:NO];
        currentAdPage=0;
    }
    else{
        currentAdPage=currentAdPage-1;
    }
    self.MyPage.currentPage=currentAdPage;
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
        }
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.adAutoplay) {
        if (self.adLoopTimer) {
            [self.adLoopTimer invalidate];
            self.adLoopTimer = nil;
        }
    }
}
#pragma mark - 点击
-(void)adBtnClick:(UIButton *)sender{

    
    if([_dataarr[sender.tag] objectForKey:@"url"]&&[[_dataarr[sender.tag] objectForKey:@"url"]length ]>0){
    UIViewController *VC = (UIViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder;
    ILMessageWebViewController *MessageWebVC = [[ILMessageWebViewController alloc]init];
    MessageWebVC.url = [_dataarr[sender.tag] objectForKey:@"url"];
    [VC presentViewController:MessageWebVC animated:YES completion:^{
//
    
    }];
    }
    
    
   
}
@end


