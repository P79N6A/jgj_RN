//
//  JGJRemainingSumViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRemainingSumViewController.h"
#import "JGJAddAccountTableViewCell.h"
#import "JGJTipAccountView.h"
#import "JGJAddAccountViewController.h"
#import "JGJSureWithdrawViewController.h"
#import "JGJSureDeletAccountView.h"
@interface JGJRemainingSumViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
deleteDelegate,
AddAccountDelegate
>
@property (nonatomic ,strong)UIView *tableviewsHeaderView;
@property (nonatomic ,strong)UIView *tableviewsFooterView;
@property (nonatomic ,strong)NSMutableArray <JGJAccountListModel *>*dataArr;
@property (nonatomic ,strong)JGJTipAccountView *tipAccounntView;
@property (nonatomic ,strong)JGJAccountListModel *AccountListModel;
@property (strong ,nonatomic) UIButton *button;
@property (strong ,nonatomic) NSIndexPath *selectIndexpath;
@property (strong ,nonatomic) NSString *amount;

@end

@implementation JGJRemainingSumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableHeaderView = self.tableviewsHeaderView;
    _tableview.tableFooterView = self.tableviewsFooterView;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.allowsMultipleSelection = NO;
    self.title = @"余额提现";
    [self getAcoountList];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJAddAccountTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJAddAccountTableViewCell" owner:nil options:nil]firstObject];
    cell.delegate = self;
    cell.accountModel = _dataArr[indexPath.row];
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count <=0) {
        [self.view addSubview:self.tipAccounntView];
    }else{
        if (_tipAccounntView) {
            [_tipAccounntView removeFromSuperview];
        }
        return _dataArr.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
    
}
- (UIView *)tableviewsHeaderView
{
    if (!_tableviewsHeaderView) {
        _tableviewsHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = AppFontf18215Color;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"为了保证你的资金安全，最多只能添加3个提现账户";
        [_tableviewsHeaderView addSubview:lable];
        _tableviewsHeaderView.backgroundColor = AppFontf1f1f1Color;
    }
    return _tableviewsHeaderView;
}

- (UIView *)tableviewsFooterView
{
    if (!_tableviewsFooterView) {
        _tableviewsFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 100)];
        _tableviewsFooterView.backgroundColor = [UIColor whiteColor];
       _button = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, TYGetUIScreenWidth - 20, 50)];
        _button.backgroundColor = AppFontEB4E4EColor;
        [_button setTitle:@"添加提现账户" forState:UIControlStateNormal];
        _button.layer.cornerRadius = JGJCornerRadius;
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(clickAddAcount) forControlEvents:UIControlEventTouchUpInside];
        [_tableviewsFooterView addSubview:_button];
    }
    return _tableviewsFooterView;
}
-(JGJTipAccountView *)tipAccounntView
{
    if (!_tipAccounntView) {
        _tipAccounntView = [[JGJTipAccountView alloc]initWithFrame:self.view.bounds];
        _tipAccounntView.backgroundColor = [UIColor whiteColor];
        _tipAccounntView.delegate = self;
    }
    return _tipAccounntView;
}
-(void)clickAddAcount
{

    JGJAddAccountViewController *addVC = [[UIStoryboard storyboardWithName:@"JGJAddAccountViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAccountVC"];
    [self.navigationController pushViewController:addVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAcoountList];

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    _selectIndexpath = indexPath;
    [self.tableview selectRowAtIndexPath:_selectIndexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    JGJSureWithdrawViewController *SureVC = [[UIStoryboard storyboardWithName:@"JGJSureWithdrawViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSureWithdrawVC"];
    JGJAccountListModel *model = _dataArr[indexPath.row];
    model.amount = _amount;
    model.telephone = [TYUserDefaults objectForKey:JLGPhone];

    SureVC.AccountListModel = model;
    [self.navigationController pushViewController:SureVC animated:YES];

}
-(void)clickAddaccountButton
{
    JGJAddAccountViewController *addVC = [[UIStoryboard storyboardWithName:@"JGJAddAccountViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAccountVC"];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - 获取账户列表
- (void)getAcoountList
{
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *paramDic = @{@"uid":[TYUserDefaults objectForKey:JLGUserUid]?:@""};
    [JLGHttpRequest_AFN PostWithApi:@"v2/partner/partnerWithdrawTeleList" parameters:paramDic success:^(id responseObject) {
    _dataArr = [JGJAccountListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    _amount = responseObject[@"amount"];
    if (_dataArr.count >=3) {
        _button.hidden = YES;
    }else{
        _button.hidden = NO;
    }
    [_tableview reloadData];
    if (_selectIndexpath) {
        [self.tableview selectRowAtIndexPath:_selectIndexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        JGJAddAccountTableViewCell *cell = (JGJAddAccountTableViewCell *)[_tableview cellForRowAtIndexPath:_tableview.indexPathForSelectedRow];
        cell.useingLable.hidden = YES;
    }
        [TYLoadingHub hideLoadingView];

}failure:^(NSError *error) {
    [TYLoadingHub hideLoadingView];
}];

}
#pragma mark - 点击删除按钮
-(void)clickDeleteButtonAndIndexpathRow:(NSInteger)indexpathRow
{
    typeof(self) __weak weakself = self;
[JGJSureDeletAccountView showDeleteSureButtonAlerViewandBlock:^(BOOL deleteButton) {
    if (deleteButton) {
        [weakself deleteAccountandIndexpath:indexpathRow];
   
    }
}];
}
#pragma mark - 删除账户
-(void)deleteAccountandIndexpath:(NSInteger)indexpath
{
    typeof(self) __weak weakself = self;
    [JLGHttpRequest_AFN PostWithApi:@"v2/partner/delPartnerWithdrawTele" parameters:@{@"id":[_dataArr[indexpath] id]} success:^(id responseObject) {
        [TYShowMessage showSuccess:@"删除成功"];
    [weakself getAcoountList];
    }failure:^(NSError *error) {
        [TYShowMessage showSuccess:@"服务器错误"];
    }];
}

@end
