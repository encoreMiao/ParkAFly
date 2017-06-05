//
//  PopViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UIView        *bgView;
@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic, retain) UIView        *headerView;
@property (nonatomic, retain) UILabel       *popTitleLabel;
@property (nonatomic, retain) UIButton      *cancelButton;

@property (nonatomic, retain) UILabel       *detailLabel;
@end

@implementation PopViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, screenWidth, 0.5)];
    lineV.backgroundColor = [UIColor grayColor];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [self.view addSubview:self.bgView];
    [self.headerView addSubview:self.popTitleLabel];
    [self.popTitleLabel addSubview:self.cancelButton];
    
    [self.headerView addSubview:lineV];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.tableView];
    [self.bgView addSubview:self.detailLabel];
}

- (void)configViewWithData:(NSArray *)arr type:(PopViewControllerType)type
{
    

    switch (type) {
        case kPopViewControllerTypeTop:
        {
            self.bgView.frame = CGRectMake(0, 20, screenWidth, 350);
            self.popTitleLabel.text = @"服务说明";
            NSString *str = @"默认提供停车场与航站楼之间往返的免费摆渡车服务，客户自驾车至停车场停车，乘坐车场摆渡车前往航站楼；返程时，在航站楼乘坐摆渡车回到停车场取车。\n ● 什么是代驾代泊服务\n指客户自驾车到航站楼，在约定地点将车辆交付给伯安飞专业司机代驾到停车场停放妥当；返程时由伯安飞司机在客户约定时间将车辆从停车场送往航站楼交还给客户。\n● 什么是自行往返航站楼\n指客户自驾车至停车场停车，自行车前往航站楼；返程时，自行回到停车场取车。客户不需要乘坐伯安飞摆渡车，自行往返停车场与航站楼。";
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xf05b48],NSFontAttributeName:[UIFont systemFontOfSize:kBAFFontSizeForDetailText]} range:[str rangeOfString:@"● 什么是代驾代泊服务"]];
            [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xf05b48],NSFontAttributeName:[UIFont systemFontOfSize:kBAFFontSizeForDetailText]} range:[str rangeOfString:@"● 什么是自行往返航站楼"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            self.detailLabel.attributedText = attributeStr;
            
            self.tableView.hidden = YES;
            self.detailLabel.hidden = NO;
            
        }
            break;
        case kPopViewControllerTypeSelec:
        {
            self.bgView.frame = CGRectMake(0, screenHeight-300, screenWidth, 300);
            self.popTitleLabel.text = @"请选择航站楼";
        }
            break;
        case kPopViewControllerTypeTipsshow:
        {
            self.bgView.frame = CGRectMake(0, screenHeight-300, screenWidth, 300);
            self.popTitleLabel.text = @"费用明细";
        }
            break;
        case kPopViewControllerTypCompany:
        {
            self.bgView.frame = CGRectMake(0, screenHeight-300, screenWidth, 300);
            self.popTitleLabel.text = @"请选择通行人数";
        }
            break;
        default:
            break;
    }
    
    
    
    
    
    self.headerView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.popTitleLabel.frame = self.headerView.frame;
    self.cancelButton.frame = CGRectMake(CGRectGetWidth(self.popTitleLabel.frame)-64,0, 44, 44);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, CGRectGetHeight(self.bgView.frame)-CGRectGetHeight(self.headerView.frame));
    self.detailLabel.frame = CGRectMake(10, CGRectGetMaxY(self.headerView.frame), screenWidth-20, CGRectGetHeight(self.bgView.frame)-CGRectGetHeight(self.headerView.frame));
}

#pragma mark - privatemethods
- (void)dismiss
{
    UINavigationController* navi = self.navigationController;
    if([navi isKindOfClass:[UINavigationController class]]){
        [navi popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

#pragma mark - tableviewdelegate&datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"";
    return nil;
}

#pragma mark - setter&getter
- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
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
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor clearColor]];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
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
        _detailLabel.textColor = HexRGB(kBAFColorForTitle);
        _detailLabel.font = [UIFont systemFontOfSize:kBAFFontSizeForDetailText];
    }
    return _detailLabel;
}

@end
