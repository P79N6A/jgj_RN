//
//  JGJSureWithdrawViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSureWithdrawViewController.h"
#import "JGJAccountHeaderTableViewCell.h"
#import "JGJSalaryBackGroundTableViewCell.h"
#import "JGJSalaryTextFiledsTableViewCell.h"
#import "JGJSalaryPhoneNumTableViewCell.h"
#import "JGJGetPhoneVerfyTableViewCell.h"
#import "NSString+Extend.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JGJTaxrollTableViewCell.h"
#import "JGJTabBarViewController.h"

#define  AliPay_APPURL [NSURL URLWithString:@"alipay:"]

@interface JGJSureWithdrawViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
changeAccountDelegate,
getPhoneCodeDelegate,
salaryEditeDelegate
>

@property (nonatomic ,strong)UIView *tableviewsHeaderView;
@property (nonatomic ,strong)UIView *tableviewsFooterView;
@property (nonatomic ,assign)NSString *phoneCode;
@property (nonatomic ,assign)NSString *textCode;
@property (nonatomic ,strong)JGJTaxrollTableViewCell *Taxrollcell;
@end

@implementation JGJSureWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppFontf1f1f1Color;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView = self.tableviewsFooterView;
    self.title = @"余额提现";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    JGJAccountHeaderTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJAccountHeaderTableViewCell" owner:self options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = _AccountListModel;
        return cell;
    }else if (indexPath.row == 1){
        JGJSalaryBackGroundTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSalaryBackGroundTableViewCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.row == 2){
        JGJSalaryTextFiledsTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSalaryTextFiledsTableViewCell" owner:self options:nil]firstObject];
        cell.delegate = self;
        cell.model = _AccountListModel;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.row == 3)
    {
        _Taxrollcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTaxrollTableViewCell" owner:self options:nil]firstObject];
        _Taxrollcell.selectionStyle = UITableViewCellSelectionStyleNone;
        _Taxrollcell.model = _AccountListModel;

        return _Taxrollcell;
    
    
    }
    else if (indexPath.row == 4){
        JGJSalaryPhoneNumTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSalaryPhoneNumTableViewCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _AccountListModel;

        return cell;

    }else
    {
        JGJGetPhoneVerfyTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJGetPhoneVerfyTableViewCell" owner:self options:nil]firstObject];
        cell.model = _AccountListModel;

        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return  137.5;
            break;
        case 1:
            return  35;
  
            break;
        case 2:
            return  52;
            break;
        case 3:
            return 48;
            break;
        case 4:
            return  46;

            break;
        case 5:
            return  50;

            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableviewsFooterView
{
    if (!_tableviewsFooterView) {
        _tableviewsFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 100)];
        _tableviewsFooterView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, TYGetUIScreenWidth - 20, 50)];
        button.backgroundColor = AppFontEB4E4EColor;
        [button setTitle:@"确认提现" forState:UIControlStateNormal];
        button.layer.cornerRadius = JGJCornerRadius;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(clickSureAddAcount) forControlEvents:UIControlEventTouchUpInside];
        [_tableviewsFooterView addSubview:button];
    }
    return _tableviewsFooterView;
}

//确认提现按钮
-(void)clickSureAddAcount
{

    [self getEnableCash];
//    [JGJWeiXin_pay getCash:self.orderListModel];

}
-(JGJOrderListModel *)orderListModel
{
    if (!_orderListModel) {
        _orderListModel = [[JGJOrderListModel alloc]init];
    }
    return _orderListModel;
}

-(void)changeAccountFrom
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getphoneCode
{
    NSString *telephone = self.AccountListModel.telephone;
    
    if ([NSString isEmpty:telephone]) {
        
        telephone = [TYUserDefaults objectForKey:JLGPhone];
        
        return;
    }
    
    NSDictionary *parmDic = @{
                              @"telph":telephone,
                              @"type":@"3",
                              };
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/getvcode" parameters:parmDic success:^(id responseObject) {
        

         } failure:^(NSError *error) {
             [TYShowMessage showError:@"服务器错误"];
        }];
}
#pragma makr - 获取验证码
-(void)clickGetPhoneCodeButton
{
    [self getphoneCode];
    
}
//输入验证码
-(void)textfiledEdite:(NSString *)text
{
    self.orderListModel.vcode  = text;
    _textCode = text;
}


#pragma mark - 输入提现金额 有小数的哦
-(void)salaryEditeText:(NSString *)text
{

    self.orderListModel.amount = text;
    _Taxrollcell.moneyDeslable.text = [NSString stringWithFormat:@"%.2f", [text?:@"0" floatValue]*0.12];
    _Taxrollcell.MymoneyLable.text = [NSString stringWithFormat:@"%.2f", [text?:@"0" floatValue]*0.88];

    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
-(void)setAccountListModel:(JGJAccountListModel *)AccountListModel
{
    _AccountListModel = [[JGJAccountListModel alloc]init];
    
    _AccountListModel = AccountListModel;

    [_tableview reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.view endEditing:YES];
}
#pragma mark - 获取可提现金额
-(void)getEnableCash
{
    if ([NSString isEmpty: _orderListModel.vcode ]) {
        [TYShowMessage showError:@"请先输入验证码"];
        return;
    }
    if ([NSString isEmpty: _orderListModel.amount ]) {
        [TYShowMessage showError:@"请先输入提现金额"];
        return;
    }else if ([_orderListModel.amount floatValue] <= 0 )
    {
        [TYShowMessage showError:@"提现金额不能为0"];
        return;
        
        
    }
    typeof(self) weakself = self;

    NSDictionary *paramDic = @{
                               @"total_amount":self.orderListModel.amount?:@"0",
                               @"account_id":_AccountListModel.id?:@"",
                               @"vcode":_orderListModel.vcode?:@"",
                               @"pay_type":_AccountListModel.pay_type?:@"",
                             };
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithApi:@"v2/partner/getMoneyFromBalance" parameters:paramDic success:^(id responseObject) {
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        JGJTabBarViewController *vc = (JGJTabBarViewController *)weakself.navigationController.parentViewController;
        
        if ([vc isKindOfClass:[JGJTabBarViewController class]]) {
            
            vc.selectedIndex = 0;
        }
        [weakself.navigationController popToRootViewControllerAnimated:NO];
        [TYLoadingHub hideLoadingView];

    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        

    }];

}

@end
