//
//  JGJMarkDayBillVc.m
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMarkDayBillVc.h"
#import "JGJWorkTypeCollectionView.h"
#import "YZGAddForemanAndMateViewController.h"
#import "YZGMateSalaryTemplateViewController.h"
#import "JGJMoreDayViewController.h"
#import "JGJMorePeopleViewController.h"

@interface JGJMarkDayBillVc ()
{
    //是否是聊天界面，并且是工人，工人不能选工头，工头不能选项目
    //YES:是聊天的时候的工人,NO:是聊天的时候的工头
    BOOL _isChatMate;
}
@property (nonatomic,copy)   NSArray *workTimeDataArray;//上班时间
@property (nonatomic,copy)   NSArray *workOverTimeDataArray;//加班时间

@end

@implementation JGJMarkDayBillVc
//基数，因为发布记账多一行，编辑记账少一行
static NSInteger kDayRowBaseNum = 0;

- (void)dataInit{
    [super dataInit];
    
    if (self.markBillType == MarkBillTypeEdit) {
        self.proNameIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:2 inSection:2]:[NSIndexPath indexPathForRow:0 inSection:3];
    }else{
        self.proNameIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:3 inSection:2]:[NSIndexPath indexPathForRow:0 inSection:3];
    }

    self.noteIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:0 inSection:3]:[NSIndexPath indexPathForRow:1 inSection:3];
    kDayRowBaseNum = (self.markBillType == MarkBillTypeEdit)?0:1;
    
    _isChatMate = ((self.markBillType == MarkBillTypeChat || self.isChat) && self.JGJisMateBool);
    
    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_account_edit_up.png"] forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线


}

- (void)cellDataInit {
    NSArray *firstSectionArr = @[
                                        @[@"",@""],
                                        ];
    NSMutableArray *secondSectionArr;
    if (JLGisLeaderBool) {//班组长/工头
            secondSectionArr = @[
                                 @[[NSString stringWithFormat:@"%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]],
                                 @[@"工资标准",@"这里设置工资/上班时间/加班时长"]
                                 ].mutableCopy;
    }else{//工人
            secondSectionArr = @[
                                 @[[NSString stringWithFormat:@"%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]],
                                 @[@"工资标准",@"这里设置工资/上班时间/加班时长"]
                                 ].mutableCopy;
    }
    NSMutableArray *thirdSectionArr;
    if (JLGisLeaderBool) {//班组长/工头
        thirdSectionArr = @[
                             @[@"上班时长",@""],
                             @[@"加班时长",@""],
                             @[@"所在项目",@"例如:万科魅力之城"]
                             ].mutableCopy;
    }else{//工友
        thirdSectionArr = @[
                             @[@"上班时长",@""],
                             @[@"加班时长",@""]
                             ].mutableCopy;
    }
    //如果是发布记账就填充时间
    if (self.markBillType != MarkBillTypeEdit) {
        [thirdSectionArr insertObject:@[@"选择日期",self.yzgGetBillModel.date] atIndex:0];
    }
  
    NSMutableArray *fourthSectionArr;

    if (JLGisLeaderBool) {//班组长/工头
        fourthSectionArr = @[
                             (self.markBillType != MarkBillTypeEdit)?@[@"备注",@"可填写备注信息"]:@[@"",@""]
                              ].mutableCopy;
    }else{
        fourthSectionArr = @[//工友
                             @[@"所在项目",@"例如:万科魅力之城"],
                             (self.markBillType != MarkBillTypeEdit)?@[@"备注",@"可填写备注信息"]:@[@"",@""]
                              ].mutableCopy;
    }
    
    self.cellDataArray = @[firstSectionArr,secondSectionArr,thirdSectionArr,fourthSectionArr].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.workTimeDataArray = nil;
    self.workOverTimeDataArray = nil;
}

- (UITableViewCell *)getCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return [self configureMoneyCell:cell atIndexPath:indexPath];
            break;
        case 1:
            return [self configureNextVcCell:cell atIndexPath:indexPath];
            break;
        case 2:
            return [self configureNextVcCell:cell atIndexPath:indexPath];
            break;
        case 3:
            return [self configureNextVcCell:cell atIndexPath:indexPath];
            break;
        default:
            break;
    }

    return cell;
}

- (void)dayWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1 && indexPath.row == 1){
        //进入工资模板
        [self showSalaryTemplateVc];
    }else if(indexPath.section == 2){
        if(indexPath.row == (-1 + kDayRowBaseNum)){//上班时长
            
            
            if (self.yzgGetBillModel.set_tpl.o_h_tpl > 0 && self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
                [self showDatePickerByIndexPath:indexPath];
            }else{
                [TYShowMessage showError:@"请先设置工资标准"];
            
            }
        }
        else if(indexPath.row == (0 + kDayRowBaseNum)){//上班时长
            [self showManHourPicker:indexPath];
        }
        else if(indexPath.row == (1 + kDayRowBaseNum)){//加班时长
            [self showOverHourPicker:indexPath];
        }
        else if(indexPath.row == (2 + kDayRowBaseNum)){//所在项目
            [self showProjectPickerByIndexPath:indexPath];
        }
    }else if(indexPath.section == 3){
        if (self.proNameIndexPath.row == indexPath.row && self.proNameIndexPath.section == indexPath.section) {
            [self showProjectPickerByIndexPath:indexPath];
        }else{
            [self goToOtherInfoVc];
        }
    }
}

- (YZGRecordWorkNextVcTableViewCell *)configDayNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YZGRecordWorkNextVcTableViewCell *nextVcCell= (YZGRecordWorkNextVcTableViewCell *)cell;
    NSString *detailString;
    
    NSString *titleStrDefault = self.cellDataArray[indexPath.section][indexPath.row][0];
    NSString *detailStrDefault = self.cellDataArray[indexPath.section][indexPath.row][1];
    
    //判断detail颜色
    UIColor *detailColor;
    
    switch (indexPath.section) {
        case 1:
        {
            detailColor = [UIColor blackColor];
            if (indexPath.row == 1) {//工资标准
                NSString *jointString;
                if (self.yzgGetBillModel.set_tpl.s_tpl > 0) {
                    jointString = [NSString stringWithFormat:@"%.1f元/%@小时(正常)/%@小时(加班)",self.yzgGetBillModel.set_tpl.s_tpl,@(self.yzgGetBillModel.set_tpl.w_h_tpl),@(self.yzgGetBillModel.set_tpl.o_h_tpl)];
                }else{
                    jointString = [NSString stringWithFormat:@"%@小时(正常)/%@小时(加班)",@(self.yzgGetBillModel.set_tpl.w_h_tpl),@(self.yzgGetBillModel.set_tpl.o_h_tpl)];
                }
                
                NSInteger fontSize = (TYGetUIScreenWidthRatio*12.0) > 14?14:(TYGetUIScreenWidthRatio*12.0);
                nextVcCell.detailTF.font = [UIFont systemFontOfSize:fontSize];
                //初始化的状态
                BOOL isInitStatus = self.yzgGetBillModel.set_tpl.w_h_tpl == -1;
                
                //没有时间
                BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl == 0 && self.yzgGetBillModel.set_tpl.o_h_tpl == 0;
                detailString = isInitStatus || isNoHour?nil:jointString;
            }else{//选择人
                nextVcCell.rightImageView.hidden = (self.markBillType == MarkBillTypeEdit || _isChatMate);
                detailString = self.yzgGetBillModel.name;
                
                detailColor = [self setNameColorBy:detailString defaultStr:detailStrDefault];
            }
        }
            break;
        case 2:
        {
            if(indexPath.row == (-1 + kDayRowBaseNum)){//时间
                detailString = self.yzgGetBillModel.date;
                detailColor = JGJMainColor;
            }
            else if(indexPath.row == (0 + kDayRowBaseNum)){//上班时长
                detailString= [self getManHourStr:indexPath];
                detailColor = JGJMainColor;
            }
            else if(indexPath.row == (1 + kDayRowBaseNum)){//加班时长
                detailString= [self getOverHourStr:indexPath];
                detailColor = JGJMainColor;
            }
            else if(indexPath.row == (2 + kDayRowBaseNum)){//所在项目
                if ([self.yzgGetBillModel.proname isEqualToString:@"其它项目"]) {
                detailString = @"    ";
                }else{
                detailString = self.yzgGetBillModel.proname;
                }
                //聊天并且自己是创建者的时候，不能选择项目
                if (self.markBillType == MarkBillTypeChat || self.isChat) {
                    detailColor = [self.workProListModel.myself_group boolValue]?AppFontccccccColor:[UIColor blackColor];
                    nextVcCell.rightImageView.hidden = [self.workProListModel.myself_group boolValue];
                }else{
                    detailColor = [UIColor blackColor];
                }

            }
        }
            break;
        case 3:
        {
            if (indexPath.row == self.noteIndexPath.row && indexPath.section == self.noteIndexPath.section) {
                detailColor = [UIColor blackColor];
                detailString = self.yzgGetBillModel.notes_txt;
                nextVcCell.detailTFLayoutL.constant = 30;
            }else if(indexPath.row == self.proNameIndexPath.row && indexPath.section == self.proNameIndexPath.section){
                
                detailString = self.yzgGetBillModel.proname;
                
                //聊天并且自己是创建者的时候，不能选择项目
                if (self.markBillType == MarkBillTypeChat || self.isChat) {
                    detailColor = [self.workProListModel.myself_group boolValue]?AppFontccccccColor:[UIColor blackColor];
                    nextVcCell.rightImageView.hidden = [self.workProListModel.myself_group boolValue];
                }else{
                    detailColor = [UIColor blackColor];
                }
            }
        }
            break;
        default:
            break;
    }
    
    [nextVcCell setDetailTFPlaceholder:detailStrDefault];
    [nextVcCell setTitleColor:nil setDetailColor:detailColor];
    [nextVcCell setTitle:titleStrDefault setDetail:[NSString isEmpty:detailString]?nil:detailString];
    
    return nextVcCell;
}


#pragma mark 获取上班时长
- (NSString *)getManHourStr:(NSIndexPath *)indexPath{
    NSString *manHourStr;
    NSString *workTimeStr;
    if (self.yzgGetBillModel.manhour > 0) {
#pragma mark - 注释掉逐行  因为现在的显示逻辑不对
    workTimeStr = self.yzgGetBillModel.manhourTimeStr;
        if (self.yzgGetBillModel.manhour == (int)self.yzgGetBillModel.manhour) {
            workTimeStr = [NSString stringWithFormat:@"%.0f小时",self.yzgGetBillModel.manhour];
            //判断一个工 班个工
            if (self.yzgGetBillModel.manhour == self.yzgGetBillModel.set_tpl.w_h_tpl) {
                workTimeStr = [NSString stringWithFormat:@"%.0f小时(一个工)",self.yzgGetBillModel.manhour];
                
            }else if (self.yzgGetBillModel.manhour *2 == self.yzgGetBillModel.set_tpl.w_h_tpl){
                workTimeStr = [NSString stringWithFormat:@"%.0f小时(半个工)",self.yzgGetBillModel.manhour];
            }
        }else{
            workTimeStr = [NSString stringWithFormat:@"%.1f小时",self.yzgGetBillModel.manhour];
            
            //判断一个工 班个工
            if (self.yzgGetBillModel.manhour == self.yzgGetBillModel.set_tpl.w_h_tpl) {
                workTimeStr = [NSString stringWithFormat:@"%.1f小时(一个工)",self.yzgGetBillModel.manhour];
                
            }else if (self.yzgGetBillModel.manhour *2 == self.yzgGetBillModel.set_tpl.w_h_tpl){
                workTimeStr = [NSString stringWithFormat:@"%.1f小时(半个工)",self.yzgGetBillModel.manhour];
            }
        }
    }else{
        workTimeStr = @"休息";
    }
    if (self.yzgGetBillModel.manhour !=0) {
        manHourStr = workTimeStr;
    }else{
        manHourStr = self.yzgGetBillModel.set_tpl.s_tpl !=0 ?workTimeStr:self.cellDataArray[indexPath.section][indexPath.row][1];
    }
//0表示休息 (2.0.3 - yj)
    if (self.yzgGetBillModel.manhour == 0) {
        manHourStr = @"休息";
    }
    
    
    //判断删除的账单 并且是修改账单 不显示

    if (self.yzgGetBillModel.manhour == 0&&[self.yzgGetBillModel.del_diff_tag intValue] == 1) {
        manHourStr = @"";
    }

    return manHourStr;
}

#pragma mark 获取加班时长
- (NSString *)getOverHourStr:(NSIndexPath *)indexPath{
    NSString *overHourStr;
    switch ((NSInteger)self.yzgGetBillModel.overtime) {
        case -1:
            overHourStr = self.cellDataArray[indexPath.section][indexPath.row][1];
            break;
        default:
        {
            if (self.yzgGetBillModel.overtime > 0) {
                if (self.yzgGetBillModel.overtime == (int)self.yzgGetBillModel.overtime) {
                    overHourStr = [NSString stringWithFormat:@"%.0f小时",self.yzgGetBillModel.overtime];
                    //判断一个工 班个工
                    if (self.yzgGetBillModel.overtime == self.yzgGetBillModel.set_tpl.o_h_tpl) {
                        overHourStr = [NSString stringWithFormat:@"%.0f小时(一个工)",self.yzgGetBillModel.overtime];
                        
                    }else if (self.yzgGetBillModel.overtime *2 == self.yzgGetBillModel.set_tpl.o_h_tpl){
                        overHourStr = [NSString stringWithFormat:@"%.0f小时(半个工)",self.yzgGetBillModel.overtime];

                    
                    }

                }else{
            overHourStr = [NSString stringWithFormat:@"%.1f小时",self.yzgGetBillModel.overtime];
                    
                    
                    //判断一个工 班个工
                    if (self.yzgGetBillModel.overtime == self.yzgGetBillModel.set_tpl.o_h_tpl) {
                        overHourStr = [NSString stringWithFormat:@"%.1f小时(一个工)",self.yzgGetBillModel.overtime];
                        
                    }else if (self.yzgGetBillModel.overtime *2 == self.yzgGetBillModel.set_tpl.o_h_tpl){
                        overHourStr = [NSString stringWithFormat:@"%.1f小时(半个工)",self.yzgGetBillModel.overtime];
                        
                        
                    }

                }
         
                
            }else{
            overHourStr = @"无加班";
            }
        }
            break;
    }
    
    //判断删除的账单 并且是修改账单 不显示
    if (self.yzgGetBillModel.overtime == 0 && [self.yzgGetBillModel.del_diff_tag intValue] == 1) {
        overHourStr = @"";
    }

    return overHourStr;
}

#pragma mark - 跳转工资标准界面
- (void)showSalaryTemplateVc{
    if (!self.yzgGetBillModel.name) {
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"请选择%@",self.identityString]];
        return ;
    }
    
    YZGMateSalaryTemplateViewController *mateSalaryTemplateVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"mateSalaryTemplate"];
    
    BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
    superViewIsGroup = self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)];
    mateSalaryTemplateVc.superViewIsGroup = superViewIsGroup;
    mateSalaryTemplateVc.yzgGetBillModel = self.yzgGetBillModel;
    if (superViewIsGroup) {
        [self.delegate MateGetBillPush:self ByVc:mateSalaryTemplateVc];
    }else{
        [self.navigationController pushViewController:mateSalaryTemplateVc animated:YES];
    }
}

#pragma mark - 弹出上班时间选择
- (void)showManHourPicker:(NSIndexPath *)indexPath{
    //BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl == 0 && self.yzgGetBillModel.set_tpl.o_h_tpl == 0;
    //如果没有时间, 默认值为-1  2.1.0-yj
    BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl <= 0 && self.yzgGetBillModel.set_tpl.o_h_tpl <= 0;
    if (isNoHour) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    NSInteger workHour = self.yzgGetBillModel.set_tpl.w_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.limitTime = workHour;
    timeModel.currentTime = self.yzgGetBillModel.manhour; ////传入当前的时间作为选中标记
    timeModel.endTime = 12;
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:NormalWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.manhour = timeModel.time;
        self.yzgGetBillModel.manhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self getSalary];
        [self.tableView reloadData];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}

#pragma mark - 弹出加班时间选择
- (void)showOverHourPicker:(NSIndexPath *)indexPath{
    if (self.yzgGetBillModel.set_tpl.o_h_tpl < 0) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    NSInteger overHour = self.yzgGetBillModel.set_tpl.o_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.limitTime = overHour;
    timeModel.endTime = 12.0;//2.0加班时长的选项,增至12小时(与日薪模板里的最大值无关)
    timeModel.currentTime = self.yzgGetBillModel.overtime; //传入当前的时间作为选中标记
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:OverWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.overtime = timeModel.time;
        self.yzgGetBillModel.overhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [self getSalary];
        [self.tableView reloadData];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}

- (BOOL)isAddNewProName:(NSIndexPath *)indexPath{
    BOOL isDayWork = self.accountTypeCode == 1 && (indexPath.row == self.proNameIndexPath.row && indexPath.section == self.proNameIndexPath.section);//点工
    return isDayWork;
}

#pragma mark - 懒加载
- (NSArray *)workTimeDataArray
{
    if (!_workTimeDataArray) {
        _workTimeDataArray = [[TYFMDB searchTable:TYFMDBWorkTimeName] mutableCopy];
        NSAssert(_workTimeDataArray.count != 0, @"_workTimeDataArray 读取失败");
    }
    return _workTimeDataArray;
}

- (NSArray *)workOverTimeDataArray
{
    if (!_workOverTimeDataArray) {
        _workOverTimeDataArray = [TYFMDB searchTable:TYFMDBWorkOverTimeName];
        NSAssert(_workTimeDataArray.count != 0, @"_workOverTimeDataArray 读取失败");
    }
    return _workOverTimeDataArray;
}
-(void)JLGDataPickerClickMoredayButton
{


    [self.jlgDatePickerView hiddenDatePicker];

    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController alloc]init];
    moreDay.JlgGetBillModel = self.yzgGetBillModel;
    [self.delegate MateGetBillPush:self ByVc:moreDay];

}
@end
