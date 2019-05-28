//
//  JGJServiceStroeViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJServiceStroeViewController.h"
#import "JGJMeIndentTableViewCell.h"
#import "JGJOrderDetailViewController.h"
#import "JGJSureOrderListViewController.h"
#import "JGJOrderDetailViewController.h"
#import "JGJMyOrderListDefultView.h"
@interface JGJServiceStroeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong ,nonatomic)JGJMyorderListmodel *orderListModel;
@property (strong ,nonatomic)JGJMyOrderListDefultView *defultView;

@end

@implementation JGJServiceStroeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self getOrderList];
}
- (void)initView
{
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJMeIndentTableViewCell *SurePayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJMeIndentTableViewCell" owner:nil options:nil]firstObject];
    SurePayCell.selectionStyle = UITableViewCellSelectionStyleNone;
    SurePayCell.model = _orderListModel.list[indexPath.row];
    SurePayCell.payButton.userInteractionEnabled = NO;
    return SurePayCell;

    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _orderListModel.list.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;

}

-(void)getOrderList
{
    NSDictionary *dic = @{@"server_id":@"",
                          @"stime":@"",
                          @"etime":@"",
                          @"order_sn":@"",
                          @"telephone":@"",
                          @"pro_id":@"",
                          @"pg":@"",
                          @"pagesize":@"",
                          };
[JLGHttpRequest_AFN PostWithApi:@"v2/order/orderList" parameters:dic success:^(id responseObject) {
    _orderListModel = [JGJMyorderListmodel mj_objectWithKeyValues:responseObject];
    if (!_orderListModel.list.count) {
        [self.view addSubview:self.defultView];
        
    }else{
        if (_defultView) {
            _defultView.hidden = YES;
        }
    }
    [_tableview reloadData];
}];

}
-(JGJMyOrderListDefultView *)defultView
{
    if (!_defultView) {
        _defultView = [[JGJMyOrderListDefultView alloc]initWithFrame:self.view.frame];
        _defultView.backgroundColor = [UIColor whiteColor];
    }
    return _defultView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    JGJOrderDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"JGJOrderDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJOrderDetailVC"];
    detailVC.orderListModel = self.orderListModel.list[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
