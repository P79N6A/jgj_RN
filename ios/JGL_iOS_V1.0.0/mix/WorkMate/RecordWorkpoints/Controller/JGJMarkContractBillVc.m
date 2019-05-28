//
//  JGJMarkContractBillVc.m
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMarkContractBillVc.h"

@interface JGJMarkContractBillVc ()

@end

@implementation JGJMarkContractBillVc

//基数，因为发布记账多一行，编辑记账少一行
static NSInteger kBorrowRowBaseNum = 0;

- (void)dataInit{
    [super dataInit];

    if (self.markBillType == MarkBillTypeEdit) {
        self.proNameIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:2 inSection:2]:[NSIndexPath indexPathForRow:0 inSection:3];
    }else{
        self.proNameIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:3 inSection:2]:[NSIndexPath indexPathForRow:0 inSection:3];
    }

    
    if (self.markBillType == MarkBillTypeEdit) {
        self.startTimeIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:0 inSection:3]:[NSIndexPath indexPathForRow:1 inSection:3];
        self.endTimeIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:1 inSection:3]:[NSIndexPath indexPathForRow:2 inSection:3];
        self.noteIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:2 inSection:3]:[NSIndexPath indexPathForRow:3 inSection:3];
    }else{
        self.noteIndexPath = JLGisLeaderBool?[NSIndexPath indexPathForRow:0 inSection:3]:[NSIndexPath indexPathForRow:1 inSection:3];
    }
    
    kBorrowRowBaseNum = (self.markBillType == MarkBillTypeEdit)?0:1;
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_account_edit_up.png"] forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
 

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];


}
- (void)cellDataInit {
    NSArray *firstSectionArr = @[
                                 @[@"",@""],
                                 ];
    
    NSMutableArray *secondSectionArr;
    if (self.markBillType == MarkBillTypeEdit) {
        secondSectionArr = @[
                            @[[NSString stringWithFormat:@"%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]],
                            @[@"分项名称",@"例如:包柱子/挂窗帘"]
                            ].mutableCopy;
    }else{
        secondSectionArr = @[
                            (JLGisLeaderBool?@[[NSString stringWithFormat:@"选择%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]]:@[[NSString stringWithFormat:@"%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]]),
                            @[@"分项名称",@"例如:包柱子/挂窗帘"]
                            ].mutableCopy;
    }
    
    NSMutableArray *thirdSectionArr;
    if (JLGisLeaderBool) {
        thirdSectionArr = @[
                            @[@"填写单价",@"这里输入单价金额"],
                            @[@"填写数量",@"这里输入数量"],
                            @[@"所在项目",@"例如:万科魅力之城"]
                            ].mutableCopy;
    }else{
        thirdSectionArr = @[
                            @[@"填写单价",@"这里输入单价金额"],
                            @[@"填写数量",@"这里输入数量"]
                            ].mutableCopy;
    }
    //如果是发布记账就填充时间
    if (self.markBillType != MarkBillTypeEdit) {
        [thirdSectionArr insertObject:@[@"选择日期",self.yzgGetBillModel.date] atIndex:0];
    }
    
    NSMutableArray *fourthSectionArr;
    
    if (self.markBillType != MarkBillTypeEdit) {
        if (JLGisLeaderBool) {
            fourthSectionArr = @[
                                 @[@"备注",@"可填写备注信息"]
                                 ].mutableCopy;
        }else{
            fourthSectionArr = @[
                                 @[@"所在项目",@"例如:万科魅力之城"],
                                 @[@"备注",@"可填写备注信息"]
                                 ].mutableCopy;
        }
    }else{
        if (JLGisLeaderBool) {
            fourthSectionArr = @[
                                 @[@"选择开工时间",@"请选择开工时间"],
                                 @[@"选择完工时间",@"请选择完工时间"],
                                 @[@"备注",@"可填写备注信息"]
                                 ].mutableCopy;
        }else{
            fourthSectionArr = @[
                                 @[@"所在项目",@"例如:万科魅力之城"],
                                 @[@"选择开工时间",@"请选择开工时间"],
                                 @[@"选择完工时间",@"请选择完工时间"],
                                 @[@"备注",@"可填写备注信息"]
                                 ].mutableCopy;
        }
    }

    self.cellDataArray = @[firstSectionArr,secondSectionArr,thirdSectionArr,fourthSectionArr].mutableCopy;
}

- (UITableViewCell *)getCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row) {
        cell =  [self configureNextVcCell:cell atIndexPath:indexPath];
    }else{
        switch (indexPath.section) {
            case 0:
            {
                cell = [self configureMoneyCell:cell atIndexPath:indexPath];
            }
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    cell = [self configureNextVcCell:cell atIndexPath:indexPath];
                }else{
                    cell = [self configureBaseInfoCell:cell atIndexPath:indexPath];
                }
            }
                break;
            case 2:
            {
                if (self.markBillType == MarkBillTypeEdit) {//编辑记账
                    cell = [self configureBaseInfoCell:cell atIndexPath:indexPath];
                }else {//发布记账
                    if (indexPath.row  == 0) {
                        cell = [self configureNextVcCell:cell atIndexPath:indexPath];
                    }else{
                        cell = [self configureBaseInfoCell:cell atIndexPath:indexPath];
                    }
                }
                
            }
                break;
            case 3:
            {
                cell = [self configureNextVcCell:cell atIndexPath:indexPath];
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)contractWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row) {
        [self showProjectPickerByIndexPath:indexPath];
    }else if(indexPath.section == self.noteIndexPath.section && indexPath.row == self.noteIndexPath.row){
        [self goToOtherInfoVc];
    }else if((self.markBillType == MarkBillTypeEdit) && indexPath.section == 3){//在编辑状态下
        if (indexPath.row == self.endTimeIndexPath.row &&([self.yzgGetBillModel.start_time isEqualToString:@"0"]||[NSString isEmpty:self.yzgGetBillModel.start_time])) {
            [TYShowMessage showPlaint:@"请选择开工时间"];
            return;
        }
        
        NSString *dateString = indexPath.row == self.startTimeIndexPath.row?self.yzgGetBillModel.start_time:self.yzgGetBillModel.end_time;
        
        BOOL dateStringIsNotExist = [dateString isEqualToString:@"0"]||[NSString isEmpty:dateString];
        
        self.jlgDatePickerView.datePicker.date = dateStringIsNotExist?[NSDate date]:[NSDate dateFromString:dateString withDateFormat:@"yyyyMMdd"];
        [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
    }else if((self.markBillType != MarkBillTypeEdit) && indexPath.section == 2 && indexPath.row == 0){//只有一种情况，包工发布记账的时候
        [self showDatePickerByIndexPath:indexPath];
    }
}

- (YZGRecordWorkNextVcTableViewCell *)configContractNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YZGRecordWorkNextVcTableViewCell *nextVcCell= (YZGRecordWorkNextVcTableViewCell *)cell;
    NSString *detailString;
    UIColor *detailColor = [UIColor blackColor];
    NSString *titleStrDefault = self.cellDataArray[indexPath.section][indexPath.row][0];
    NSString *detailStrDefault = self.cellDataArray[indexPath.section][indexPath.row][1];
    
    if (indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row) {//项目名称
        detailString = self.yzgGetBillModel.proname;
    }else {
        switch (indexPath.section) {
            case 1:
            {
                if (self.markBillType == MarkBillTypeChat || self.isChat) {
                    nextVcCell.rightImageView.hidden = self.JGJisMateBool;
                }else{
                    nextVcCell.rightImageView.hidden = (self.markBillType == MarkBillTypeEdit);
                }

                detailString = self.yzgGetBillModel.name;
                
                detailColor = [self setNameColorBy:detailString defaultStr:detailStrDefault];
            }
                break;
            case 2://只有一种情况，包工发布记账的时候
            {
                nextVcCell.rightImageView.hidden = (self.markBillType == MarkBillTypeEdit);
                detailString = self.yzgGetBillModel.date;
                detailColor = TYColorHex(0x333333);
            }
                break;
            case 3:
            {
                if (indexPath.section == self.noteIndexPath.section && indexPath.row == self.noteIndexPath.row) {//备注
                    detailString = self.yzgGetBillModel.notes_txt;
                    nextVcCell.detailTFLayoutL.constant = 30;
                }else if(indexPath.section == self.startTimeIndexPath.section && indexPath.row == self.startTimeIndexPath.row){//开工时间
                    detailString = self.yzgGetBillModel.start_timeString;
                }else if(indexPath.section == self.endTimeIndexPath.section && indexPath.row == self.endTimeIndexPath.row){//完工时间
                    detailString = self.yzgGetBillModel.end_timeString;
                }
            }
                break;
            default:
                break;
        }
    }
    
    [nextVcCell setDetailTFPlaceholder:detailStrDefault];
    [nextVcCell setTitleColor:nil setDetailColor:detailColor];
    [nextVcCell setTitle:titleStrDefault setDetail:[NSString isEmpty:detailString]?nil:detailString];
    
    return nextVcCell;
}


- (YZGRecordWorkBaseInfoTableViewCell *)configureBaseInfoCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    YZGRecordWorkBaseInfoTableViewCell *baseInfoCell= (YZGRecordWorkBaseInfoTableViewCell *)[YZGRecordWorkBaseInfoTableViewCell cellWithTableView:self.tableView];
    
    baseInfoCell.delegate = self;
    baseInfoCell.indexPath = indexPath;
    if (indexPath.section == 2) {//如果是包工，并且是"输入数量"就只能输入数字
        if (indexPath.row == (0 + kBorrowRowBaseNum)) {
            [baseInfoCell saveDataPoint:2];//价格保留两位小数
        } else if(indexPath.row == (1 + kBorrowRowBaseNum)){
            [baseInfoCell saveDataPoint:1]; //数量保留一位小数
        }
    }else{
        [baseInfoCell setDetailIsOnlyNum:NO];
    }
    
    
    NSArray *sectionArr = self.cellDataArray[indexPath.section];
    baseInfoCell.isLastedCell = (indexPath.row + 1) == sectionArr.count;
    [baseInfoCell setDetailTFPlaceholder:self.cellDataArray[indexPath.section][indexPath.row][1]];
    
    NSString *quantitiesStr = self.yzgGetBillModel.quantities == 0?nil:[NSString stringWithFormat:@"%.1f %@",self.yzgGetBillModel.quantities,self.yzgGetBillModel.units];
#pragma mark - 此处添加单位显示
    NSString *unitpriceStr = self.yzgGetBillModel.unitprice == 0?nil:[NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.unitprice];

    NSString *detailStr = [NSString string];
    if (indexPath.section == 2) {
        if (indexPath.row == (0 + kBorrowRowBaseNum)) {
            detailStr = unitpriceStr;
        } else if(indexPath.row == (1 + kBorrowRowBaseNum)){
            detailStr = quantitiesStr;
        }
    }else if(indexPath.section == 1){
        detailStr = self.yzgGetBillModel.sub_proname;
    }
    
    [baseInfoCell setTitle:self.cellDataArray[indexPath.section][indexPath.row][0] setDetail:detailStr];
    baseInfoCell.detailTF.inputAccessoryView = self.inputAccessoryView;
    return baseInfoCell;
}

#pragma mark - baseInfoCell的delegate
//按键跳转到下一个输入框的，但是每跳一次会有影响，暂时去掉
//- (void)RecordWorkBaseInfoReturn:(YZGRecordWorkBaseInfoTableViewCell *)cell{
//    NSIndexPath *indexPath = cell.indexPath;
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        YZGRecordWorkBaseInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//        [cell.detailTF becomeFirstResponder];
//    }else if(indexPath.section == 2 && indexPath.row == 0){
//        YZGRecordWorkBaseInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
//        [cell.detailTF becomeFirstResponder];
//    }
//}

- (BOOL)RecordWorkBaseInfoShouldBeginEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell{
    if (!self.yzgGetBillModel.name) {
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"请选择%@",self.identityString]];
        return NO;
    }
    
    if (self.accountTypeCode == 2) {
        if (!UseIQKeyBoardManager) {
            NSIndexPath *indexPath = cell.indexPath;
            if (indexPath.section == 2) {
                //懒得计算了，直接写死，快骂我
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CGFloat yOffset = indexPath.row == 0?220:270;
                    yOffset -= 49;
                    self.tableView.contentOffset = CGPointMake(0, yOffset);
                });
            }
        }
#pragma mark - 刘远强添加跳转到添加单位界面
        if (cell.indexPath.row == 1 &&cell.indexPath.section == 2) {
            UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
            [self.navigationController pushViewController:changeToVc animated:YES];
        }
        
    }
    return YES;
}

- (void)RecordWorkBaseInfoEndEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell detailStr:(NSString *)detailStr{
    if (self.accountTypeCode == 2) {
        [self configContractData:cell];
    }
}

- (void)RecordWorkBaseInfoShouldChange:(YZGRecordWorkBaseInfoTableViewCell *)cell{
    if (self.accountTypeCode == 2) {//包工
        [self configContractData:cell];
        
        self.yzgGetBillModel.salary = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)configContractData:(YZGRecordWorkBaseInfoTableViewCell *)cell{
    if (cell.indexPath.section == 2 && cell.indexPath.row == (0 + kBorrowRowBaseNum)) {
        self.yzgGetBillModel.unitprice = [[cell getDetail] floatValue];
    }else if (cell.indexPath.section == 2 && cell.indexPath.row == (1+kBorrowRowBaseNum)) {
        self.yzgGetBillModel.quantities = [[cell getDetail] floatValue];
    }else if(cell.indexPath.section == 1 && cell.indexPath.row == 1){
        self.yzgGetBillModel.sub_proname = [cell getDetail];
    }
}

- (BOOL)isAddNewProName:(NSIndexPath *)indexPath{
    BOOL isContractWork = self.accountTypeCode == 2 && indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row;//包工
    return isContractWork;
}

#pragma mark - 获取天蝎的单位

-(void)setFillOutModel:(JGJFilloutNumModel *)fillOutModel
{
    _fillOutModel = [JGJFilloutNumModel new];
    _fillOutModel = fillOutModel;
     self.yzgGetBillModel.quantities = [[NSString stringWithFormat:@"%@",fillOutModel.Num] floatValue];
     self.yzgGetBillModel.units = fillOutModel.priceNum;
    
     self.yzgGetBillModel.salary =  self.yzgGetBillModel.quantities *  self.yzgGetBillModel.unitprice;
    [self.tableView reloadData];

    
}
@end
