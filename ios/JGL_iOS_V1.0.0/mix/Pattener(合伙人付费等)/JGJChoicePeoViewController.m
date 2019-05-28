//
//  JGJChoicePeoViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJChoicePeoViewController.h"
#import "JGJChoiceproTableViewCell.h"
#import "JGJSureOrderListViewController.h"
@interface JGJChoicePeoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong ,nonatomic)NSMutableArray <JGJMyRelationshipProModel *>*dataArr;
@property (nonatomic, strong) JGJActiveGroupModel *activeGroupModel;

@end

@implementation JGJChoicePeoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getAllProList];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"选择服务项目";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJChoiceproTableViewCell *SurePayCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJChoiceproTableViewCell" owner:nil options:nil]firstObject];
    SurePayCell.MyRelationshipProModel = _dataArr[indexPath.row];
    if ([_MyRelationshipProModel.group_name isEqualToString:[_dataArr[indexPath.row] group_name]]) {
        [_tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    SurePayCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return SurePayCell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    for(UIViewController *viewcontroller in self.navigationController.viewControllers)
    {
        if ([viewcontroller isKindOfClass:[JGJSureOrderListViewController class]]) {
            JGJSureOrderListViewController *orderList = (JGJSureOrderListViewController *)viewcontroller;
            orderList.MyRelationshipProModel = _dataArr[indexPath.row];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)getAllProList
{

    

    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"/pc/Project/getTeamList" parameters:nil success:^(id responseObject) {
        _dataArr = [JGJMyRelationshipProModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_tableview reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
  
    }];
     
     
     }

-(void)setMyRelationshipProModel:(JGJMyRelationshipProModel *)MyRelationshipProModel
{
    _MyRelationshipProModel = [[JGJMyRelationshipProModel alloc]init];
    _MyRelationshipProModel = MyRelationshipProModel;
    [_tableview reloadData];

}
-(void)setGroupListArr:(NSMutableArray<JGJMyRelationshipProModel *> *)groupListArr
{

    _dataArr = [[NSMutableArray alloc]initWithArray:groupListArr];
    [_tableview reloadData];
}
@end
