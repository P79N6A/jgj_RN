//
//  JGJMarkBorrowBillVc.m
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMarkBorrowBillVc.h"
#import "YZGRecordWorkInputInfoTableViewCell.h"

@interface JGJMarkBorrowBillVc ()

@end

@implementation JGJMarkBorrowBillVc
- (void)dataInit{
    [super dataInit];
    
    self.proNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    self.noteIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    
  


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];//去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_account_edit_borrow_down.png"] forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
    
    
}
- (void)cellDataInit {
    NSArray *firstSectionArr = @[
                                 @[@"",@""],
                                 ];
    
    NSMutableArray *secondSectionArr;
    if (JLGisLeaderBool) {
        secondSectionArr = @[
                             @[[NSString stringWithFormat:@"选择%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]]
                             ].mutableCopy;
    }else{
        secondSectionArr = @[
                             @[[NSString stringWithFormat:@"%@",self.identityString],[NSString stringWithFormat:@"请选择要记账的%@",self.identityString]]
                             ].mutableCopy;
    }
    
    //如果是发布记账就填充时间
    if (self.markBillType != MarkBillTypeEdit) {
        [secondSectionArr insertObject:@[@"选择日期",self.yzgGetBillModel.date] atIndex:secondSectionArr.count];
    }
    [secondSectionArr insertObject:@[@"填写金额",@"这里输入借支的金额"] atIndex:secondSectionArr.count];
    
    NSArray *thirdSectionArr = @[
                                @[@"所在项目",@"例如:万科魅力之城"],
                                @[@"备注",@"可填写备注信息"]
                            ].mutableCopy;
    
    self.cellDataArray = @[firstSectionArr,secondSectionArr,thirdSectionArr].mutableCopy;
}

- (UITableViewCell *)getCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return [self configureMoneyCell:cell atIndexPath:indexPath];
        }
            break;
        case 1:
        {
            //发布记账的时候1是next,编辑记账的时候0是next
            NSInteger maxNextRowNum = (self.markBillType == MarkBillTypeEdit)?0:1;
            if (indexPath.row <= maxNextRowNum) {
                return [self configureNextVcCell:cell atIndexPath:indexPath];
            }else{
                return  [self configureInputInfoCell:cell atIndexPath:indexPath];
            }

        }
            break;
        case 2:
        {
            return [self configureNextVcCell:cell atIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)borrowingWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row) {
        [self showProjectPickerByIndexPath:indexPath];
    }else if(indexPath.section == self.noteIndexPath.section && indexPath.row == self.noteIndexPath.row){
        [self goToOtherInfoVc];
    }else if((self.markBillType != MarkBillTypeEdit) && indexPath.section == 1 && indexPath.row == 1){//发布记账的时候选择日期
        [self showDatePickerByIndexPath:indexPath];
    }
}

- (YZGRecordWorkNextVcTableViewCell *)configBorrowingNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YZGRecordWorkNextVcTableViewCell *nextVcCell= (YZGRecordWorkNextVcTableViewCell *)cell;
    
    NSString *detailString;
    UIColor *detailColor = [UIColor blackColor];
    NSString *titleStrDefault = self.cellDataArray[indexPath.section][indexPath.row][0];
    NSString *detailStrDefault = self.cellDataArray[indexPath.section][indexPath.row][1];
    
//    TYLog(@"section = %@,row = %@",@(indexPath.section),@(indexPath.row));
    switch (indexPath.section) {
        case 1:
        {
            if (indexPath.row == 0) {//姓名
                if (self.markBillType == MarkBillTypeChat || self.isChat) {
                    nextVcCell.rightImageView.hidden = self.JGJisMateBool;
                }else{
                    nextVcCell.rightImageView.hidden = (self.markBillType == MarkBillTypeEdit);
                }
                
                detailString = self.yzgGetBillModel.name;
                detailColor = [self setNameColorBy:detailString defaultStr:detailStrDefault];
            }else if((self.markBillType != MarkBillTypeEdit) && indexPath.row == 1){//发布记账的日期
                nextVcCell.rightImageView.hidden = (self.markBillType == MarkBillTypeEdit);
                detailString = self.yzgGetBillModel.date;
                detailColor = TYColorHex(0x333333);
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == self.proNameIndexPath.row) {
                detailString = self.yzgGetBillModel.proname;
            }else if(indexPath.row == self.noteIndexPath.row){
                detailString = self.yzgGetBillModel.notes_txt;
                nextVcCell.detailTFLayoutL.constant = 30;
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

- (YZGRecordWorkInputInfoTableViewCell *)configureInputInfoCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell = [YZGRecordWorkInputInfoTableViewCell cellWithTableView:self.tableView];
    
    YZGRecordWorkInputInfoTableViewCell *inpufInfoCell= (YZGRecordWorkInputInfoTableViewCell *)cell;
    
    inpufInfoCell.delegate = self;
    inpufInfoCell.indexPath = indexPath;
    [inpufInfoCell setTitle:self.cellDataArray[indexPath.section][indexPath.row][0] setDetail:self.yzgGetBillModel.salary == 0?nil:[NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary]];
    [inpufInfoCell setUnitLabel:@"元" color:nil];
    [inpufInfoCell setDetailTFPlaceholder:self.cellDataArray[indexPath.section][indexPath.row][1]];
    [inpufInfoCell setDetailColor:TYColorHex(0x92c977)];
    
    //设置数字输入带有小数点
    [inpufInfoCell setDetailIsOnlyDecimalPad];
    
    NSArray *sectionArr = self.cellDataArray[indexPath.section];
    inpufInfoCell.isLastedCell = (indexPath.row + 1) == sectionArr.count;
    return inpufInfoCell;
}

#pragma mark - baseInfoCell的delegate
- (BOOL)RecordWorkBaseInfoShouldBeginEditing:(YZGRecordWorkBaseInfoTableViewCell *)cell{
    if (!self.yzgGetBillModel.name) {
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"请选择%@",self.identityString]];
        return NO;
    }
    return YES;
}

- (void)RecordWorkBaseInfoShouldChange:(YZGRecordWorkBaseInfoTableViewCell *)cell{
    if (self.accountTypeCode == 3 || self.accountTypeCode == 4) {//借支
        NSInteger rowNum = (self.markBillType == MarkBillTypeEdit)?1:2;
        if (cell.indexPath.section == 1 && cell.indexPath.row == rowNum) {
            self.yzgGetBillModel.salary = [[cell getDetail] floatValue];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL)isAddNewProName:(NSIndexPath *)indexPath{
    BOOL isBorrowingWork = self.accountTypeCode == 3 && indexPath.section == self.proNameIndexPath.section && indexPath.row == self.proNameIndexPath.row;//借支
    return isBorrowingWork;
}
@end
