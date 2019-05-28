//
//  JGJOrderDetailViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOrderDetailViewController.h"
#import "JGJOrderDetailView.h"
#import "JGJOrderCopyTableViewCell.h"
#import "JGJOrderNormalTableViewCell.h"
#import "JGJOrderMainTableViewCell.h"
#import "JGJPayDeailTableViewCell.h"
#import "JGJWarnPeopleTableViewCell.h"
#import "JGJSurePayTableViewCell.h"
#import "JGJSurePayView.h"
#import "JGJOrderDetailViewController.h"
#import "JGJHadPayTableViewCell.h"
#import "JGJServiceOrderDetaiProTableViewCell.h"
#import "JGJPaySuccesViewController.h"
@interface JGJOrderDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickSurePayButtondelegate,
choicePaytypeDelegate
>
@property(nonatomic ,strong)JGJOrderDetailView *hederView;
@property(nonatomic ,strong)JGJSurePayView *surePayView;
@property(nonatomic ,strong)UILabel *waringView;

@property(nonatomic ,strong)NSMutableArray *VipArr;
@property(nonatomic ,strong)NSMutableArray *dataArr;
@property(nonatomic ,strong)JGJMyRelationshipProModel *RelationshipProModel;



@end

@implementation JGJOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (![self.orderListModel.order_status isEqualToString:@"1"]) {//1是为支付 2是支付完成
    }else{
        [self.view addSubview:self.waringView];
//        _bottomConstance.constant = 0;

    }
    [self.view addSubview:self.surePayView];

    self.view.backgroundColor = AppFontf1f1f1Color;
    _tableview.backgroundColor = AppFontf1f1f1Color;
}
-(NSMutableArray *)VipArr
{
    if (!_VipArr) {
        _VipArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"服务时长",@"服务人数",@"云盘空间",@"支付方式",@"订购时间",@"订单编号", nil];
    }
    return _VipArr;
}
-(UILabel *)waringView
{
    if (!_waringView) {
        _waringView = [[UILabel alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 132 - 35, TYGetUIScreenWidth, 35)];
        _waringView.backgroundColor = AppFontfdf1e0Color;
        _waringView.text = @"    注：如23小时50分钟内未支付，该订单将会自动删除";
        _waringView.textColor = AppFonttITLEF18215;
        _waringView.font = [UIFont systemFontOfSize:13];
    }
    return _waringView;
}
- (JGJOrderDetailView *)hederView
{
    if (!_hederView) {
        _hederView = [[JGJOrderDetailView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 120)];
    }
    return _hederView;
}
- (JGJSurePayView *)surePayView
{
    if (!_surePayView) {
        _surePayView = [[JGJSurePayView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 132, TYGetUIScreenWidth, 70)];
        _surePayView.backgroundColor = [UIColor whiteColor];
        _surePayView.delegate = self;
        _surePayView.orderDetail = YES;
    }
    return _surePayView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGJOrderMainTableViewCell *NormalCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJOrderMainTableViewCell" owner:nil options:nil]firstObject];
            NormalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_orderListModel.order_type isEqualToString:@"1"] || [_orderListModel.order_type isEqualToString:@"2"]){
               
                NormalCell.VipGoods = YES;
            }else if ([_orderListModel.order_type isEqualToString:@"3"] || [_orderListModel.order_type isEqualToString:@"4"])
            {
                NormalCell.VipGoods = NO;
            }
            NormalCell.orderListModel = _orderListModel;
            return NormalCell;
        }else if (indexPath.row == 1)
        {
            JGJServiceOrderDetaiProTableViewCell *NormalCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJServiceOrderDetaiProTableViewCell" owner:nil options:nil]firstObject];
            NormalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NormalCell.orderListModel = _orderListModel;
            return NormalCell;

        }
        else if (indexPath.row < 7) {
            JGJOrderNormalTableViewCell *NormalCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJOrderNormalTableViewCell" owner:nil options:nil]firstObject];
            NormalCell.serviceTimeLable.text = self.VipArr[indexPath.row];
            switch (indexPath.row) {
                case 2:
                    NormalCell.detailLable.text = [self.orderListModel.service_time stringByAppendingString:@""];
                    break;
                case 3:
                    
                    if ([_orderListModel.order_type isEqualToString:@"3" ] || [_orderListModel.order_type isEqualToString:@"4" ]) {
                        
//                    if (![NSString isEmpty: _RelationshipProModel.buyer_person]&& ![NSString isEmpty:_RelationshipProModel.service_lave_days]) {
//                        if ([_RelationshipProModel.buyer_person intValue] <= 0 && [_RelationshipProModel.service_lave_days intValue]<=0) {
                            NormalCell.detailLable.hidden = YES;
                            NormalCell.serviceTimeLable.hidden = YES;

//                        }
//                    }
                    }
                    NormalCell.detailLable.text = [self.orderListModel.server_counts stringByAppendingString:@"人"];
                    break;
                case 4:
                    NormalCell.detailLable.text = [self.orderListModel.cloud_space stringByAppendingString:@"G"];
                    break;
                case 5://支付方式
                    if ([self.orderListModel.pay_type isEqualToString:@"1"]) {
                        NormalCell.detailLable.text = @"微信支付";
 
                    }else{
                        NormalCell.detailLable.text = @"支付宝支付";

                    }
                    break;
                case 6:
                    NormalCell.detailLable.text = self.orderListModel.create_time;
                    break;
                default:
                    break;
            }
            NormalCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NormalCell.orderListModel = _orderListModel;

            return NormalCell;
        }else{
            JGJOrderCopyTableViewCell *CopyNCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJOrderCopyTableViewCell" owner:nil options:nil]firstObject];
            CopyNCell.selectionStyle = UITableViewCellSelectionStyleNone;
            CopyNCell.orderListModel = _orderListModel;
            return CopyNCell;
        }
    }else{
        if (indexPath.row == 0) {
            if ([_orderListModel.order_status isEqualToString:@"2"]) {
                JGJHadPayTableViewCell *PayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHadPayTableViewCell" owner:nil options:nil]firstObject];
                PayCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return PayCell;
            }
            JGJPayDeailTableViewCell *PayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPayDeailTableViewCell" owner:nil options:nil]firstObject];
//            PayCell.orderListModel = _orderListModel;
            PayCell.delegate = self;
            PayCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return PayCell;
 
        }else if (indexPath.row == 1){
        if ([_orderListModel.order_status isEqualToString:@"2"]) {
                JGJHadPayTableViewCell *PayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHadPayTableViewCell" owner:nil options:nil]firstObject];
                PayCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return PayCell;
            }
            JGJWarnPeopleTableViewCell *WarnCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWarnPeopleTableViewCell" owner:nil options:nil]firstObject];
            WarnCell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            return WarnCell;
            
        }else{
            JGJSurePayTableViewCell *SurePayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSurePayTableViewCell" owner:nil options:nil]firstObject];
            SurePayCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return SurePayCell;
        
        }
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }else{
    
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 110;
        }else
        if (indexPath.row == 1) {
            return 64;
        }else if(indexPath.row == 3){
#pragma mark - 这里隐藏人数
            if ([_orderListModel.order_type isEqualToString:@"3" ] || [_orderListModel.order_type isEqualToString:@"4" ]) {
                
                
//                if (![NSString isEmpty: _RelationshipProModel.buyer_person]&& ![NSString isEmpty:_RelationshipProModel.service_lave_days]) {
//                    if ([_RelationshipProModel.buyer_person intValue] <= 0 && [_RelationshipProModel.service_lave_days intValue] <=0) {
                        return 0;
//                      }
//                }
            }
            return 50;
        }else{
            return 50;
        }
    }else{
        if (indexPath.row == 0) {
            if ([_orderListModel.order_status isEqualToString:@"2"]) {
                return 0;
            }
            if (![WXApi isWXAppInstalled]) {
                return 90;
            }
            return 148;
        }else if (indexPath.row == 1){
            if ([_orderListModel.order_status isEqualToString:@"2"]) {
                return 0;
            }

            return 35;
        }else{

            return 70;
        }
        return 0;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
        lable.backgroundColor = AppFontf1f1f1Color;
        lable.text = @"  支付方式";
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = AppFont999999Color;
        return lable;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_orderListModel.order_status isEqualToString:@"2"]) {
        return 0;
    }
    if (section == 0) {
        return 0;
    }
    return 30;
}
#pragma mark - 点击支付按钮
- (void)clickSurePayButton
{
//微信支付或者阿里云支付
    [JGJWeiXin_pay GETNetPayidforAliPayorWeixinPay:self.orderListModel andpayBlock:^(JGJOrderListModel *orderListModel) {
        if (orderListModel.paySucees) {
            JGJPaySuccesViewController *payOrderVC = [[UIStoryboard storyboardWithName:@"JGJPaySuccesViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPaySuccesVC"];
            payOrderVC.trade_no = orderListModel.trade_no;
            [self.navigationController pushViewController:payOrderVC animated:YES];
        }
    }];
}
-(void)choicePaytypeAndtype:(NSString *)type
{
    _orderListModel.pay_type = type;
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _orderListModel = orderListModel;
    self.surePayView.orderListModel = orderListModel;
    [self.surePayView setPriVteNum:orderListModel.produce_info.discount_amount?:@"0.00" andSalary:orderListModel.amount?:@"0.00"];
    [self getAllProList];
    [_tableview reloadData];
}
-(void)setTrade_no:(NSString *)trade_no
{
    if (!_orderListModel) {
        _orderListModel = [JGJOrderListModel new];
    }
    [self lookFortrad_nowithID:trade_no];
}
-(void)lookFortrad_nowithID:(NSString *)trade_no
{
    NSDictionary *dic = @{
                            @"order_id":@"",
                            @"order_sn":trade_no?:@"",
                          };
[JLGHttpRequest_AFN PostWithApi:@"v2/order/getOrderInfo" parameters:dic success:^(id responseObject) {
    _orderListModel = [JGJOrderListModel mj_objectWithKeyValues:responseObject];
    [self.surePayView setPriVteNum:_orderListModel.discount_amout?:@"0" andSalary:_orderListModel.amount];
    self.surePayView.surePayButton.hidden = YES;

    [_tableview reloadData];

}];

}
#pragma mark - 苹果支付
-(void)applePay
{


}
//获取项目列表
-(void)getAllProList
{
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"/pc/Project/getTeamList" parameters:nil success:^(id responseObject) {
        _dataArr = [JGJMyRelationshipProModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (int i = 0; i <_dataArr.count; i++) {
                if ([[_dataArr[i] group_id] isEqualToString:_orderListModel.group_id]) {
                    _RelationshipProModel = _dataArr[i];
                }
        }
        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

@end
