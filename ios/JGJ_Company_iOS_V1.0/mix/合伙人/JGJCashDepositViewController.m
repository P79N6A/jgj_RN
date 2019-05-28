//
//  JGJCashDepositViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCashDepositViewController.h"
#import "JGJPayDeailTableViewCell.h"
#import "JGJCompanyDescriptionTableViewCell.h"
#import "UILabel+GNUtil.h"
#import "JGJWeiXin_pay.h"
#import "NSString+Extend.h"
#import "WXApi.h"
#import "JGJWebAllSubViewController.h"
@interface JGJCashDepositViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
choicePaytypeDelegate
>
@property (nonatomic ,strong)UIView *tableviewsFooterView;
@property (nonatomic ,strong)JGJOrderListModel *orderListModel;
@property (strong ,nonatomic)NSMutableArray <JGJMyRelationshipProModel *>*dataArr;

@end

@implementation JGJCashDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.title = @"缴纳保证金";
    _tableview.tableFooterView = self.tableviewsFooterView;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getAllProList];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JGJCompanyDescriptionTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJCompanyDescriptionTableViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else{
        JGJPayDeailTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPayDeailTableViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 115;
    }else if (indexPath.row == 1){
        if (![WXApi isWXAppInstalled]) {
            return 90;
        }
        return 148;
    }
    return 0;
}

- (UIView *)tableviewsFooterView
{
    if (!_tableviewsFooterView) {
        _tableviewsFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 162)];
        _tableviewsFooterView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 112, TYGetUIScreenWidth - 20, 50)];
        button.backgroundColor = AppFontEB4E4EColor;
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        button.layer.cornerRadius = JGJCornerRadius;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(clickAddAcount) forControlEvents:UIControlEventTouchUpInside];
        [_tableviewsFooterView addSubview:button];
        
        UILabel *Aginlable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)- 85, TYGetUIScreenWidth, 20)];
        Aginlable.font = [UIFont systemFontOfSize:13];
        Aginlable.textAlignment = NSTextAlignmentCenter;
        Aginlable.textColor = AppFont999999Color;
        //    _againLable.backgroundColor = [UIColor redColor];
        Aginlable.text = @"已同意《城市合伙人协议》";
        [_tableviewsFooterView addSubview:Aginlable];
        
#pragma mark- 点击事件
        Aginlable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickJumpPatainer)];
        
        [Aginlable addGestureRecognizer:userTap];
        
        [Aginlable markText:@"《城市合伙人协议》" withColor:AppFontEB4E4EColor];
        
        

        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 - 100, CGRectGetMaxY(button.frame)- 81, 13, 12)];
        imageview.image = [UIImage imageNamed:@"sel_pro_icon"];
        [_tableviewsFooterView addSubview:imageview];
    }
    return _tableviewsFooterView;
}
-(void)clickAddAcount
{

    if (!_orderListModel) {
        _orderListModel = [JGJOrderListModel new];
    }
    if ([NSString isEmpty:_orderListModel.pay_type]) {
        _orderListModel.pay_type = @"1";
    }
    
    [self payment];
//    [JGJWeiXin_pay GETNetPayidforAliPayorWeixinPay:_orderListModel];
}
-(void)choicePaytypeAndtype:(NSString *)type
{
    if (!_orderListModel) {
        _orderListModel = [JGJOrderListModel new];
    }
    _orderListModel.pay_type = type;
}
-(void)getAllProList
{
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"/pc/Project/getTeamList" parameters:nil success:^(id responseObject) {
        _dataArr = [JGJMyRelationshipProModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (int i = 0; i <_dataArr.count; i++) {
        if ([[_dataArr[i] is_default] isEqualToString:@"1"]) {
            _orderListModel = [JGJOrderListModel mj_objectWithKeyValues:_dataArr[i]];
         }
        }
        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

-(void)payment
{
[JGJWeiXin_pay doPayDesCashAndModel:_orderListModel andpayBlock:^(JGJOrderListModel *orderListModel) {
    
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    infoVer += 1;
    [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
    if (orderListModel.paySucees) {
        [TYShowMessage showSuccess:@"支付成功"];
    }
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[JGJWebAllSubViewController class]]) {
//            JGJWebAllSubViewController *allVC = (JGJWebAllSubViewController *)vc;
//            [allVC refreashH5];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
    
}];
    
}
-(void)clickJumpPatainer
{
    NSString *  webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"partner/agreement"];
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    [self.navigationController pushViewController:webVc animated:YES];
    
}
@end
