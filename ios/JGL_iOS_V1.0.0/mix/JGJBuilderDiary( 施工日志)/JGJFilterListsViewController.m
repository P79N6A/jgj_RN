//
//  JGJFilterListsViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/8/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFilterListsViewController.h"
#import "JGJFilterslogsTypeTableViewCell.h"
#import "JGJLogFilterViewController.h"
@interface JGJFilterListsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@end

@implementation JGJFilterListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.backgroundColor = AppFontf1f1f1Color;
    self.title = @"选择日志类型";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JGJFilterslogsTypeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJFilterslogsTypeTableViewCell" owner:nil options:nil]lastObject];
    cell.model = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (UIViewController *vc  in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJLogFilterViewController class]]) {
            JGJLogFilterViewController *logVC = (JGJLogFilterViewController *)vc;
            logVC.getLogModel = _dataArr[indexPath.row];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)setDataArr:(NSMutableArray<JGJGetLogTemplateModel *> *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    _dataArr = dataArr;
}
@end
