//
//  JGJContractorCollectionViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorCollectionViewCell.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "IDJCalendar.h"

#import "NSDate+Extend.h"

#import "JGJWaringMarkBillTableViewCell.h"
#define RowHeight  55
@interface JGJContractorCollectionViewCell()
<
UITableViewDelegate,

UITableViewDataSource,

UIScrollViewDelegate,

JGJMarkBillTextFileTableViewCellDelegate
>
@property(nonatomic ,strong)NSArray *titleArr;

@property(nonatomic ,strong)NSArray *subTitleArr;

@property(nonatomic ,strong)NSArray *imageArr;

@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic, strong) UIView *lineView;

@end
@implementation JGJContractorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadView];
}

- (void)loadView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.bounces = NO;

    self.titleArr = @[@[JLGisLeaderBool?@"工人":@"班组长",@"日期",@""],@[@"分项名称",@"填写单价",@"填写数量",@"包工工钱"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[JLGisLeaderBool?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]],@""],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
    self.imageArr = @[@[@"lederHeadImage",@"markCalender",@""],@[@"subProTitle",@"openSalary",@"writeNumber",@"residueSalary"],@[@"SitPro",@"markBillremark"]];
    
    self.tableView.tableFooterView = self.lineView;

}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    NSString *title = JLGisLeaderBool?@"工人":@"班组长";

    NSString *subTitle = JLGisLeaderBool?@"请选择要记账的工人":@"请选择要记账的班组长/工头";
    
    if (_mainGo) {
        
        BOOL isCreater = [proListModel.group_info.myself_group isEqualToString:@"1"];
        
        title = isCreater ? @"工人" : @"班组长";
        
        subTitle = isCreater ? @"请选择要记账的工人" : @"请选择要记账的班组长/工头";
    }
    
    self.titleArr = @[@[title,@"日期",@""],@[@"分项名称",@"填写单价",@"填写数量",@"包工工钱"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[subTitle,[self getWeekDaysString:[NSDate date]],@""],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
    [self.tableView reloadData];
    
}

//设置底部那条灰色的间隔线
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        _lineView.backgroundColor = AppFontf1f1f1Color;
    }
    return _lineView;
}
- (IDJCalendar *)calendar {
    if (!_calendar) {
        _calendar = [IDJCalendar new];
    }
    return _calendar;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        
        JGJMarkBillTextFileTableViewCell  *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:tableView];
        
        cell.titleWidth.constant = 100;
        
        [self loadDataTextfiledCellFromindexpath:indexPath fromTableViewCell:cell];
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2)//后期需求价格动画页面
    {
        JGJWaringMarkBillTableViewCell  *cell = [JGJWaringMarkBillTableViewCell cellWithTableView:tableView];
        if ([self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0) {
            
            cell.contentView.hidden = YES;
        }else{
            
            cell.contentView.hidden = NO;
        }
        cell.contentLable.text = self.yzgGetBillModel.bill_desc?:@"";
        
        return cell;
        
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
        
        cell.contentLable.text = self.subTitleArr[indexPath.section][indexPath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
        
        [self loadDataContentCellFromindexpath:indexPath fromTableViewCell:cell];
        return cell;
    }
    
}
- (void)loadDataContentCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTinyTableViewCell *)cell
{
    //最后一行时隐藏那条分割线
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1 || (indexpath.section == 0 && indexpath.row == 1)) {
        cell.lineView.hidden = YES;
    }else{
        
        cell.lineView.hidden = NO;
    }
    
    if (indexpath.section == 0) {
        
        if (indexpath.row == 0) {
            if (![NSString isEmpty:self.yzgGetBillModel.name]) {
                cell.contentLable.textColor = AppFont333333Color;
                cell.contentLable.text = self.yzgGetBillModel.name;
            }
            if (_mainGo) {
                
//                注释聊天进来能选择人员颜色，箭头修改(3.0.0yj添加)
                cell.arrowImageView.hidden = NO;
                cell.contentLable.textColor =  [NSString isEmpty:self.yzgGetBillModel.name] ? AppFont999999Color: AppFont333333Color;
            }
        }else if (indexpath.row == 1){
            cell.contentLable.textColor = AppFont333333Color;

            if (![NSString isEmpty:self.yzgGetBillModel.date]) {
                cell.contentLable.text = self.yzgGetBillModel.date;

            }
        }
    }else if (indexpath.section == 1){
        
        
    }else{
        
        if (indexpath.row == 0) {
            
            if (![NSString isEmpty:self.yzgGetBillModel.proname]) {
                
                cell.contentLable.text = self.yzgGetBillModel.proname;
                cell.contentLable.textColor = AppFont333333Color;
                
                if (self.markBillMore) {
                    
                    cell.contentLable.textColor = AppFont999999Color;
                }
                if (self.yzgGetBillModel.pid == 0) {
                    
                    cell.contentLable.text = @"";
                }
            }
        }else{
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                cell.contentLable.text = self.yzgGetBillModel.notes_txt;
                cell.contentLable.textColor = AppFont333333Color;
                
            }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count){
                cell.contentLable.text = @"[图片]";
                cell.contentLable.textColor = AppFont333333Color;
            }
            
        }
    }
}


- (void)loadDataTextfiledCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTextFileTableViewCell *)cell
{
 
    //最后一行时隐藏那条分割线
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1) {
        
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLable.text = self.titleArr[indexpath.section][indexpath.row];
    
    cell.textfiled.placeholder = self.subTitleArr[indexpath.section][indexpath.row];
    cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexpath.section][indexpath.row]];
    
    
    cell.maxLength = 6;
    if (indexpath.row == 0) {

        cell.numberType = JGJStrKeyBoardType;

        cell.textfiled.textColor = AppFont333333Color;
        cell.textfiled.text = self.yzgGetBillModel.sub_proname;;

    }else if (indexpath.row == 1){
        
        cell.numberType = JGJNumberKeyBoardType;
        cell.textfiled.textColor = AppFontEB4E4EColor;
        
        if (self.yzgGetBillModel.unitprice > 0) {
        
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.unitprice];
            cell.textfiled.font = [UIFont boldSystemFontOfSize:17];
            
        }
    }else if (indexpath.row == 2){
        cell.showMoreButton = YES;
        cell.numberType = JGJNumberKeyBoardType;

        if (self.yzgGetBillModel.quantities > 0 && ![NSString isEmpty:self.yzgGetBillModel.units]) {
            cell.textfiled.textColor = AppFont333333Color;
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f %@",_yzgGetBillModel.quantities,_yzgGetBillModel.units];
        }
    }else{

        cell.numberType = JGJNumberKeyBoardType;
        if (self.yzgGetBillModel.salary != 0) {
            
            cell.textfiled.textColor = AppFontEB4E4EColor;
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
            cell.textfiled.font = [UIFont boldSystemFontOfSize:17];


        }

    }
    
    cell.textfiled.tag = indexpath.row;
    
    cell.delegate = self;
    
    if ([NSString isEmpty: self.yzgGetBillModel.name ]) {
        cell.textfiled.userInteractionEnabled = NO;
    }else{
        cell.textfiled.userInteractionEnabled = YES;
        
    }
    if ((indexpath.section == 1 && indexpath.row == 2) || (indexpath.section == 1 && indexpath.row == 3)) {
        cell.textfiled.userInteractionEnabled = NO;

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.titleArr[section] count];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    UIView *headerView = [[UIView alloc]init];
    [headerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
    upLine.backgroundColor = AppFontdbdbdbColor;
    [headerView addSubview:upLine];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5)];
    downLine.backgroundColor = AppFontdbdbdbColor;
    [headerView addSubview:downLine];
    return headerView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
    return tableView.sectionFooterHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return CGFLOAT_MIN;
            return tableView.sectionFooterHeight;
            break;
        case 1:
            return 10;
            
            break;
        case 2:
            return 10;
            
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0 && indexPath.section == 0 && indexPath.row == 2 ) {
        return 0;
    }else if ([self.yzgGetBillModel.bill_num floatValue] > 0&& indexPath.section == 0 && indexPath.row == 2 ){
        return 40;
    }
    return RowHeight;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy-MM-dd"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    NSDate *curDate = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    self.calendar.year = [NSString stringWithFormat:@"%@", @(curDate.components.year)];
    self.calendar.month = [NSString stringWithFormat:@"%@", @(curDate.components.month)];
    self.calendar.day = [NSString stringWithFormat:@"%@", @(curDate.components.day)];
    //如果是今天要显示
    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    
    return dateString;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
    
}
- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    if (!_yzgGetBillModel) {
        
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }
    _yzgGetBillModel = yzgGetBillModel;
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1 && indexPath.row ==0) ||(indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 2)) {
        
        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }
 
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectContractTableViewFromIndexpath:WithModel:)]) {
        [self.delegate didSelectContractTableViewFromIndexpath:indexPath WithModel:self.yzgGetBillModel];
    }
    
}
-(void)JGJMarkBillTextFileEditingText:(NSString *)text WithTag:(NSInteger)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledContractEditing:andTag:)]) {
        [self.delegate textFiledContractEditing:text andTag:tag];
    }
    
}
-(void)JGJMarkBillWillBeginTextFilEditing
{
//    if ([NSString isEmpty: self.yzgGetBillModel.name ]) {
//        [TYShowMessage showPlaint:@"请先选择记账对象"];
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self endEditing:YES];
////        });
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textfiledContractWillBeginEting)]) {
        [self.delegate textfiledContractWillBeginEting];
    }
    
}
@end
