//
//  PopViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PopViewController.h"
#import "BAFCityInfo.h"
#import "BAFParkAir.h"
#import "PopFeeShowTableViewCell.h"
#import "BAFTcCardInfo.h"
#import "CityCollectionViewCell.h"

#define CityCollectionViewCellIdentifier  @"CityCollectionViewCellIdentifier"

@interface PopViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) PopViewControllerType    type;
@property (nonatomic, retain) UIView        *bgView;
@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic, retain) UIView        *headerView;
@property (nonatomic, retain) UILabel       *popTitleLabel;
@property (nonatomic, retain) UIButton      *cancelButton;
@property (nonatomic, retain) UIButton      *confirmButton;
@property (nonatomic, retain) UILabel       *detailLabel;
//时间选择
@property (nonatomic, retain) UIDatePicker  *datePicker;
@property (nonatomic, retain) NSMutableArray *arrDatasource;

@property (nonatomic, retain) UIScrollView *scrollView;



@property (strong, nonatomic) UICollectionView              *cityCollectionview;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForCityCollection;
@end


@implementation PopViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    self.arrDatasource = [NSMutableArray array];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupView
{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [self.headerView addSubview:self.popTitleLabel];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 43, screenWidth, 0.5)];
    lineV.backgroundColor = [UIColor colorWithHex:0xc9c9c9];
    [self.headerView addSubview:lineV];
    [self.popTitleLabel addSubview:self.cancelButton];
    [self.popTitleLabel addSubview:self.confirmButton];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.tableView];
    [self.bgView addSubview:self.scrollView];
    [self.scrollView addSubview:self.detailLabel];
    
    
    self.cityCollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutForCityCollection];
    _cityCollectionview.scrollEnabled = NO;
    _cityCollectionview.backgroundColor = [UIColor clearColor];
    [_cityCollectionview registerNib:[UINib nibWithNibName:@"CityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CityCollectionViewCellIdentifier];
    self.cityCollectionview.delegate = self;
    self.cityCollectionview.dataSource = self;
    [self.bgView addSubview:self.cityCollectionview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)configViewWithData:(NSArray *)arr type:(PopViewControllerType)type
{
    _type = type;
    self.arrDatasource = [NSMutableArray arrayWithArray:arr];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGFloat height;
    switch (type) {
        case kPopViewControllerTypeTop:
        {
//            self.bgView.frame = CGRectMake(0, 20, screenWidth, 350);
            height = 350;
            self.popTitleLabel.text = @"说明";
//            NSString *str = @"默认提供停车场与航站楼之间往返的免费摆渡车服务，客户自驾车至停车场停车，乘坐车场摆渡车前往航站楼；返程时，在航站楼乘坐摆渡车回到停车场取车。\n ● 什么是代驾代泊服务\n指客户自驾车到航站楼，在约定地点将车辆交付给伯安飞专业司机代驾到停车场停放妥当；返程时由伯安飞司机在客户约定时间将车辆从停车场送往航站楼交还给客户。\n● 什么是自行往返航站楼\n指客户自驾车至停车场停车，自行车前往航站楼；返程时，自行回到停车场取车。客户不需要乘坐伯安飞摆渡车，自行往返停车场与航站楼。";
            
            NSString *str = self.detailStr;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:kBAFFontSizeForDetailText]} range:[str rangeOfString:@"● 什么是代驾代泊服务"]];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:kBAFFontSizeForDetailText]} range:[str rangeOfString:@"● 什么是自行往返航站楼"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:7];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            self.detailLabel.attributedText = attributeStr;
            
            self.tableView.hidden = YES;
            self.scrollView.hidden = NO;
            self.confirmButton.hidden = YES;
            self.cityCollectionview.hidden = YES;
            
        }
            break;
        case kPopViewControllerTypeSelecCity:
        {
            
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            self.popTitleLabel.text = @"请选择城市";
            self.tableView.hidden = YES;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = NO;
        }
            break;
        case kPopViewControllerTypeSelecGoTerminal:
        case kPopViewControllerTypeSelecBackTerminal:
        {
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            if (type == kPopViewControllerTypeSelecGoTerminal) {
                self.popTitleLabel.text = @"请选择出发航站楼";
            }else{
               self.popTitleLabel.text = @"请选择返程航站楼";
            }

            self.tableView.hidden = NO;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeTipsshow:
        {
            height = 300;
            self.popTitleLabel.text = @"费用明细";
            self.confirmButton.hidden = YES;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeCompany:
        {
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            self.popTitleLabel.text = @"请选择同行人数";
            self.tableView.hidden = NO;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeSelecSex:
        {
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            self.popTitleLabel.text = @"请选择性别";
            self.tableView.hidden = NO;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeSelecColor:
        {
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            self.popTitleLabel.text = @"请选择车辆颜色";
            self.tableView.hidden = NO;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeGoTime:
        case kPopViewControllerTypeBackTime:
        {
            height = 260;
            self.popTitleLabel.text = @"请选择时间";
            [self.datePicker setFrame:CGRectMake(0, 44, screenWidth, 260-44)];
            [self.bgView addSubview:self.datePicker];
            self.tableView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        case kPopViewControllerTypeTcCard:
        {
            height = arr.count*50+44;
            if (height>320) {
                height = 320;
            }
            self.popTitleLabel.text = @"请选择权益账户";
            self.tableView.hidden = NO;
            self.scrollView.hidden = YES;
            self.cityCollectionview.hidden = YES;
        }
            break;
        default:
            break;
    }

    
    self.headerView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.popTitleLabel.frame = self.headerView.frame;
    self.cancelButton.frame = CGRectMake(CGRectGetWidth(self.popTitleLabel.frame)-64,0, 64, 44);
    self.confirmButton.frame = CGRectMake(0,0, 64, 44);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, height-CGRectGetHeight(self.headerView.frame));
     self.cityCollectionview.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, height-CGRectGetHeight(self.headerView.frame));
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    CGSize detailSize = [self.detailLabel.text boundingRectWithSize:CGSizeMake(screenWidth-20, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                          context:nil].size;
    self.detailLabel.frame = CGRectMake(20, 20, screenWidth-40,detailSize.height);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, height-CGRectGetHeight(self.headerView.frame));
    self.scrollView.contentSize = CGSizeMake(screenWidth-40, self.detailLabel.frame.size.height+40);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.frame = CGRectMake(0, screenHeight-height, screenWidth, height);
            } completion:^(BOOL finished) {
                [self.tableView reloadData];
            }];
        }];
    });
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type) {
        case kPopViewControllerTypeTop:
            return nil;
            break;
        case kPopViewControllerTypeSelecCity:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = ((BAFCityInfo *)[self.arrDatasource objectAtIndex:indexPath.row]).title;
            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        case kPopViewControllerTypeSelecGoTerminal:
        case kPopViewControllerTypeSelecBackTerminal:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = ((BAFParkAir *)[self.arrDatasource objectAtIndex:indexPath.row]).title;

            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        case kPopViewControllerTypeCompany:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
//            cell.textLabel.text = [self.arrDatasource objectAtIndex:indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = [NSString stringWithFormat:@"%@人",[self.arrDatasource objectAtIndex:indexPath.row]];
            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        case kPopViewControllerTypeSelecColor:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = [self.arrDatasource objectAtIndex:indexPath.row];
            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        case kPopViewControllerTypeSelecSex:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = [self.arrDatasource objectAtIndex:indexPath.row];
            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        case kPopViewControllerTypeTipsshow:
        {
            static NSString *PopFeeShowTableViewCellIdentifier = @"PopFeeShowTableViewCell";
            PopFeeShowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:PopFeeShowTableViewCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PopFeeShowTableViewCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            NSArray *arr = [self.arrDatasource objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                cell.topLine.hidden = YES;
                cell.bottomLine.hidden = NO;
                cell.popfeetitleLabel.textColor = [UIColor colorWithHex:0x323232];
            }else{
                if ([arr containsObject:@"支付方式"]||[arr containsObject:@"应支付"]) {
                    cell.topLine.hidden = NO;
                    cell.bottomLine.hidden = NO;
                    cell.popfeetitleLabel.textColor = [UIColor colorWithHex:0x323232];
                    cell.popfeeMoneyLabel.textColor = [UIColor colorWithHex:0xfb694b];
                }else if ([arr containsObject:@"vip抵扣"]
                          ||[arr containsObject:@"现金支付"]
                          ||[arr containsObject:@"微信支付"]
                          ||[arr containsObject:@"支付宝支付"]
                          ||[arr containsObject:@"个人账户支付"]
                          ||[arr containsObject:@"集团账户支付"]
                          ||[arr containsObject:@"优惠码"]
                          ||[arr containsObject:@"权益账户"]                        
                          ){
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    cell.popfeetitleLabel.textColor = [UIColor colorWithHex:0x969696];
                    cell.popfeeMoneyLabel.textColor = [UIColor colorWithHex:0xfb694b];
                }else{
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    cell.popfeetitleLabel.textColor = [UIColor colorWithHex:0x969696];
                    cell.popfeeMoneyLabel.textColor = [UIColor colorWithHex:0x323232];
                }
            }
            
            cell.popfeetitleLabel.text = arr[0];
            cell.popfeeMoneyLabel.text = arr[1];
            return cell;
        }
            break;
        case kPopViewControllerTypeTcCard:
        {
            static NSString *CellIdentifier = @"commonTableViewCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
            cell.textLabel.text = ((BAFTcCardInfo *)[self.arrDatasource objectAtIndex:indexPath.row]).type_name;
            
            if (self.selectedIndex == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == kPopViewControllerTypeTipsshow) {
        return 34;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.type != kPopViewControllerTypeTipsshow) {
        if ((indexPath.row != self.selectedIndex.row)||!self.selectedIndex) {
            NSIndexPath *oldIndex = self.selectedIndex;
            self.selectedIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndex, oldIndex, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - pravitemethods
- (NSDate *)dateAfterMonths:(NSDate *)currentDate gapMonth:(NSInteger)gapMonthCount {
    //获取当年的月份，当月的总天数
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:currentDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSString *dateStr = @"";
    NSInteger endDay = 0;//天
    NSDate *newDate = [NSDate date];//新的年&月
    //判断是否是下一年
    if (components.month+gapMonthCount > 12) {
        //是下一年
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01",components.year+(components.month+gapMonthCount)/12,(components.month+gapMonthCount)%12];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([self isEndOfTheMonth:currentDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year+(components.month+gapMonthCount)/12,(components.month+gapMonthCount)%12,endDay];
    } else {
        //依然是当前年份
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01",components.year,components.month+gapMonthCount];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([self isEndOfTheMonth:currentDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year,components.month+gapMonthCount,endDay];
    }
    
    newDate = [formatter dateFromString:dateStr];
    return newDate;
}

//判断是否是月末
- (BOOL)isEndOfTheMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger daysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents *componets = [calendar components:NSCalendarUnitDay fromDate:date];
    if (componets.day >= daysInMonth) {
        return YES;
    }
    return NO;
}
#pragma mark - actions
- (void)confirmAction
{
    switch (self.type) {
        case kPopViewControllerTypeGoTime:
        case kPopViewControllerTypeBackTime:
        {
            self.selectedDate = self.datePicker.date;
        }
            break;
        case kPopViewControllerTypeSelecCity:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择城市" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        case kPopViewControllerTypeSelecGoTerminal:
        case kPopViewControllerTypeSelecBackTerminal:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择停车场" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        case kPopViewControllerTypeCompany:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择同行人数" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        case kPopViewControllerTypeSelecSex:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择性别" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        case kPopViewControllerTypeSelecColor:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择车辆颜色" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        case kPopViewControllerTypeTcCard:
        {
            if (!self.selectedIndex) {
                CSToastStyle *toastStyle = [CSToastManager sharedStyle];
                [[UIApplication sharedApplication].keyWindow makeToast:@"还未选择权益账户" duration:2.5 position:@(100) style:toastStyle];
                return;
            }
        }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(popviewConfirmButtonDidClickedWithType:popview:)]) {
        [self.delegate popviewConfirmButtonDidClickedWithType:self.type popview:self];
    }
    [self dismiss];
    
}

- (void)dismissSelf
{
    if ([self.delegate respondsToSelector:@selector(popviewDismissButtonDidClickedWithType:popview:)]) {
        [self.delegate popviewDismissButtonDidClickedWithType:self.type popview:self];
    }
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = CGRectMake(0, screenHeight, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            UINavigationController* navi = self.navigationController;
            if([navi isKindOfClass:[UINavigationController class]]){
                [navi popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.view)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)datePickerDateChanged:(UIDatePicker *)paramDatePicker {
    if ([paramDatePicker isEqual:self.datePicker]) {
        NSLog(@"Selected date = %@", _datePicker.date);
    }
}

#pragma mark - collectiondelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.type == kPopViewControllerTypeSelecCity) {
        return 1;
    }
    return 0;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.type == kPopViewControllerTypeSelecCity) {
        return self.arrDatasource.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == kPopViewControllerTypeSelecCity) {
        CityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CityCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.cityLabel.text = ((BAFCityInfo *)[self.arrDatasource objectAtIndex:indexPath.row]).title;
        cell.cityLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.cityLabel.textAlignment = NSTextAlignmentCenter;//文字居中
        if (self.selectedIndex == indexPath) {
            [cell setCityCollectionSelected:YES];
        }else{
            [cell setCityCollectionSelected:NO];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityCollectionViewCell *cell = (CityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCityCollectionSelected:YES];
    self.selectedIndex = indexPath;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityCollectionViewCell *cell = (CityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCityCollectionSelected:NO];
}


#pragma mark - setter&getter
- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 0)];
        _bgView.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return _bgView;
}

- (UIView*)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithHex:0xffffff];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
//        _tableView.separatorColor = [UIColor colorWithHex:0xc9c9c9];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    }
    return _tableView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"确认" forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [_cancelButton setTitleColor:HexRGB(kBAFCommonColor) forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor colorWithHex:0xffffff]];
        [_cancelButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"取消" forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [_confirmButton setTitleColor:HexRGB(kBAFCommonColor) forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor colorWithHex:0xffffff]];
        [_confirmButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UILabel *)popTitleLabel
{
    if (!_popTitleLabel) {
        _popTitleLabel = [[UILabel alloc] init];
        _popTitleLabel.userInteractionEnabled = YES;
        _popTitleLabel.backgroundColor = [UIColor clearColor];
        _popTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _popTitleLabel.numberOfLines = 1;
        _popTitleLabel.textAlignment = NSTextAlignmentCenter;
        _popTitleLabel.textColor = HexRGB(kBAFColorForTitle);
        _popTitleLabel.font = [UIFont systemFontOfSize:kBAFFontSizeForTitle];
    }
    return _popTitleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = [UIColor colorWithHex:0x969696];
        _detailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _detailLabel;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.center = self.view.center;
        [_datePicker addTarget:self
                              action:@selector(datePickerDateChanged:)
                    forControlEvents:UIControlEventValueChanged];
//        NSDate *todayDate = [[NSDate date] dateByAddingTimeInterval:2*60*60];
        NSDate *todayDate = [[NSDate date] dateByAddingTimeInterval:0];
        NSTimeInterval interval = [todayDate timeIntervalSince1970];
        interval = (15*60)-(int)(interval)%(15*60) + floor(interval);
        todayDate = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDate *threeMonthsFromToday = [self dateAfterMonths:todayDate gapMonth:3];
        _datePicker.minimumDate = todayDate;
        _datePicker.maximumDate = threeMonthsFromToday;
        _datePicker.minuteInterval = 15;
    }
    return _datePicker;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UICollectionViewFlowLayout *)layoutForCityCollection
{
    if (!_layoutForCityCollection) {
        CGFloat itemTotolWidth = screenWidth-30-30;
        CGFloat itemWidth = itemTotolWidth/3.0f;
        CGFloat itemHeight  = 40.0f;
        _layoutForCityCollection = [[UICollectionViewFlowLayout alloc] init];
        _layoutForCityCollection.minimumLineSpacing = 18;
        _layoutForCityCollection.minimumInteritemSpacing = 15;
        _layoutForCityCollection.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForCityCollection.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutForCityCollection;
}
@end
