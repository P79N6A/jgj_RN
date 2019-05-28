//
//  JGJMoreSelectPeopleTableViewCell.m
//  mix
//
//  Created by Tony on 2017/9/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreSelectPeopleTableViewCell.h"
#import "JGJoverTimeSingerView.h"
#import "YZGMateSalaryTemplateViewController.h"
#import "JGJRecordPeopleMoreCollectionViewCell.h"
#import "JGJMoreSelectedTableTopView.h"
static NSString *markBillId = @"markBillMoreMan";

@interface JGJMoreSelectPeopleTableViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
JGJRecordPeopleMoreCollectionViewDelegate
>
{
    // 是否点击了全选按钮,默认为NO 点击了后 为YES 再次点击为NO
    BOOL _isSelectedAll;
    
    BOOL _isNotHaveSalaryModel;
    BOOL _isNotHaveAttendanceTemplate;
    BOOL _isHaveDoubleScores;// 是否未记列表里面有人已记两笔账
}

@property (nonatomic, strong) JGJMoreSelectedTableTopView *topView;
@end
@implementation JGJMoreSelectPeopleTableViewCell

- (void)awakeFromNib {
    
    _collectionview.delegate = self;
    _collectionview.allowsMultipleSelection = YES;
    _collectionview.dataSource = self;
    _collectionview.bounces = NO;
    _collectionview.showsVerticalScrollIndicator = NO;
    [_collectionview registerNib:[UINib nibWithNibName:@"JGJRecordPeopleMoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:markBillId];
    
    [super awakeFromNib];
    
    [self.contentView addSubview:self.topView];
    
    _topView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(45);
    
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = self;
    _topView.choiceAllPerson = ^(BOOL selected,UIButton *sender) {
      
        if (!strongSelf -> _isSelectedAll) {
            
            if (self.peopleArr.count < strongSelf -> _listModel.list.count) {
                
                TYLog(@"选择全部");
                for (int i = 0; i < strongSelf -> _listModel.list.count; i ++) {
                    
                    
                    if([[strongSelf -> _listModel.list[i] is_salary] intValue] != 1) {
                        
                        strongSelf -> _isNotHaveSalaryModel = YES;
                        break;
                        
                    }else {
                        
                        strongSelf -> _isNotHaveSalaryModel = NO;
                    }
                    
                }
                
                for (int i = 0; i < strongSelf -> _listModel.list.count; i ++) {
                    
                    JgjRecordMorePeoplelistModel *recordModel = weakSelf.listModel.list[i];
                    if(recordModel.unit_quan_tpl == nil || ([recordModel.unit_quan_tpl.w_h_tpl integerValue] == 0 && [recordModel.unit_quan_tpl.o_h_tpl integerValue] == 0)) {
                        
                        strongSelf -> _isNotHaveAttendanceTemplate = YES;
                        break;
                        
                    }else {
                        
                        strongSelf -> _isNotHaveAttendanceTemplate = NO;
                    }
                    
                    if (recordModel.is_double) {
                        
                        strongSelf -> _isHaveDoubleScores = YES;
                        break;
                    }else {
                        
                        strongSelf -> _isHaveDoubleScores = NO;
                    }
                    
                }
                
                if (weakSelf.isLittleWorkOrContractorAttendance) {
                    
                    if (strongSelf -> _isNotHaveSalaryModel) {
                        
                        sender.selected = NO;
                        [TYShowMessage showPlaint:@"有工人未设置点工工资标准,请先给他设置"];
                    }else {
                        
                        if (strongSelf -> _isHaveDoubleScores) {
                            
                            sender.selected = NO;
                        }
                        if ([weakSelf.delegate respondsToSelector:@selector(didSelectedAllWokerWithIsHaveChoiceAllSelected:)]) {
                            
                            [weakSelf.delegate didSelectedAllWokerWithIsHaveChoiceAllSelected:YES];
                        }

                    }
                }else {
                    
                    if (strongSelf -> _isNotHaveAttendanceTemplate) {
                        
                        sender.selected = NO;
                        [TYShowMessage showPlaint:@"有工人未设置包工记工天模板,请先给他设置"];
                        
                    }else {
                        
                        if (strongSelf -> _isHaveDoubleScores) {
                            
                            sender.selected = NO;
                        }
                        if ([weakSelf.delegate respondsToSelector:@selector(didSelectedAllWokerWithIsHaveChoiceAllSelected:)]) {
                            
                            [weakSelf.delegate didSelectedAllWokerWithIsHaveChoiceAllSelected:YES];
                        }
                        
                        
                    }
                }
                
            }
            
        }else {
            
            if ([weakSelf.delegate respondsToSelector:@selector(didSelectedAllWokerWithIsHaveChoiceAllSelected:)]) {
                
                [weakSelf.delegate didSelectedAllWokerWithIsHaveChoiceAllSelected:NO];
            }

            
        }
    };
}

- (JGJMoreSelectedTableTopView *)topView {
    
    if (!_topView) {
        
        _topView = [[JGJMoreSelectedTableTopView alloc] init];
        
    }
    return _topView;
}

- (NSMutableArray *)peopleArr{
    
    if (!_peopleArr) {
        
        _peopleArr = [NSMutableArray array];
    }
    return _peopleArr;
}

- (void)setManNum:(NSString *)manNum {
    
    _manNum = manNum;
    _topView.manNum = _manNum;
}


- (void)setMoreSelectedArr:(NSMutableArray<JgjRecordMorePeoplelistModel *> *)moreSelectedArr {

    if (!_selectedArr) {
        
        _selectedArr = [NSMutableArray array];
    }
    
    if (moreSelectedArr.count) {
        
        for (int i = 0; i < _selectedArr.count; i++) {
            
            // 判断有没有 没有再添加
            if (![self.peopleArr containsObject:_selectedArr[i]]) {
                
                [_peopleArr addObject:_selectedArr[i]];
            }
        }
        
        [_selectedArr addObjectsFromArray:moreSelectedArr];
        
    }
    
    [_collectionview reloadData];

}


-(void)setSelectedArr:(NSMutableArray<JgjRecordMorePeoplelistModel *> *)selectedArr
{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    
    if (selectedArr.count) {
        [self.peopleArr addObject:selectedArr[0]];
        
        _selectedArr = [[NSMutableArray alloc]initWithArray:_peopleArr];
        
    }
    [_collectionview reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    JGJRecordPeopleMoreCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markBillId forIndexPath:indexPath];

    cell.imageview.hidden = YES;
    
    cell.slectImageView.hidden = YES;
    
    cell.indexpath = indexPath;
    
    cell.delegate = self;
    
    for (UIView *subView in cell.contentView.subviews) {
       
        [subView removeFromSuperview];
    }
    
    [cell loadView];
    
    // 设置添加按钮
    if (indexPath.row == _listModel.list.count) {

        [cell setAddButton];
   
        cell.noTPLImageView.hidden = YES;
        
        cell.slectImageView.hidden = YES;
        
    }// 设置删除按钮
    else if (indexPath.row == _listModel.list.count + 1) {
        
        [cell setDelButton];
        
        cell.noTPLImageView.hidden = YES;
        
        cell.slectImageView.hidden = YES;
    }
    else{
        
        for (int index = 0; index < _selectedArr.count; index ++) {
            
            NSString *uidStr = [(JgjRecordMorePeoplelistModel *)_listModel.list[indexPath.row] uid];
            
            if ([[self.selectedArr[index] uid] isEqualToString:uidStr]) {
                
                [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                cell.selected = YES;
                [self selectPlaceViewAndIndexpath:indexPath andCell:cell];
 
            }
        }
        
//        cell.listModel = _listModel.list[indexPath.row];
        
        [cell setListModelAddIsLittleWork:_listModel.list[indexPath.row] isLittleWorkOrContractorAttendance:_isLittleWorkOrContractorAttendance];
    }

    return cell;
}

- (void)setIsLittleWorkOrContractorAttendance:(BOOL)isLittleWorkOrContractorAttendance {
    
    _isLittleWorkOrContractorAttendance = isLittleWorkOrContractorAttendance;
    [_collectionview reloadData];
}
// cell选中
- (void)selectPlaceViewAndIndexpath:(NSIndexPath *)indexpath andCell:(JGJRecordPeopleMoreCollectionViewCell *)cell {
    
    cell.imageview.hidden = NO;
    cell.slectImageView.hidden = NO;
    cell.imageview.alpha = .8;
    cell.slectImageView.alpha = 1;
    cell.headButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    cell.headButton.layer.borderWidth = 0.5;

}
// cell取消选中
- (void)deselectPlaceViewAndIndexpath:(NSIndexPath *)indexpath andCell:(JGJRecordPeopleMoreCollectionViewCell *)cell {
    
    cell.imageview.hidden = YES;
    cell.slectImageView.hidden = YES;
    cell.headButton.layer.borderColor = [UIColor clearColor].CGColor;
    cell.headButton.layer.borderWidth = 0.5;
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _listModel.list.count && [[_listModel.list[indexPath.row] is_salary] intValue] == 1) {//点击添加工人
        
//        JGJRecordPeopleMoreCollectionViewCell *cell = (JGJRecordPeopleMoreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        [self selectPlaceViewAndIndexpath:indexPath andCell:cell];

    }
    
    return YES;

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < _listModel.list.count) {//点击记账工人

        JgjRecordMorePeoplelistModel *recordModel = _listModel.list[indexPath.row];
        
        if ([recordModel.is_salary intValue] == 1) {
            
            JGJRecordPeopleMoreCollectionViewCell *cell = (JGJRecordPeopleMoreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [self deselectPlaceViewAndIndexpath:indexPath andCell:cell];
            [self.peopleArr removeObject:_listModel.list[indexPath.row]];
            
#pragma mark - 添加判断按钮变是否变成 全选
            if (self.peopleArr.count < _listModel.list.count) {
                
                _topView.selectedAll.selected = NO;
            }
            
#pragma mark - 临时加上下面这句话
            [self.selectedArr removeObject:_listModel.list[indexPath.row]];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(desSelectWorker:)]) {
                
                [self.delegate desSelectWorker:_listModel.list[indexPath.row]];
            }
        }else if ([recordModel.is_salary intValue] != 1) {
            
            [self setSalaryFormworkWithIndexPath:indexPath];
        }
        
        
    } // 添加
    else if (indexPath.row == _listModel.list.count){
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectAddWorkerToTeam:)]) {
        
            [self.delegate didSelectAddWorkerToTeam:indexPath];
       
        }
    
    }// 删除
    else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDelWorker)]) {
            
            [self.delegate didSelectDelWorker];
        }
    }
    return YES;
}

- (void)setCurrentRecordeTimeStr:(NSString *)currentRecordeTimeStr {
    
    _currentRecordeTimeStr = currentRecordeTimeStr;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndexpath:)]) {
        
        [self.delegate didSelectIndexpath:indexPath];
    }
    
    if (indexPath.row == _listModel.list.count) {//点击添加工人
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectAddWorkerToTeam:)]) {
            
            [self.delegate didSelectAddWorkerToTeam:indexPath];
            
        }
        
    }else if (indexPath.row == _listModel.list.count + 1) {//点击删除工人按钮
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDelWorker)]) {
            
            [self.delegate didSelectDelWorker];
        }
    }
    else{
    
        JgjRecordMorePeoplelistModel *recordModel = _listModel.list[indexPath.row];
        // 当前选择点工
        if (_isLittleWorkOrContractorAttendance) {
            
            if (recordModel.is_double) {
                
                [TYShowMessage showPlaint:[NSString stringWithFormat:@"%@",recordModel.msg.msg_text]];
                return;
            }
            // 没有工资标准 且 当前对象没有被选中，才弹出让他去设置模板, 有种情况是如果一个人有点工模板但没有包工考勤模板,先选中点工 再切换到记包工考勤时，被选中的人应该显示已被选中的类型，反之亦然！(所以加一个 recordModel.isSelected 的判断，往后人谨记！！！！！！)
            if([recordModel.is_salary intValue] != 1 && !recordModel.isSelected) {
                
                [self setSalaryFormworkWithIndexPath:indexPath];
               
            }else {
                
                //正常选中人
                [self.peopleArr insertObject:recordModel atIndex:self.peopleArr.count];
                
#pragma mark - 添加判断按钮变是否变成 全选
                if (self.peopleArr.count == _listModel.list.count) {
                    
                    _topView.selectedAll.selected = YES;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(didselectItemAndPeople:)]) {
                    
                    [self.delegate didselectItemAndPeople:self.peopleArr];
                    
                }
            }
            
            
        }
        // 包工考勤
        else {
            
            if (recordModel.is_double) {
                
                [TYShowMessage showPlaint:[NSString stringWithFormat:@"%@",recordModel.msg.msg_text]];
                return;
            }
            if ((recordModel.unit_quan_tpl == nil || ([recordModel.unit_quan_tpl.w_h_tpl integerValue] == 0 && [recordModel.unit_quan_tpl.o_h_tpl integerValue] == 0)) && !recordModel.isSelected) {
                
                [self setSalaryFormworkWithIndexPath:indexPath];
            }else {
                
                //正常选中人
                [self.peopleArr insertObject:recordModel atIndex:self.peopleArr.count];
                
#pragma mark - 添加判断按钮变是否变成 全选
                if (self.peopleArr.count == _listModel.list.count) {
                    
                    _topView.selectedAll.selected = YES;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(didselectItemAndPeople:)]) {
                    
                    [self.delegate didselectItemAndPeople:self.peopleArr];
                    
                }
            }
            
            
        }
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _listModel.list.count + 2 ;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return CGSizeMake(50, 70.5);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//
//    return 10;
//
//}

- (void)setListModel:(JGJFirstMorePeoplelistModel *)listModel {
    
    _listModel = [[JGJFirstMorePeoplelistModel alloc]init];;
    _listModel = listModel;
    if (_listModel.list.count == 0) {
        
        _topView.selectedAll.hidden = YES;
    }else {
        
        _topView.selectedAll.hidden = NO;
    }
    
    // 判断列表所有工人模型里的isSelected是否都为yes
    for (int i = 0; i < _listModel.list.count; i ++) {
        
        JgjRecordMorePeoplelistModel * peopleModel = _listModel.list[i];
        if (peopleModel.isSelected == NO) {
            
            _isSelectedAll = NO;
            break;
            
        }else {
            
            _isSelectedAll = YES;
        }
    }
    _topView.isSelctedAll = _isSelectedAll;
    [_collectionview reloadData];

}

#pragma mark - 长按编辑
- (void)JGJLongPressMoreCollectionAndIndexPath:(NSIndexPath *)indexpath {
    
    if (indexpath) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpTplAndIndexpath:)]) {
            [self.delegate jumpTplAndIndexpath:indexpath];
        }
    }
}
#pragma mark - 设置薪资模板通用方法
- (void)setSalaryFormworkWithIndexPath:(NSIndexPath *)indexPath {
    
    JgjRecordMorePeoplelistModel *recordModel = _listModel.list[indexPath.row];
    
    if (recordModel.is_double) {
        
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"%@",recordModel.msg.msg_text]];
        return;
        
    }
    
    //设置薪资模板
    typeof(self) __weak weakself = self;
    
    JGJOverTimeModel *timeModel = [JGJOverTimeModel new];
    
    timeModel.singerTpl = YES;
    
    timeModel.buttonTitle = @"马上设置";
    timeModel.blackText = YES;
    
    timeModel.redstr = [NSString stringWithFormat:@"  [%@]  ",recordModel.name];
    
    if (_isLittleWorkOrContractorAttendance) {
        
        timeModel.contentStr = [NSString stringWithFormat:@"你需要对  [%@]  设置点工工资标准后,才能开始记工。",recordModel.name];
        
    }else {
        
        timeModel.contentStr = [NSString stringWithFormat:@"你需要对  [%@]  设置包工记工天模板后,才能开始记工。",recordModel.name];
    }
    
    
    [JGJoverTimeSingerView showOverTimeViewWithModel:timeModel andClickIkwonButton:^(NSString *buttonTitle) {
        
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(jumpTplAndIndexpath:)]){
            
            [weakself.delegate jumpTplAndIndexpath:indexPath];
            
        }
    }];
}
@end
