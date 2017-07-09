//
//  ViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/7.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ViewController.h"
#import "IUCallBackInterface.h"
#import "HRLogicManager.h"

#import "HRLLoginInterface.h"
#import "HRLPersonalCenterInterface.h"


#import "NSString+ImageExtName.h"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexMsgCode,
    kRequestNumberIndexLogin,
    kRequestNumberIndexVersion,//版本号
    
    kRequestNumberIndexClientInfo,
    kRequestNumberIndexCarColorList,
    
    kRequestNumberIndexEquityAccountBinding,//权益账户绑定
    kRequestNumberIndexEquityAccountList,//权益账户列表
    kRequestNumberIndexClientEdit,//个人资料编辑
    kRequestNumberIndexClientAvatar,//头像编辑
    
    kRequestNumberIndexPersonalAccount,//账户充值页面
    kRequestNumberIndexClientPatr,//账户余额交易记录
    
    kRequestNumberIndexFeedBack,//用户反馈
    kRequestNumberIndexCityList,//城市列表
    
    kRequestNumberIndexTcCard,//个人腾讯权益卡账号列表
    kRequestNumberIndexCheckTcCard,//支付页面计算腾讯权益卡的费用
};


@interface ViewController ()<IUICallbackInterface,UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *progressTimer;
    float duritionSecond;
    UIImageView *view ;
}

@property (nonatomic,weak) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) NSMutableDictionary *dataSourceDic;
@property (nonatomic,strong) NSArray *sortedArr;


//响铃按钮
@property (nonatomic, strong) UIButton      *ringBtn;
@property (nonatomic, strong) UIView        *animationBack;
@property (nonatomic, strong) UIImageView   *animationImageViews;
@property (nonatomic, strong) UILabel       *ringing;


@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (UIImage *)roundImageWithColor:(UIColor *)color andRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);//否则会有锯齿不清楚
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, 0.5);//线宽度
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.height/2, 0,2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)createImgView{
    view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.image = [self roundImageWithColor:[UIColor yellowColor] andRect:view.frame];
    view.alpha = 0.5;
}

- (UIImage *)imageWithColor:(UIColor *)color andRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);//否则会有锯齿不清楚
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, 0.5);//线宽度
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.height/4, 0,2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)ringBtnViewConfig
{
    self.ringBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ringBtn setTitle:NSLocalizedString(@"bell_find_bike", nil) forState:UIControlStateNormal];
    [_ringBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//88 92 100
    [_ringBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_ringBtn setBackgroundColor:[UIColor whiteColor]];//ff ff ff
    _ringBtn.layer.cornerRadius = 3.0f;
    _ringBtn.layer.borderWidth = 1.0f;
    _ringBtn.clipsToBounds = YES;
    _ringBtn.layer.borderColor = [[UIColor grayColor]CGColor];
//    _ringBtn.tag = ReservatTypeRing;
    [_ringBtn addTarget:self action:@selector(startRingBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ringBtn];
    
    
    self.animationBack = [[UIView alloc] initWithFrame:CGRectZero];
    [self.animationBack setBackgroundColor:[UIColor whiteColor]];//244 246 249
    
    NSArray *frames = @[[UIImage imageNamed:@"alarm_1"],
                        [UIImage imageNamed:@"alarm_2"],
                        [UIImage imageNamed:@"alarm_3"]];
    self.animationImageViews = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.animationImageViews.image = [UIImage imageNamed:@"alarm_1"];
    self.animationImageViews.animationImages = frames;
    self.animationImageViews.animationDuration = .4*frames.count;
    [self.animationImageViews sizeToFit];
    [self.animationBack addSubview:self.animationImageViews];
    
    _ringing = [[UILabel alloc] initWithFrame:CGRectZero];
    _ringing.textAlignment = NSTextAlignmentLeft;
    _ringing.baselineAdjustment = NSTextAlignmentCenter;
    _ringing.backgroundColor = [UIColor clearColor];
    _ringing.textColor = [UIColor blackColor];// 153 155 161
    _ringing.font = [UIFont systemFontOfSize:13];
    _ringing.text = NSLocalizedString(@"red_ring", nil);
    [self.animationBack addSubview:_ringing];
    [_ringing sizeToFit];
}

- (void)ringBtnSizeConfig:(CGRect)btnRectSize{
    self.ringBtn.frame = btnRectSize;
    self.animationBack.frame = self.ringBtn.bounds;
    
    //条件筛选按钮处
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.maximumLineHeight = btnRectSize.size.height;
    
    NSDictionary*attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle};//// 153 155 161
    
    //图片长宽
    CGSize sizeImg = CGSizeMake(14.0f, 14.0f);
    //文本长宽
    CGSize sizeBtnLbl =  [self.ringing.text boundingRectWithSize:btnRectSize.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    self.ringing.frame = CGRectMake(btnRectSize.size.width/2-sizeBtnLbl.width/2-3-7, btnRectSize.size.height/2-sizeBtnLbl.height/2, sizeBtnLbl.width, sizeBtnLbl.height);
    self.animationImageViews.frame = CGRectMake(self.ringing.frame.size.width+self.ringing.frame.origin.x+5, btnRectSize.size.height/2-sizeImg.height/2, sizeImg.width, sizeImg.height);
}



- (void)startRingBtn {
    [self.ringBtn addSubview:self.animationBack];
    [UIView animateWithDuration:.25 animations:^{
        self.animationBack.alpha = 1;
    } completion:^(BOOL finished) {
        [self.animationImageViews startAnimating];
        self.ringBtn.enabled = NO;
    }];
    [self performSelector:@selector(stopRingBtn) withObject:nil afterDelay:10];
}
- (void)stopRingBtn {
    self.ringBtn.enabled = YES;
    [UIView animateWithDuration:.25 animations:^{
        self.animationBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self.animationImageViews stopAnimating];
        [self.animationBack removeFromSuperview];
    }];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self requestMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - NetworkRequest
- (void)requestMethod
{
    
    
    
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
//    [personCenterReq clientInfoRequestWithNumberIndex:kRequestNumberIndexClientInfo delegte:self client_id:@"7296"];
//    [personCenterReq carColorListRequestWithNumberIndex:kRequestNumberIndexCarColorList delegte:self];
//    [personCenterReq equityAccountListRequestWithNumberIndex:kRequestNumberIndexEquityAccountList delegte:self bind_phone:@"18511833913"];
//    [personCenterReq equityAccountBindingRequestWithNumberIndex:kRequestNumberIndexEquityAccountBinding delegte:self card_no:@"TXQC19024700017" password:@"961630" bind_phone:@"18511833913"];
    

    //不用全部传也可以
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"7296",@"client_id",
//                         @"sun",@"cname",
//                         @"1",@"csex",//0.未知;1.男;2.女
//                         @"12345",@"carnum",//注意进行正则判断
////                         @"",@"caddr",//常驻城市id
////                         @"",@"brand",
////                         @"",@"color",//\U9999\U69df\U8272
//                         nil];
//    [personCenterReq clientEditRequestWithNumberIndex:kRequestNumberIndexClientEdit delegte:self param:dic];
    
    
//    UIImage *img = [UIImage imageNamed:@"maik"];
//    NSData *data = UIImageJPEGRepresentation(img, 0.5);
////    NSString *imgStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//为什么没转换过来data中有非utf8的数据
//    NSString *imgExt = [NSString typeForImageData:data];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"7296",@"client_id",
//                         [data base64Encoding],@"avatar_data",
//                         imgExt,@"avatar_ext",
//                         nil];
//    [personCenterReq clientAvatarRequestWithNumberIndex:kRequestNumberIndexClientAvatar delegte:self param:dic];
    

//    [personCenterReq feedBackRequestWithNumberIndex:kRequestNumberIndexFeedBack delegte:self client_id:@"7296" content:@"反馈啦啦啦啦啦啦啦啦啦"];
    
//    [personCenterReq cityListRequestWithNumberIndex:kRequestNumberIndexCityList delegte:self];
    
//    [personCenterReq tcCardRequestWithNumberIndex:kRequestNumberIndexTcCard delegte:self phone:@"18511833913"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"18511833913",@"phone",
                         @"",@"card_no",
                         @"7296",@"client_id",
                         @"",@"first_day_price",
                         @"",@"day_price",
                         @"",@"park_day",
                         @"",@"park_fee",
                         nil];
    [personCenterReq checkTcCardRequestWithNumberIndex:kRequestNumberIndexCheckTcCard delegte:self param:dic];
}

#pragma mark - TableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dataDic = [self.dataSourceDic objectForKey:@"rates"];
    NSString *key = [self.sortedArr objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%0.2f", [[dataDic objectForKey:key] doubleValue]];
    return cell;
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if(aRequestID ==  kRequestNumberIndexMsgCode){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]==200) {
            //获取验证码成功
            
        }
        else{
            //1.手机号格式错误;2.随机数格式错误;3.密钥错误;4.频繁请求;
        }
    }
    
    if (aRequestID == kRequestNumberIndexLogin) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue] ==200) {
            //登录成功
            //个人信息：data->client
            NSString *token = [(NSDictionary *)obj objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else{
            //1.手机号格式错误;2.短信验证码错误;3.短信验证码失效;4.缺少手机设备号参数;
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientInfo) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue] == 200) {
            //获取个人信息成功
            //个人信息：data
        }
        else{
            //1.缺少参数 client_id;2.该用户不存在;
        }
    }
    
    if (aRequestID == kRequestNumberIndexCarColorList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //获取车辆颜色列表成功
            //data
        }
    }
    
    if (aRequestID == kRequestNumberIndexEquityAccountList){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //权益账户列表获取
            //
        }else{
//            1.没有权益账户;200.成功。
        }
    }
    
    if (aRequestID == kRequestNumberIndexEquityAccountBinding){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //绑定权益账户
            //
        }else{
//            1.权益卡号不存在;2.权益卡号已经被绑定;3.权益卡号绑定失败;200.权益卡号绑定成 功
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientEdit) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //个人资料编辑成功
            
        }else{
//            1.缺少参数 client_id;200.保存成功。
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientAvatar) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //头像编辑成功
            
        }else{
            //
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexFeedBack) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //意见反馈
            //1.缺少参数 client_id;2.缺少参数 content;3.提交失败;
            
        }else{
            //
        }
    }
    
    
    
    if (aRequestID == kRequestNumberIndexTcCard) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //个人腾讯权益卡账号列表
            //1.缺少参数 phone;2.没有权益卡账号;
            
        }else{
            //
        }
    }
    
    if (aRequestID == kRequestNumberIndexCheckTcCard) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //支付页面-计算腾讯权益卡的费用
            //1.不存在或者已经失效;
            
        }else{
            //
        }
    }
    
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    NSLog(@"失败");
}


#pragma mark - PrivateMethods 
#pragma mark -- JSON convert
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark -- SORT
- (void)sortByAlphabet{
    NSArray *keysArray = [[self.dataSourceDic objectForKey:@"rates"] allKeys];
    self.sortedArr = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
}
//#pragma mark -- getter
//- (NSMutableDictionary *)dataSourceDic
//{
//    if (_dataSourceDic == nil) {
//        _dataSourceDic = [NSMutableDictionary dictionary];
//    }
//    return _dataSourceDic;
//}
@end
