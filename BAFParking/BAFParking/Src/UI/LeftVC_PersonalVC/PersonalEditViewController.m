//
//  PersonalEditViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalEditViewController.h"
#import "BAFCenterViewController.h"
#import "PersonalEditTableViewCell.h"
#import <IQKeyboardManager.h>
#import "PopViewController.h"
#import "BAFCityInfo.h"
#import "UIViewController+MMDrawerController.h"
#import "NSString+ImageExtName.h"

#define  baf_client_id  @"client_id" //用户 id
#define  baf_cname      @"cname" //姓名
#define  baf_csex       @"csex" //性别:0.未知;1.男;2.女
#define  baf_carnum     @"carnum" //车牌号
#define  baf_caddr      @"caddr" //常驻城市 id
#define  baf_brand      @"brand" //品牌
#define  baf_color      @"color" //车身颜色
#define  baf_ctel       @"ctel"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCityList,
    kRequestNumberIndexColorList,
    kRequestNumberIndexEditClient,
    kRequestNumberIndexClientInfo,
    kRequestNumberIndexClientAvatar,
};

#define PersonalEditTableViewCellIdentifier  @"PersonalEditTableViewCellIdentifier"

@interface PersonalEditViewController ()<UITableViewDelegate, UITableViewDataSource,PopViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *identityArr;
@property (nonatomic, strong) NSMutableArray *carArr;
@property (nonatomic, strong) NSMutableArray<BAFCityInfo *>       *cityArr;
@property (nonatomic, strong) NSMutableArray *colorArr;

@property (nonatomic, strong) NSMutableDictionary *clientDic;
@property (nonatomic, strong) UIImage *headerImage;
@end

@implementation PersonalEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.identityArr = [NSMutableArray arrayWithArray:@[@[@"头像",@"修改头像"],@[@"姓名",@"请输入姓名"],@[@"性别",@"请选择性别"],@[@"手机号码",@"请输入手机号码"],@[@"常驻城市",@"请选择常驻城市"]]];
    self.carArr = [NSMutableArray arrayWithArray:@[@[@"车牌号",@"如：京12345"],@[@"颜色",@"请选择车辆颜色"],@[@"品牌",@"请输入车辆品牌"]]];
    
    self.cityArr = [NSMutableArray array];
    self.colorArr = [NSMutableArray array];
    self.clientDic = [NSMutableDictionary dictionary];
    
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    self.headerImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"编辑资料"];
    [self setNavigationRightButtonWithText:@"完成" method:@selector(rightBtnClicked:)];
    
    [self cityListRequest];
    [self colorListRequest];
    [self getAccountInfo];
}

- (void)backMethod:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
//    for (UIViewController *tempVC in self.navigationController.viewControllers) {
//        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
//            [self.navigationController popToViewController:tempVC animated:YES];
//        }
//    }
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    PersonalEditTableViewCell *namecell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (namecell.inputTF.text.length>0) {
        [self.clientDic setObject:namecell.inputTF.text forKey:baf_cname];
    }
    
    PersonalEditTableViewCell *phonecell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (phonecell.inputTF.text.length>0) {
        [self.clientDic setObject:phonecell.inputTF.text forKey:baf_ctel];
    }
    
    PersonalEditTableViewCell *carnumbercell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (carnumbercell.inputTF.text.length>0) {
        [self.clientDic setObject:carnumbercell.inputTF.text forKey:baf_carnum];
    }
    
    PersonalEditTableViewCell *brandcell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (brandcell.inputTF.text.length>0) {
        [self.clientDic setObject:brandcell.inputTF.text forKey:baf_brand];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.clientDic];
    if ([param objectForKey:baf_caddr]) {
        NSArray *arr = [[param objectForKey:baf_caddr] componentsSeparatedByString:@"&"];
        [param setObject:arr[1] forKey:baf_caddr];
    }
    
    if (param.count>0) {
        BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
        [param setObject:userInfo.clientid forKey:@"client_id"];
        
        if ([[param objectForKey:baf_csex] isEqualToString:@"男"]) {
            [param setObject:[NSNumber numberWithInteger:1] forKey:baf_csex];
        }else if ([[param objectForKey:baf_csex] isEqualToString:@"女"]) {
            [param setObject:[NSNumber numberWithInteger:2] forKey:baf_csex];
        }
        
        [self clientEditRequestWithParam:param];
    }else{
        [self showTipsInView:self.view message:@"请输入更改内容" offset:self.view.center.x+100];
    }
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 64.0f;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalEditTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PersonalEditTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalEditTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    PersonalEditTableViewCellType type;
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    if (section == 0) {
        if (row == 0) {
            type = PersonalEditTableViewCellTypeEditHead;
            if (self.headerImage) {
                [cell updateImage:self.headerImage];
            }else{
                NSString *headerStr = [NSString stringWithFormat:@"%@%@",Server_Url, userInfo.avatar];
                [cell updateImageUrl:[NSURL URLWithString:headerStr]];
//                //没有的时候用/Public/Weixin/images/four/logo02.png有的时候为/Uploads/user/7296/20170504/avatar_7296611               
            }
        }else if (row == 1||row == 3){
            type = PersonalEditTableViewCellTypeEdit;
            if (row == 1) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_cname]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_cname]];
                }else{
                    if (userInfo.cname && ![userInfo.cname isEqual:[NSNull null]]) {
                        [self.clientDic setObject:userInfo.cname forKey:baf_cname];
                        [cell updateDetail:userInfo.cname];
                    }
                }
            }
            
            if (row == 3) {
                cell.inputTF.userInteractionEnabled = NO;
                cell.inputTF.enabled = NO;
                if (self.clientDic &&[self.clientDic objectForKey:baf_ctel]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_ctel]];
                }else{
                    if (userInfo.ctel && ![userInfo.ctel isEqual:[NSNull null]]) {
                        [self.clientDic setObject:userInfo.ctel forKey:baf_ctel];
                        [cell updateDetail:userInfo.ctel];
                    }
                }
            }
            
        }else{
            if (row == 2) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_csex]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_csex]];
                }else{
                    if (userInfo.csex.integerValue == 1) {
                        [self.clientDic setObject:@"男" forKey:baf_csex];
                        [cell updateDetail:@"男"];
                    }
                    
                    if (userInfo.csex.integerValue == 2) {
                        [self.clientDic setObject:@"女" forKey:baf_csex];
                        [cell updateDetail:@"女"];
                    }
                }
            }
            if (row == 4) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_caddr]) {
                    NSArray *arr = [[self.clientDic objectForKey:baf_caddr] componentsSeparatedByString:@"&"];
                    [cell updateDetail:arr[0]];
                }else{
                    if (userInfo.city_name && ![userInfo.city_name isEqual:[NSNull null]]) {
                        [self.clientDic setObject:[NSString stringWithFormat:@"%@&%@", userInfo.city_name,userInfo.caddr] forKey:baf_caddr];
                        [cell updateDetail:userInfo.city_name];
                    }
                }
            }
            type = PersonalEditTableViewCellTypeSelect;
        }
        NSArray *arr = [self.identityArr objectAtIndex:row];
        [cell setTitle:arr[0] detail:arr[1] type:type];
    }
    else{
        if (row == 0||row == 2) {
            type = PersonalEditTableViewCellTypeEdit;
            if (row == 0) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_carnum]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_carnum]];
                }
                else{
                    if (userInfo.carnum && ![userInfo.carnum isEqual:[NSNull null]]) {
                        [self.clientDic setObject:userInfo.carnum forKey:baf_carnum];
                        [cell updateDetail:userInfo.carnum];
                    }
                }
            }
            if (row == 2) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_brand]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_brand]];
                }
                else{
                    if (userInfo.brand && ![userInfo.brand isEqual:[NSNull null]]) {
                        [self.clientDic setObject:userInfo.brand forKey:baf_brand];
                        [cell updateDetail:userInfo.brand];
                    }
                }
            }
            
        }else{
            if (row == 1) {
                if (self.clientDic &&[self.clientDic objectForKey:baf_color]) {
                    [cell updateDetail:[self.clientDic objectForKey:baf_color]];
                }
                else{
                    if (userInfo.color && ![userInfo.color isEqual:[NSNull null]]) {
                        [self.clientDic setObject:userInfo.color forKey:baf_color];
                        [cell updateDetail:userInfo.color];
                    }
                }
            }
            
            type = PersonalEditTableViewCellTypeSelect;
        }
        NSArray *arr = [self.carArr objectAtIndex:row];
        [cell setTitle:arr[0] detail:arr[1] type:type];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0&& indexPath.section == 0) {
        //修改头像
        [self modifyHeadMenu];
    }else if (indexPath.row == 2&& indexPath.section == 0) {
        //选择性别
        PopViewController *popView = [[PopViewController alloc] init];
        popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.definesPresentationContext = YES;
        popView.delegate = self;
        [popView configViewWithData:@[@"男",@"女"] type:kPopViewControllerTypeSelecSex];
        [self presentViewController:popView animated:NO completion:nil];
    }else if (indexPath.row == 4&& indexPath.section == 0) {
        //选择常驻城市
        PopViewController *popView = [[PopViewController alloc] init];
        popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.definesPresentationContext = YES;
        popView.delegate = self;
        [popView configViewWithData:self.cityArr type:kPopViewControllerTypeSelecCity];
        [self presentViewController:popView animated:NO completion:nil];
    }else if (indexPath.row == 1&&indexPath.section == 1) {
        //选择车辆颜色
        PopViewController *popView = [[PopViewController alloc] init];
        popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.definesPresentationContext = YES;
        popView.delegate = self;
        [popView configViewWithData:self.colorArr type:kPopViewControllerTypeSelecColor];
        [self presentViewController:popView animated:NO completion:nil];
    }
}

#pragma mark - PopViewControllerDelegate
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    switch (type) {
        case kPopViewControllerTypeSelecCity:
        {
            BAFCityInfo *currentCity = ((BAFCityInfo *)[self.cityArr objectAtIndex:popview.selectedIndex.row]);
            DLog(@"当前选择城市%@",currentCity.title);
            [self.clientDic setObject:[NSString stringWithFormat:@"%@&%@",currentCity.title,currentCity.id] forKey:baf_caddr];
            NSArray *indexpathArr = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil];
            [self.tableview reloadRowsAtIndexPaths:indexpathArr withRowAnimation:UITableViewRowAnimationNone];
            
        }
            break;
        case kPopViewControllerTypeSelecColor:
        {
            NSString *str = [self.colorArr objectAtIndex:popview.selectedIndex.row];
            DLog(@"当前选择颜色%@",str);
            [self.clientDic setObject:str forKey:baf_color];
            NSArray *indexpathArr = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:1], nil];
            [self.tableview reloadRowsAtIndexPaths:indexpathArr withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case kPopViewControllerTypeSelecSex:
        {
            NSString *str = [@[@"男",@"女"] objectAtIndex:popview.selectedIndex.row];
            DLog(@"当前选择性别%@",str);
            [self.clientDic setObject:str forKey:baf_csex];
            NSArray *indexpathArr = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil];
            [self.tableview reloadRowsAtIndexPaths:indexpathArr withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Request
- (void)cityListRequest
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq cityListRequestWithNumberIndex:kRequestNumberIndexCityList delegte:self];
}

- (void)colorListRequest
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq carColorListRequestWithNumberIndex:kRequestNumberIndexColorList delegte:self];
}

- (void)clientEditRequestWithParam:(NSDictionary *)dic
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq clientEditRequestWithNumberIndex:kRequestNumberIndexEditClient delegte:self param:dic];
}

- (void)getAccountInfo
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq clientInfoRequestWithNumberIndex:kRequestNumberIndexClientInfo delegte:self client_id:userInfo.clientid];
}

- (void)clientEditAvatarWithParam:(NSDictionary *)dic
{
//    api/client/client_avatar
    //client_id   avatar_data文件二进制数据  avatar_ext文件扩展名
}
#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexCityList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //城市列表
            if (self.cityArr) {
                [self.cityArr removeAllObjects];
            }
            self.cityArr = [BAFCityInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexColorList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //城市列表
            if (self.colorArr) {
                [self.colorArr removeAllObjects];
            }
            self.colorArr = [NSMutableArray arrayWithArray:[obj objectForKey:@"data"]];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexEditClient) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:@"保存成功" offset:self.view.center.x+100];
//            [self getAccountInfo];
            [self backMethod:nil];
        }else{
            NSUInteger failureCode =[[obj objectForKey:@"code"] integerValue];
            NSString *failureStr = nil;
            switch (failureCode) {
                case 1:
                    failureStr = @"缺少参数";
                    break;
                case 2:
                    failureStr = @"车牌号格式不正确";
                    break;
                default:
                    break;
            }
            if (failureStr) {
                [self showTipsInView:self.view message:failureStr offset:self.view.center.x+100];
            }
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientInfo) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            BAFUserInfo *userInfo = [BAFUserInfo mj_objectWithKeyValues:[obj objectForKey:@"data"]];
            [[BAFUserModelManger sharedInstance]saveUserInfo:userInfo];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientAvatar) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:[obj objectForKey:@"头像更换成功"] offset:self.view.center.x+100];
            [self.tableview reloadData];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"更换头像失败"] offset:self.view.center.x+100];
        }
    }
    
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

- (void)modifyHeadMenu {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex == 0) {
        [self openImagePickerControllerWith:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openImagePickerControllerWith:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}


- (void)openImagePickerControllerWith:(UIImagePickerControllerSourceType)type {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.view.backgroundColor = [UIColor whiteColor];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = type;
    imagePickerController.allowsEditing = YES;
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        [imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark –
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (info != nil) {
        [self performSelector:@selector(processImagePicker:) withObject:info afterDelay:0.1f];
    }
}

- (void)processImagePicker:(NSDictionary *)info {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(processImagePicker:) object:nil];
    
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headerImage = tempImage;
    NSData *data = UIImageJPEGRepresentation(tempImage, 0.5);
    //    NSString *imgStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//为什么没转换过来data中有非utf8的数据
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    
    NSString *imgExt = [NSString typeForImageData:data];//文件扩展名
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.clientid,@"client_id",
                         [data base64Encoding],@"avatar_data",
                         @".jpeg",@"avatar_ext",
                         nil];
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq clientAvatarRequestWithNumberIndex:kRequestNumberIndexClientAvatar delegte:self param:dic];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
