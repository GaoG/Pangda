//
//  NewTopicViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/11/29.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "NewTopicViewController.h"

@interface NewTopicViewController (){
    
    UIView *bjView;
    UISegmentedControl*_navName;//标题
    CGSize _size;
}
@property (nonatomic,strong)UITableView *myTableView;


@end

@implementation NewTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _size = [UIScreen mainScreen].bounds.size;
    
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];

    
    [self addTitleViewWithTitle:@"本季新题"];

    
    [self addItemWithTitle:@"取消" imageName:nil andFrame:CGRectMake(0, 20, 80, 40) selector:@selector(RightItemAction) location:NO];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    
    bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, _size.width, 40)];
    bjView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    [self.view addSubview:bjView];
    
    _navName = [self segControlWithTitle:@[@"Part 1",@"Part 2",] frame:CGRectMake((_size.width- _size.width*2/3)/2, 5, _size.width*2/3, 30) selectIndex:0 color:[UIColor colorWithRed:255/255.0 green:81/255.0 blue:20/255.0 alpha:1]];
    
    
    [_navName addTarget:self action:@selector(segcontrolAction:) forControlEvents:UIControlEventValueChanged];
    
        [bjView addSubview:_navName];
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    }
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  20;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:253/255.0 green:244/255.0 blue:241/255.0 alpha:1];
    
    cell.imageView.image = [UIImage imageNamed:@"sign_"];
    cell.textLabel.text = @"A Bkhrgvnirekhng Chfnvoief";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    
}


- (void)RightItemAction{

    
    
}


- (void)segcontrolAction:(UISegmentedControl *)seg{


    


}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"NewTopicViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewTopicViewController"];
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
