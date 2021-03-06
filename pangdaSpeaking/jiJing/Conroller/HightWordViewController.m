//
//  HightWordViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/25.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "HightWordViewController.h"
#import "WordHightTableViewCell.h"
@interface HightWordViewController (){

    UIButton *blackBut;
    UILabel *titleLabel;

}

@end

@implementation HightWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTitleView];
    [self initTableView];
    

}


- (void)setDataArr:(NSMutableArray *)dataArr{

    _dataArr = dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

     [MobClick beginLogPageView:@"HightWordViewController"];
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


#pragma mark 头部ui
- (void)initTitleView{

    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 64)];
    
    bjView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0  blue:242/255.0  alpha:0.1];
    
    [self.view addSubview:bjView];
    
    blackBut = [UIButton buttonWithType:UIButtonTypeCustom];
    blackBut.frame = CGRectMake(self.view.width-50, 32, 40, 20);
    [blackBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
    [blackBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateHighlighted];
    [blackBut setTitle:@"取消" forState:UIControlStateNormal];
    blackBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [blackBut addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    [bjView addSubview:blackBut];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30 ,KSCREENWIDTH , 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    titleLabel.text= @"高分词汇";
    if (_myTitle) {
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
       titleLabel.text= _myTitle;
    }
    
    [bjView addSubview:titleLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, KSCREENWIDTH, .5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    [bjView addSubview:line];

}


#pragma mark tableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

    return _dataArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identify = @"WordHightTableViewCell";
    
    WordHightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if ( !cell) {
        
         cell= [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil] lastObject];
    }
    cell.dataArr = [self calculateHeight:[_dataArr[indexPath.row]objectForKey:@"ci"]];
    cell.dataDic = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return [self calculateTotalHeight:[_dataArr[indexPath.row]objectForKey:@"ci"]];

   
}


- (void)leftBackAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}




/*
 *** 计算高度
 */
- (NSMutableArray *)calculateHeight:(NSMutableArray *)arr{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i= 0; i<arr.count; i++) {
        
        CGSize sizeToFit = [ arr[i] sizeWithFont: [UIFont systemFontOfSize: 15]
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

- (CGFloat)calculateTotalHeight:(NSMutableArray *)arr{
    CGFloat totalHeight = 0.0f;
    NSArray *tempArr  = [self calculateHeight:arr];
    
    for (int i= 0; i<tempArr.count; i++) {
        totalHeight +=[[tempArr objectAtIndex:i] integerValue];
        
    }
    
    
    return totalHeight+70;
}




    

    

    


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HightWordViewController"];
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
