//
//  JGJlLogChoiceClassfyViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJlLogChoiceClassfyViewController.h"
#import "JGJLogChoiceClassfyTableViewCell.h"
#import "JGJBuilderDiaryViewController.h"
#import "NSString+Extend.h"
@interface JGJlLogChoiceClassfyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@end

@implementation JGJlLogChoiceClassfyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择分类名称";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJLogChoiceClassfyTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJLogChoiceClassfyTableViewCell" owner:nil options:nil]firstObject];
    cell.Selectmodel = _dateArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dateArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJBuilderDiaryViewController class]]) {
            
            JGJBuilderDiaryViewController *baseVc = (JGJBuilderDiaryViewController *)vc;
            baseVc.sendDailyModel.selectValue = [_dateArr[indexPath.row] name];
            baseVc.sendDailyModel.selectID = [_dateArr[indexPath.row] id];
            
            if (![NSString isEmpty:_element_Key]) {
            [baseVc.MoreparmDic setObject:[_dateArr[indexPath.row] id] forKey:_element_Key];
            [baseVc.MoreparmDic setObject:[_dateArr[indexPath.row] name] forKey:[_element_Key stringByAppendingString:@"name"]];
  
            }
                break;
            
        }
        
    }


    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setDateArr:(NSArray<selectvaluelistModel *> *)dateArr
{
    _dateArr = [[NSArray alloc]initWithArray:dateArr];

}
-(void)setSelectListModel:(selectvaluelistModel *)selectListModel
{
    _selectListModel = [selectvaluelistModel new];
    _selectListModel = selectListModel;

}

@end
