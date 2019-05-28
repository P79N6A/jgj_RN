//
//  JGJSureOrderListViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSureOrderListViewController.h"
#import "JGJServiceProNTableViewCell.h"
#import "JGJSerViceTimeTableViewCell.h"
#import "JGJOrderMainTableViewCell.h"
#import "JGJServicePeopleNumTableViewCell.h"
#import "JGJPayDeailTableViewCell.h"
#import "WXApi.h"
#import "JGJChoicePeoViewController.h"

//#import "JGJWorkTypeCollectionView.h"

#import "JGJSelctServerTimeview.h"


#import "NSString+Extend.h"
#import "UIImageView+WebCache.h"
#import "JGJHadPayTableViewCell.h"
#import "FDAlertView.h"
#import "JGJPaySuccesViewController.h"
#import "JGJpaySectionTableViewCell.h"
#import "JGJWeiXin_pay.h"
#import <StoreKit/StoreKit.h>
@interface JGJSureOrderListViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickSurePayButtondelegate,
choicePaytypeDelegate,
selectGoodsNumdelegate,
FDAlertViewDelegate
//SKPaymentTransactionObserver,//苹果支付协议
//SKProductsRequestDelegate//苹果支付协议
>
{
    FDAlertView *alert;
}
@property (nonatomic ,strong)JGJSurePayView *surePayView;
@property (nonatomic ,strong)JGJSureOrderListModel *sureOrderListModel;
@property (strong ,nonatomic)NSMutableArray <JGJMyRelationshipProModel *>*dataArr;
@property (strong ,nonatomic)JGJMyRelationshipProModel *defaultRelationshipProModel;
@property (strong ,nonatomic)JGJOrderListModel *GoodsOrderModel;
@property (strong ,nonatomic)NSString *groupId;
@property (assign ,nonatomic)BOOL upgrade;
@property (nonatomic ,strong)JGJServicePeopleNumTableViewCell *Cloudcell;

@end

@implementation JGJSureOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
#pragma mark - 苹果支付
    //    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //    [self getRequestAppleProduct];
}
-(void)initView
{
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.surePayView];
    //    [self.surePayView closeSurePayButtonUserinterface];
    self.title = @"确认订单";
    [TYNotificationCenter addObserver:self selector:@selector(pushPaySuccesVC:) name:JGJWeixinPayNitification object:nil];
    [self getGoodsDtail];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)pushPaySuccesVC:(NSNotification *)obj
{
    
    JGJPaySuccesViewController *payOrderVC = [[UIStoryboard storyboardWithName:@"JGJPaySuccesViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPaySuccesVC"];
    //    payOrderVC.trade_no = orderListModel.trade_no;
    [self.navigationController pushViewController:payOrderVC animated:YES];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JGJOrderMainTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJOrderMainTableViewCell" owner:nil options:nil]firstObject];
        if (_GoodsType == VipListType) {
            cell.VipGoods = YES;
        }else{
            cell.VipGoods = NO;
            
        }
        cell.orderModel = _orderListModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 1){
        JGJServiceProNTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJServiceProNTableViewCell" owner:nil options:nil]firstObject];
        cell.MyRelationshipProModel = _defaultRelationshipProModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.row == 2){
        
        JGJSerViceTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJSerViceTimeTableViewCell" owner:nil options:nil]firstObject];
        if (_GoodsType == VIPServiceType) {
            cell.desLable.hidden = YES;
            cell.deaTimeLable.font = [UIFont systemFontOfSize:15];
        }else{
            cell.deaTimeLable.font = [UIFont systemFontOfSize:15];

            cell.desLable.hidden = [self getIsHiddendDeslable];
            if (!cell.desLable.hidden) {
                cell.desLable.text = [self cloudContinueDetail];
            }
        }
        cell.orderListModel = _orderListModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 3){
        if (_GoodsType == CloudNumType) {
            JGJHadPayTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHadPayTableViewCell" owner:nil options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        JGJServicePeopleNumTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJServicePeopleNumTableViewCell" owner:nil options:nil]firstObject];
        if (_GoodsType == CloudNumType) {
            cell.BuyCloud = YES;
        }else{
            cell.BuyCloud = NO;
            
        }
        cell.goodsType = VIPType;
        cell.delegate = self;
        cell.orderListModel = _orderListModel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 4){
        _Cloudcell = [[[NSBundle mainBundle]loadNibNamed:@"JGJServicePeopleNumTableViewCell" owner:nil options:nil]firstObject];
        
        if (_GoodsType == CloudNumType) {
            _Cloudcell.BuyCloud = YES;
        }else{
            _Cloudcell.BuyCloud = NO;
        }
        _Cloudcell.tag = 10;
        _Cloudcell.delegate = self;
        _Cloudcell.goodsType = CloudType;
        _Cloudcell.departLable.hidden = YES;
        _Cloudcell.orderListModel = _orderListModel;
        _Cloudcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _Cloudcell;
    }else if (indexPath.row == 5)
    {
        JGJpaySectionTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJpaySectionTableViewCell" owner:nil options:nil]firstObject];
        return cell;
    }
    
    else{
        JGJPayDeailTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPayDeailTableViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 110;
    }else if (indexPath.row == 1){
        return 55;
    }else if (indexPath.row == 2){
        if (_GoodsType == CloudNumType &&  ![self getIsHiddendDeslable]) {
            return 118;
        }
        return 82;
        
    }else if (indexPath.row == 3){
        if (_GoodsType == CloudNumType) {
            return 0;
        }
        return 90;
        
    }else if (indexPath.row == 4){
        return 84;
    }else if (indexPath.row == 5){
        return 30;
    }
    else{
        if (![WXApi isWXAppInstalled]) {
            return 90;
        }
        return 148;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        JGJChoicePeoViewController *ChoicePeoViewController = [[UIStoryboard storyboardWithName:@"JGJChoicePeoViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChoicePeoVC"];
        ChoicePeoViewController.MyRelationshipProModel= _defaultRelationshipProModel;
        ChoicePeoViewController.groupListArr = _dataArr;
        [self.navigationController pushViewController:ChoicePeoViewController animated:YES];
    }else if (indexPath.row == 2){
        [self showManHourPicker];
    }
}

- (JGJSurePayView *)surePayView
{
    if (!_surePayView) {
        _surePayView = [[JGJSurePayView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 132, TYGetUIScreenWidth, 70)];
        _surePayView.backgroundColor = [UIColor whiteColor];
        _surePayView.delegate = self;
    }
    return _surePayView;
}
-(void)clickSurePayButton
{
    //    if (_GoodsType == CloudNumType) {
    //        if ([_orderListModel.add_cloudplace?:@"" intValue] <= 0) {
    //            alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"该订单无需支付，你确定要提交该订单吗？" delegate:self buttonTitles:@"取消",@"确认订单", nil];
    //            [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    //            alert.tag = 102;
    //            [alert show];
    //            return;
    //        }
    //    }
    
    if (([_orderListModel.add_people?:@"0" intValue]<[_orderListModel.buyer_person?:@"" intValue] || [_orderListModel.add_cloudplace?:@"0" intValue]<[_orderListModel.cloud_space?:@"" intValue]) && _GoodsType == VIPServiceType) {
        
        NSString *payStr;
        if ([_surePayView.surePayButton.titleLabel.text isEqualToString:@"确认订单"]) {
            payStr = @"确认订单";
        }else{
            payStr = @"继续支付";

        }
        alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"你正在减少服务人数或云盘空间，请谨慎操作" delegate:self buttonTitles:@"我再想想",payStr, nil];
        //        alert.tag = 100;
        [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
        [alert show];
    }else{
        [self goPay];
    }
}
#pragma mark - 进行支付
-(void)goPay{
    if (_GoodsType == CloudNumType) {
        
        _orderListModel.goodsType = CloudListType;
        _orderListModel.server_id = @"2";
    }else{
        _orderListModel.goodsType = VipListType;
        _orderListModel.server_id = @"1";
    }
    _orderListModel.clickPay = YES;
    //总价
    _orderListModel.total_amount = [self getImputedprice];
    
    __weak typeof(self) weakSelf = self;
    if ([_orderListModel.total_amount floatValue] > 0) {
        [JGJWeiXin_pay GETNetPayidforAliPayorWeixinPay:_orderListModel andpayBlock:^(JGJOrderListModel *orderListModel) {
            
            //购买成功之后回调消息成功@(YES),失败@(NO)或者不回掉
            
            if (weakSelf.notifyServiceSuccessBlock) {
                
                weakSelf.notifyServiceSuccessBlock(orderListModel);
            }
            if (orderListModel.paySucees) {
                JGJPaySuccesViewController *payOrderVC = [[UIStoryboard storyboardWithName:@"JGJPaySuccesViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPaySuccesVC"];
                payOrderVC.trade_no = orderListModel.trade_no;
                
                [self.navigationController pushViewController:payOrderVC animated:YES];
            }
            
        }];
        
    }
    
}
-(void)setMyRelationshipProModel:(JGJMyRelationshipProModel *)MyRelationshipProModel
{
    _defaultRelationshipProModel = [[JGJMyRelationshipProModel alloc]init];
    //    _MyRelationshipProModel = MyRelationshipProModel;
    _defaultRelationshipProModel = MyRelationshipProModel;
    
#pragma mark -选择项目后初始化的项目已购信息
    _orderListModel = [JGJOrderListModel  new];
    _orderListModel = _GoodsOrderModel;
#pragma mark - 清空选择的数据
    _orderListModel.add_people = nil;
    _orderListModel.add_cloudplace = nil;
    _orderListModel.add_serverTime = nil;
    
    
    _orderListModel.group_id = _defaultRelationshipProModel.group_id;
    _orderListModel.class_type = _defaultRelationshipProModel.class_type;
    _orderListModel.cloud_space = _defaultRelationshipProModel.cloud_space;
    _orderListModel.buyer_person = _defaultRelationshipProModel.buyer_person;
    _orderListModel.members_num = _defaultRelationshipProModel.members_num;
    _orderListModel.used_space = _defaultRelationshipProModel.used_space;
    _orderListModel.service_lave_days = _defaultRelationshipProModel.service_lave_days;
    _orderListModel.cloud_lave_days = _defaultRelationshipProModel.cloud_lave_days;
    _orderListModel.donate_space      = _defaultRelationshipProModel.donate_space;
    
    
    if (![NSString isEmpty: _defaultRelationshipProModel.service_lave_days]) {
        if ([_defaultRelationshipProModel.service_lave_days intValue] > 0) {
            _orderListModel.add_serverTime = _defaultRelationshipProModel.service_lave_days;
            _orderListModel.isPayDay = YES;
        }else{
            _orderListModel.isPayDay = NO;
        }
    }else{
        _orderListModel.isPayDay = NO;
    }
    
    [self getImputedprice];
    [_tableview reloadData];
}

//选择服务时长
- (void)showManHourPicker{
    
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.titleStr = @"请选择服务时长";
    
    timeModel.limitTime = 5;
    //    timeModel.isShowZero = YES;
    timeModel.endTime = 5;
    if ([NSString isEmpty:self.orderListModel.service_lave_days]) {
        timeModel.currentTime = 0.5;
    }else{
        if ([self.orderListModel.service_lave_days intValue] > 0) {
            timeModel.currentTime = [_orderListModel.service_lave_days integerValue];
            timeModel.ispayModel = YES;
        }else{
            timeModel.currentTime = 0.5;
            
        }
    }
    typeof(self)__weak weakself = self;
    JGJSelctServerTimeview *timeCollectionView = [[JGJSelctServerTimeview alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:NormalWorkTimeTypes isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        if ((int)timeModel.time == timeModel.time) {
            self.sureOrderListModel.serviceTime = [NSString stringWithFormat:@"%.0f", timeModel.time ];
            _orderListModel.add_serverTime = [NSString stringWithFormat:@"%.0f",timeModel.time];
        }else{
            self.sureOrderListModel.serviceTime = [NSString stringWithFormat:@"%.1f", timeModel.time ];
            _orderListModel.add_serverTime = [NSString stringWithFormat:@"%.1f",timeModel.time];
        }
        //设置服务时间
        _orderListModel.isPayDay = timeModel.isDaySelect;
        
        [self getImputedprice];
        
        [weakself.tableview reloadData];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}
-(JGJSureOrderListModel *)sureOrderListModel
{
    if (!_sureOrderListModel) {
        _sureOrderListModel = [[JGJSureOrderListModel alloc]init];
    }
    return _sureOrderListModel;
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _upgrade = orderListModel.upgrade;
    _groupId = orderListModel.group_id;
    _orderListModel = orderListModel;
}
//获取项目列表
-(void)getAllProList
{
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"/pc/Project/getTeamList" parameters:nil success:^(id responseObject) {
        _dataArr = [JGJMyRelationshipProModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (int i = 0; i <_dataArr.count; i++) {
            if (_upgrade) {//升级
                if ([[_dataArr[i] group_id] isEqualToString:_groupId]) {
                    _defaultRelationshipProModel = _dataArr[i];
                    [self setGoodsproDetail];
                }
            }else if ([[_dataArr[i] is_default] isEqualToString:@"1"] ){//订购
                _defaultRelationshipProModel = _dataArr[i];
                [self setGoodsproDetail];
            }
        }
        
        [self getImputedprice];
        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
-(void)setGoodsproDetail
{
    _orderListModel.group_id          = _defaultRelationshipProModel.group_id;
    _orderListModel.class_type        = _defaultRelationshipProModel.class_type;
    _orderListModel.cloud_space       = _defaultRelationshipProModel.cloud_space;
    _orderListModel.buyer_person      = _defaultRelationshipProModel.buyer_person;
    _orderListModel.members_num       = _defaultRelationshipProModel.members_num;
    _orderListModel.used_space        = _defaultRelationshipProModel.used_space;
    _orderListModel.service_lave_days = _defaultRelationshipProModel.service_lave_days;
    _orderListModel.cloud_lave_days   = _defaultRelationshipProModel.cloud_lave_days;
    _orderListModel.service_time      = _sureOrderListModel.serviceTime?:@"0.5";
    _orderListModel.group_name        = _defaultRelationshipProModel.group_name;
    _orderListModel.timestamp         = _GoodsOrderModel.timestamp;
    _orderListModel.donate_space      = _defaultRelationshipProModel.donate_space;
    
    
    if (![NSString isEmpty: _defaultRelationshipProModel.service_lave_days ]) {
        if ([_defaultRelationshipProModel.service_lave_days intValue] > 0) {
            _orderListModel.add_serverTime    = _defaultRelationshipProModel.service_lave_days;
            _orderListModel.isPayDay = YES;
            
        }
    }
    //调试等下记得删掉
    //   _orderListModel.service_lave_days = @"182";
    
    
}
-(void)setGoodsType:(BuyGoodType)GoodsType
{
    _GoodsType = GoodsType;
    if (!_orderListModel) {
        _orderListModel = [JGJOrderListModel new];
    }
    if (_GoodsType == CloudNumType) {
        _orderListModel.goodsType = CloudListType;
        _orderListModel.server_id = @"2";
    }else{
        _orderListModel.goodsType = VipListType;
        _orderListModel.server_id = @"1";
    }
    
}
-(void)choicePaytypeAndtype:(NSString *)type
{
    _orderListModel.pay_type = type;
    [self getImputedprice];
}
#pragma mark - 获取商品信息
-(void)getGoodsDtail
{
    
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithApi:@"v2/order/getServerNameList" parameters:nil success:^(id responseObject) {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
        if (_GoodsType == VIPType) {
            for (int index = 0; index <arr.count; index ++) {
                NSString *sername = arr[index][@"server_name"];
                if ([sername containsString:@"服务版"]) {
                    _orderListModel = [JGJOrderListModel mj_objectWithKeyValues:responseObject[@"list"][index]];
                    _GoodsOrderModel = [JGJOrderListModel mj_objectWithKeyValues:responseObject[@"list"][index]];
                }
            }
        }else{
            for (int index = 0; index <arr.count; index ++) {
                NSString *sername = arr[index][@"server_name"];
                if ([sername containsString:@"云盘"]) {
                    
                    _orderListModel = [JGJOrderListModel mj_objectWithKeyValues:responseObject[@"list"][index]];
                    //后台不给返回响应字段只有自己手动赋值
                    _orderListModel.cloud_price = _orderListModel.price;
                    _orderListModel.cloud_total_amount = _orderListModel.total_amount;
                    _orderListModel.price = @"0";
                    _orderListModel.total_amount = @"0";
                    _GoodsOrderModel = [JGJOrderListModel mj_objectWithKeyValues:responseObject[@"list"][index]];
                    _GoodsOrderModel.cloud_price = _GoodsOrderModel.price;
                    _GoodsOrderModel.cloud_total_amount = _GoodsOrderModel.total_amount;
                    _GoodsOrderModel.price = @"0";
                    _GoodsOrderModel.total_amount = @"0";
                }
            }
        }
        
        [self getAllProList];
        //        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma makr - 选择服务人数和云盘空间
- (void)selectGoodNum:(NSString *)num andtype:(JGJGoodsType)type
{
    _orderListModel.clickPay = NO;
    if (type == VIPType) {
        //此处选中的服务人数
        _orderListModel.add_people = num;
        _Cloudcell.textFiled.text = [NSString stringWithFormat:@"%ld", _Cloudcell.VIPCloundDefult ];
        
    }else{
        //吃出云盘空间
        _orderListModel.add_cloudplace = num;
        
    }
    [self getImputedprice];
    
#pragma mark - 新需求没有改变商品 则关闭按钮交互
    //    [self justPayState];
    
}
#pragma mark - 判断支付状态
-(void)justPayState
{
    if (_GoodsType == VIPServiceType) {
        
        if ([_orderListModel.add_people?:@"0" intValue] == [_orderListModel.buyer_person?:@"0" intValue] && [_orderListModel.cloud_space?:@"0" intValue] == [_orderListModel.add_cloudplace?:@"0" intValue]&&[_orderListModel.add_serverTime?:@"0" intValue] == [_orderListModel.service_lave_days?:@"0" intValue] && [_orderListModel.totalMoney?:@"0" floatValue]<= 0) {
            [self.surePayView closeSurePayButtonUserinterface];
        }else{
            if ([_orderListModel.totalMoney?:@"0" floatValue]<= 0) {
                [self.surePayView sureorderList];
            }else{
                [self.surePayView openSurePayButtonUserinterface];
            }
        }
        
    }else{
        
        if ([_orderListModel.cloud_space?:@"0" intValue] == [_orderListModel.add_cloudplace?:@"0" intValue]&&[_orderListModel.add_serverTime?:@"0" intValue] == [_orderListModel.service_lave_days?:@"0" intValue] && [_orderListModel.totalMoney?:@"0" floatValue]<= 0) {
            [self.surePayView closeSurePayButtonUserinterface];
        }else{
            if ([_orderListModel.totalMoney?:@"0" floatValue]<= 0) {
                [self.surePayView sureorderList];
            }else{
                [self.surePayView openSurePayButtonUserinterface];
            }
        }
        
    }
    
}
/*
 
 % 实际订单金额 = （服务人数 * 服务时长天数 - 项目已购人数 * 黄金服务剩余天数） * 黄金版现价/183 + （云盘空间 * 服务时长天数 - 已购云盘空间 * 云盘服务剩余天数） * 云盘空间现价/10/183
 如果 实际订单金额 < 0，则 订单金额 = 0 （即不退款）
 如果 实际订单金额 >= 0，则 订单金额 = 实际订单金额
 
 % 订单金额=0时，点击立即支付，弹出确认面板：
 该订单无需支付，你确定要提交该订单吗？
 【取消】【 确定】
 确认后直接跳转到支付成功页面
 
 % 已优惠金额：
 如果 实际订单金额 < 0，则 不显示已优惠金额；
 如果 实际订单金额 >= 0，则 计算订单原价金额：
 订单原价金额 = （服务人数 * 服务时长天数 - 项目已购人数 * 黄金服务剩余天数） * 黄金版原价/183 + （云盘空间 * 服务时长天数 - 已购云盘空间 * 云盘服务剩余天数） * 云盘空间原价/10/183
 
 已优惠金额 = 订单原价金额 - 订单金额
 如果 已优惠金额 <= 0，则 不显示已优惠金额
 如果 已优惠金额 > 0，则 显示已优惠金额
 
 
 购买云盘是的金额
 实际订单金额 = （项目已购人数 * 服务时长天数 - 项目已购人数 * 黄金服务剩余天数） * 黄金版现价/183 + （云盘空间 * 服务时长天数 - 已购云盘空间 * 云盘服务剩余天数） * 云盘空间现价/10/183
 
 订单原价金额 = （服务人数 * 服务时长天数 - 项目已购人数 * 黄金服务剩余天数） * 黄金版原价/183 + （云盘空间 * 服务时长天数 - 已购云盘空间 * 云盘服务剩余天数） * 云盘空间原价/10/183
 */
#pragma mark - 计算价格
- (NSString *)getImputedprice
{
    //    _orderListModel.cloud_lave_days = @"100";
    //    _orderListModel.service_lave_days = @"100";
    //现价
    NSString *trueSalary;
    if ([NSString isEmpty:_orderListModel.add_serverTime ]) {
        _orderListModel.add_serverTime = @"0.5";
    }
    if ([NSString isEmpty:_orderListModel.add_people ] && _GoodsType == VIPType) {
        _orderListModel.add_people = _orderListModel.members_num;
    }
    if (_orderListModel.isPayDay) {
        if (_GoodsType == CloudNumType) {
            double salary = ([_orderListModel.buyer_person?:@"0" intValue] *[_orderListModel.add_serverTime floatValue] - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.price floatValue] / 90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue] - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_price floatValue]/10/90;
            trueSalary = [NSString stringWithFormat:@"%.2f",salary];
        }else{
            double salary = ([_orderListModel.add_people floatValue] *[_orderListModel.add_serverTime floatValue] - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.price floatValue] / 90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue] - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_price floatValue]/10/90;
            trueSalary = [NSString stringWithFormat:@"%.2f",salary];
        }
    }else{
        if (_GoodsType == CloudNumType) {
            double salary = ([_orderListModel.buyer_person?:@"0" intValue] *[_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.price floatValue]/90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_price floatValue]/10/90;
            trueSalary = [NSString stringWithFormat:@"%.2f",salary];
        }else{
            double salary = ([_orderListModel.add_people intValue] *[_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.price floatValue]/90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_price floatValue]/10/90;
            trueSalary = [NSString stringWithFormat:@"%.2f",salary];
        }
    }
    //计算原价
    NSString *PreferentialPrice;
    if ([NSString isEmpty:_orderListModel.add_serverTime ]) {
        _orderListModel.add_serverTime = @"0.5";
    }
    if ([NSString isEmpty:_orderListModel.add_people ] && _GoodsType == VIPType) {
        _orderListModel.add_people = _orderListModel.members_num;
    }
    //    订单原价金额 = （服务人数 * 服务时长天数 - 项目已购人数 * 黄金服务剩余天数） * 黄金版原价/183 + （云盘空间 * 服务时长天数 - 已购云盘空间 * 云盘服务剩余天数） * 云盘空间原价/10/183
    
    if (_orderListModel.isPayDay) {
        
        if (_GoodsType == CloudNumType) {
            double salary = ([_orderListModel.add_people intValue] *[_orderListModel.add_serverTime floatValue] - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.total_amount floatValue] / 90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue] - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_total_amount floatValue]/10/90;
            PreferentialPrice = [NSString stringWithFormat:@"%.2f",salary];
        }else{
            double salary = ([_orderListModel.add_people floatValue] *[_orderListModel.add_serverTime floatValue] - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.total_amount floatValue] / 90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue] - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_total_amount floatValue]/10/90;
            PreferentialPrice = [NSString stringWithFormat:@"%.2f",salary];
        }
    }else{
        if (_GoodsType == CloudNumType) {
            double salary = ([_orderListModel.add_people floatValue] *[_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.total_amount floatValue]/90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_total_amount floatValue]/10/90;
            PreferentialPrice = [NSString stringWithFormat:@"%.2f",salary];
        }else{
            double salary = ([_orderListModel.add_people floatValue] *[_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.buyer_person floatValue]*[_orderListModel.service_lave_days floatValue]) * [_orderListModel.total_amount floatValue]/90 + ([_orderListModel.add_cloudplace floatValue] * [_orderListModel.add_serverTime floatValue]/0.5*180 - [_orderListModel.cloud_space floatValue] *[_orderListModel.cloud_lave_days floatValue])*[_orderListModel.cloud_total_amount floatValue]/10/90;
            PreferentialPrice = [NSString stringWithFormat:@"%.2f",salary];
        }
    }
    float desPrice;
    desPrice =   [PreferentialPrice floatValue] - [trueSalary floatValue];
    PreferentialPrice = [NSString stringWithFormat:@"%.2f",desPrice];
    if ([PreferentialPrice floatValue] <= 0) {
        
        PreferentialPrice = @"0.00";
    }
    if ([trueSalary floatValue] <= 0) {
        if (alert) {
            [alert removeFromSuperview];
            alert = nil;
        }
        
        
        
        if (!alert && _orderListModel.clickPay) {
            
            
            
            //            [self isSub];
        }
        trueSalary = @"0.00";
        
    }
    
    _orderListModel.totalMoney = trueSalary;
    
    [_surePayView setPriVteNum:PreferentialPrice andSalary:trueSalary];
    
    [self justPayState];
    
    return trueSalary;
}
-(void)isSub{
    
    alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"你正在减少服务人数或云盘空间，请谨慎操作    " delegate:self buttonTitles:@"我再想想",@"确认订单", nil];
    //    alert.tag = 100;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    [alert show];
    
    
}
- (void)desAler
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (alert) {
        [alert removeFromSuperview];
    }
    
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            _orderListModel.clickPay = NO;
            
        }else{
            _orderListModel.clickPay = NO;
            
            //            [self isSub];
            
        }
    }else if (alertView.tag == 102){
        //只显示提示框
    }
    else{
        typeof(self) __weak weakself = self;
        if (buttonIndex == 0) {
            _orderListModel.clickPay = NO;
            
        }else{
            _orderListModel.clickPay = NO;
            
            [JGJWeiXin_pay GETNetPayidforAliPayorWeixinPay:_orderListModel andpayBlock:^(JGJOrderListModel *orderListModel) {
                
                //购买成功之后回调消息成功@(YES),失败@(NO)或者不回掉
                
                if (weakself.notifyServiceSuccessBlock) {
                    weakself.notifyServiceSuccessBlock(orderListModel);
                }
                
                if (orderListModel.paySucees) {
                    JGJPaySuccesViewController *payOrderVC = [[UIStoryboard storyboardWithName:@"JGJPaySuccesViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPaySuccesVC"];
                    payOrderVC.trade_no = orderListModel.trade_no;
                    [weakself.navigationController pushViewController:payOrderVC animated:YES];
                }
            }];
        }
    }
    alertView.delegate = nil;
    alertView = nil;
}
#pragma mark -计算是否隐藏服务时长的秒速
/*
 黄金版续期提示：
 如果 黄金服务剩余天数 > 0 且 服务时长 ！= 云盘服务剩余天数，则显示“黄金服务版的服务人数（6人）和赠送空间（12G）将同时续期33天” 续期天数 = 服务时长天数 - 云盘服务剩余天数
 续期天数 = 服务时长天数 - 云盘服务剩余天数*/
-(BOOL)getIsHiddendDeslable
{
    if (![NSString isEmpty: _orderListModel.service_lave_days ] && ![NSString isEmpty:_orderListModel.cloud_lave_days]) {
        int day = 0 ;
        
        NSString *dayStr =  _orderListModel.isPayDay?[NSString stringWithFormat:@"%@",_orderListModel.add_serverTime]:[NSString stringWithFormat:@"%.0f",[_orderListModel.add_serverTime floatValue]/0.5*180];
        day = [dayStr intValue];
        if ([_orderListModel.service_lave_days floatValue] > 0 && _orderListModel.add_serverTime != _orderListModel.cloud_lave_days) {
            return NO;
        }
    }
    return YES;
}
//返回详细的云盘续费描述
-(NSString *)cloudContinueDetail
{
    NSInteger day = 0 ;
    
    NSString *dayStr =  _orderListModel.isPayDay?[NSString stringWithFormat:@"%@",_orderListModel.add_serverTime]:[NSString stringWithFormat:@"%.0f",[_orderListModel.add_serverTime floatValue]/0.5*180];
    day = [dayStr intValue] - [_orderListModel.cloud_lave_days integerValue];
    long totalDonate;
    long donate_spase;
    long buyPeople;
    if ([NSString isEmpty:_orderListModel.donate_space]) {
        donate_spase = 0;
    }else{
        donate_spase = [_orderListModel.donate_space intValue];
        
    }
    if ([NSString isEmpty:_orderListModel.buyer_person]) {
        buyPeople = 0;
    }else{
        buyPeople = [_orderListModel.buyer_person intValue];
    }
    totalDonate = donate_spase * buyPeople;
    
    return [NSString stringWithFormat:@"黄金服务版的服务人数 (%@人) 和赠送空间 (%ldG) 将同时续期 %ld天",_orderListModel.buyer_person,totalDonate,(long)day];
}
#pragma mark - 苹果支付
/*
 - (void)getRequestAppleProduct
 {
 // 7.这里的com.czchat.CZChat01就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
 NSArray *product = [[NSArray alloc] initWithObjects:@"com.czchat.CZChat01",nil];
 
 NSSet *nsset = [NSSet setWithArray:product];
 
 // 8.初始化请求
 SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
 request.delegate = self;
 
 // 9.开始请求
 [request start];
 }
 
 // 10.接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
 - (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
 {
 NSArray *product = response.products;
 
 //如果服务器没有产品
 if([product count] == 0){
 NSLog(@"nothing");
 return;
 }
 
 SKProduct *requestProduct = nil;
 for (SKProduct *pro in product) {
 
 NSLog(@"%@", [pro description]);
 NSLog(@"%@", [pro localizedTitle]);
 NSLog(@"%@", [pro localizedDescription]);
 NSLog(@"%@", [pro price]);
 NSLog(@"%@", [pro productIdentifier]);
 
 // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
 if([pro.productIdentifier isEqualToString:@"com.czchat.CZChat01"]){
 requestProduct = pro;
 }
 }
 
 // 12.发送购买请求
 SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
 [[SKPaymentQueue defaultQueue] addPayment:payment];
 }
 
 //请求失败
 - (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
 NSLog(@"error:%@", error);
 }
 
 //反馈请求的产品信息结束后
 - (void)requestDidFinish:(SKRequest *)request{
 NSLog(@"信息反馈结束");
 }
 
 // 13.监听购买结果
 - (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
 for(SKPaymentTransaction *tran in transaction){
 
 switch (tran.transactionState) {
 case SKPaymentTransactionStatePurchased:
 NSLog(@"交易完成");
 
 break;
 case SKPaymentTransactionStatePurchasing:
 NSLog(@"商品添加进列表");
 
 break;
 case SKPaymentTransactionStateRestored:
 NSLog(@"已经购买过商品");
 [[SKPaymentQueue defaultQueue] finishTransaction:tran];
 break;
 case SKPaymentTransactionStateFailed:
 NSLog(@"交易失败");
 [[SKPaymentQueue defaultQueue] finishTransaction:tran];
 break;
 default:
 break;
 }
 }
 }
 
 // 14.交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
 - (void)completeTransaction:(SKPaymentTransaction *)transaction
 {
 NSString * str=[[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
 
 NSString *environment=[self environmentForReceipt:str];
 NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@",environment);
 
 
 // 验证凭据，获取到苹果返回的交易凭据
 // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
 NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
 // 从沙盒中获取到购买凭据
 NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
 
 NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
 
 NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
 NSLog(@"_____%@",sendString);
 NSURL *StoreURL=nil;
 if ([environment isEqualToString:@"environment=Sandbox"]) {
 
 StoreURL= [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
 }
 else{
 
 StoreURL= [[NSURL alloc] initWithString: @"https://buy.itunes.apple.com/verifyReceipt"];
 }
 //这个二进制数据由服务器进行验证；zl
 NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
 
 NSLog(@"++++++%@",postData);
 NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:StoreURL];
 
 [connectionRequest setHTTPMethod:@"POST"];
 [connectionRequest setTimeoutInterval:50.0];//120.0---50.0zl
 [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
 [connectionRequest setHTTPBody:postData];
 
 //开始请求
 NSError *error=nil;
 NSData *responseData=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:&error];
 if (error) {
 NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
 return;
 }
 NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
 NSLog(@"请求成功后的数据:%@",dic);
 //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
 //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
 
 NSString *product = transaction.payment.productIdentifier;
 
 NSLog(@"transaction.payment.productIdentifier++++%@",product);
 
 if ([product length] > 0)
 {
 NSArray *tt = [product componentsSeparatedByString:@"."];
 
 NSString *bookid = [tt lastObject];
 
 if([bookid length] > 0)
 {
 
 NSLog(@"打印bookid%@",bookid);
 //这里可以做操作吧用户对应的虚拟物品通过自己服务器进行下发操作,或者在这里通过判断得到用户将会得到多少虚拟物品,在后面（[self getApplePayDataToServerRequsetWith:transaction];的地方）上传上面自己的服务器。
 }
 }
 //此方法为将这一次操作上传给我本地服务器,记得在上传成功过后一定要记得销毁本次操作。调用
 [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
 //    [self getApplePayDataToServerRequsetWith:transaction];
 }
 
 
 
 
 -(NSString * )environmentForReceipt:(NSString * )str
 {
 str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
 
 str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
 
 str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
 
 str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
 
 str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
 
 NSArray * arr=[str componentsSeparatedByString:@";"];
 
 //存储收据环境的变量
 NSString * environment=arr[2];
 return environment;
 }*/


@end
