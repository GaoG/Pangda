//
//  PersonInformationViewController.m
//  pangdaSpeaking
//
//  Created by benniaoyasi on 15/12/10.
//  Copyright © 2015年 jingzexiang. All rights reserved.
//

#import "PersonInformationViewController.h"
#import "PersonInformationViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ModifyNameViewController.h"
#import "MobClick.h"
@interface PersonInformationViewController (){

    NSMutableArray *array;
    UIWindow *window;
    UIView *view;

}

@property (nonatomic,strong)UITableView *myTableView;

@end

@implementation PersonInformationViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    window = [[UIApplication sharedApplication]keyWindow];
    array = [[NSMutableArray alloc]initWithObjects:@"头像",@"名称",@"ID", nil];
    
    [self addTitleViewWithTitle:@"个人信息"];
    
    [self addItemWithImageData:[UIImage imageNamed:@"nav_arrow_n"] andHightImage:[UIImage imageNamed:@"nav_arrow_h"]  andFrame:CGRectMake(30, 10, 11, 18) selector:@selector(leftBackAction) location:YES];
    
    [self initTableView];
    
    [self initBringView];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PersonInformationViewController"];
    // 隐藏Tabbar
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:@"yes"];

    [_myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PersonInformationViewController"];
    
}

- (void)initBringView{

    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];

    view.backgroundColor = [UIColor blackColor];
    view.alpha = .6;
    [window addSubview:view];
    view.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
}



- (void)initTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    }
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.tableFooterView = [[UIView alloc]init];
    _myTableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0  blue:250/255.0  alpha:1];
    [self.view addSubview:_myTableView];
    
    
}


#pragma mark tableView deleaget
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDF = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDF objectForKey:@"userHeadImage"];
    static NSString *identify = @"PersonInformationViewCell";
        PersonInformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
        }
    if (indexPath.row==0) {
        cell.contentLabel.hidden = YES;
        if (imageData) {
            cell.headImage.image = [UIImage imageWithData:imageData];
        }
        
        
    }else if(indexPath.row == 1){
        cell.headImage.hidden = YES;
        cell.moreImage.hidden = YES;
        cell.contentLabel.text = [userDF objectForKey:@"user_chinesename"];
    
    }else if(indexPath.row == 2) {
    cell.headImage.hidden = YES;
        cell.moreImage.hidden = YES;
        cell.contentLabel.text = @"20151212";
    }
    
    cell.nameLabel.text = array[indexPath.row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
        return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }

    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        view.hidden = NO;
        
        UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
        
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
         [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    /*
    *****修改名字
     */
    if (indexPath.row ==1){
        ModifyNameViewController *ModifyNameVC = [[ModifyNameViewController alloc]init];
        [self.navigationController pushViewController:ModifyNameVC animated:YES];
        
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
//            调用相机
        case 0:
            [self addCamera];
            view.hidden = YES;
            break;
        case 1:
//            调用系统相册
            [self callSystemPhotoAlbum];
            view.hidden = YES;
            break;
        case 2:
            [self tapAction];
            break;
            
        default:
            break;
    }

    
    
    

}


- (void)tapAction{

    view.hidden = YES;

}


- (void)addCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum:相机胶卷
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { //否则打开照片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}



#pragma mark 调用系统相册
- (void)callSystemPhotoAlbum{

    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
    }];
    
}


#pragma mark 调用相册完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqual:@"public.image"]) {
        UIImage *selectImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData=UIImageJPEGRepresentation(selectImage, 0.0001);
        
//        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//       
//        NSString *url=[NSString stringWithFormat:@"http://123.57.16.143/api.php?appid=1&m=api&c=user&a=updateuserinfo"];
//        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:imageData name:@"images_1" fileName:@"QQ.jpg" mimeType:@"image/jpeg"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@" tttt%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
            [user setObject:imageData forKey:@"userHeadImage"];
            
            [user synchronize];

//            if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
//            {
////                保存到相册
//                UIImageWriteToSavedPhotosAlbum(selectImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////            失败的话
//            NSLog(@"%@", error.localizedDescription);
//        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
     [_myTableView reloadData];
}

- (void)leftBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];

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
