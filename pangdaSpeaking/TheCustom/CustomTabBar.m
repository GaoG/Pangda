//
//  CustomTabBar.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/21.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar{
    
SelectedBlock _selectedBlock;


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame imageDic:(NSDictionary *)dic selected:(SelectedBlock)block
{
    self=[super initWithFrame:frame];
    if (self) {
        if (_selectedBlock!=block) {
            _selectedBlock=block;
        }
        [self createBtnWithDic:dic];
    }
    return self;
}






-(void)createBtnWithDic:(NSDictionary*)dic
{
    UIImage*img=[UIImage imageNamed:@"di_bj.png"];
    UIEdgeInsets insets=UIEdgeInsetsMake(1, 1, 1, 1);
    img=[img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self setBackgroundColor:[UIColor colorWithPatternImage:img]];
    if ([dic allKeys]==0) {
        NSLog(@"没有读到字典!");
        return;
    }
    //两组图片的名称
    NSArray *imageNames = [dic objectForKey:@"imageName"];
    NSArray *imageNamesH = [dic objectForKey:@"imageNameh"];
    CGFloat space=(self.bounds.size.width-41*3)/4;
    //    NSLog(@"btnW:%f,%f",btnWidth,self.bounds.size.width);
    for (int i=0; i<imageNames.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(space+(41+space)*i, 3, 41,49)];
        btn.tag = i+100;
        [btn setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            //selected == yes 对应 btn 的状态为UIControlStateSelected
            btn.selected = YES;
        }
        [self addSubview:btn];
    }
    
}



- (void)btnClicked:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    //确定哪个btn被选中
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *currentBtn = (UIButton *)view;
            if (currentBtn.tag == btn.tag) {
                //被选中的
                currentBtn.selected = YES;
            }else{
                currentBtn.selected = NO;
            }
        }
    }
    //通过block将编号传出
    _selectedBlock(index);
}

@end
