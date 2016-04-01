//
//  PartThreeViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 16/1/27.
//  Copyright © 2016年 jingzexiang. All rights reserved.
//

#import "PartThreeViewController.h"
#import "PartThreeTableViewCell.h"
@interface PartThreeViewController ()<UITableViewDataSource,UITableViewDelegate>{

    UIButton *blackBut;
    UILabel *titleLabel;
    
}

@end

@implementation PartThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitleView];
    [self initTableView];

}


- (void)setDataArr:(NSMutableArray *)dataArr{
    
    _dataArr = dataArr;
}

#pragma mark 头部ui
- (void)initTitleView{
    
    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 64)];
    
    bjView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0  blue:242/255.0  alpha:0.1];
    
    [self.view addSubview:bjView];
    
    blackBut = [UIButton buttonWithType:UIButtonTypeCustom];
    blackBut.frame = CGRectMake(self.view.width-50, 32, 40, 20);
    //    [blackBut setImage:[UIImage imageNamed:@"nav_arrow_n"] forState:UIControlStateNormal];
    //    [blackBut setImage:[UIImage imageNamed:@"nav_arrow_h"] forState:UIControlStateHighlighted];
    [blackBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
    [blackBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateHighlighted];
    [blackBut setTitle:@"取消" forState:UIControlStateNormal];
    blackBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [blackBut addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    [bjView addSubview:blackBut];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30 ,KSCREENWIDTH , 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    titleLabel.text= @"Part 3";
//    if (_myTitle) {
//        titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        titleLabel.text= _myTitle;
//    }
    
    [bjView addSubview:titleLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, KSCREENWIDTH, .5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    [bjView addSubview:line];
    
}



/*
 **** 创建tableview
 */

- (void)initTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, KSCREENHEIGHT-64) style:UITableViewStylePlain];
    }
    //    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_myTableView];
    
    
}


#pragma mark tableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    return _dataArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"PartThreeTableViewCell";
    
    PartThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if ( !cell) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil] lastObject];
    }
    
   
   cell.dataArr =  [self calculateHeight:[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"p2_chines" ]];
     cell.dataDic = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  [self calculateTotalHeight:[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"p2_chines" ]];
;
    
//        return 200;
    
}


- (void)leftBackAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

/*
 *** 计算高度
 */
- (NSMutableArray *)calculateHeight:(NSString *)str{

    NSMutableArray *array = [NSMutableArray array];

    NSArray *tempArray = [str componentsSeparatedByString:@"\n"];
    
    for (int i= 0; i<tempArray.count; i++) {

        CGSize sizeToFit = [ tempArray[i] sizeWithFont: [UIFont systemFontOfSize: 15]
                            constrainedToSize: CGSizeMake(KSCREENWIDTH-40, CGFLOAT_MAX)
                                lineBreakMode: NSLineBreakByWordWrapping];
        
        if (sizeToFit.height<20) {
            [array addObject:@"25"];
        }else if(sizeToFit.height<40) {
            
            [array addObject:@"45"];
        }else if(sizeToFit.height<60){
        [array addObject:@"65"];
        }
        
        
    }
    
    

    return array;
    
}
/*
 *** 计算总的高度
 */

- (CGFloat)calculateTotalHeight:(NSString *)str{
    CGFloat totalHeight = 0.0f;
    NSArray *tempArr  = [self calculateHeight:str];

    for (int i= 0; i<tempArr.count; i++) {
        totalHeight +=[[tempArr objectAtIndex:i] integerValue];
        
    }
    
    
    return totalHeight+50;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PartThreeViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PartThreeViewController"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
