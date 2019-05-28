//
//  JGJBrrowCollectionViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBrrowCollectionViewCell.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "IDJCalendar.h"

#import "NSDate+Extend.h"

#import "JGJWaringMarkBillTableViewCell.h"
#define RowHeight  55
@interface JGJBrrowCollectionViewCell()
<
UITableViewDelegate,

UITableViewDataSource,

UIScrollViewDelegate,

JGJMarkBillTextFileTableViewCellDelegate
>

{
    
    JGJMarkBillTextFileTableViewCell  *TextFileCell;
}
@property(nonatomic ,strong)NSArray *titleArr;

@property(nonatomic ,strong)NSArray *subTitleArr;

@property(nonatomic ,strong)NSArray *imageArr;

@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JGJBrrowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setIsAgentMonitor:(BOOL)isAgentMonitor {
    
    _isAgentMonitor = isAgentMonitor;
    [self loadView];
}
- (void)loadView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.bounces = NO;

    self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期",@""],@[@"填写金额"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]],@""],@[@"这里输入金额"],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
    self.imageArr = @[@[@"lederHeadImage",@"markCalender",@""],@[@"openSalary"],@[@"SitPro",@"markBillremark"]];
    
    self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];

    self.tableView.tableFooterView = self.lineView;

}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    NSString *title = (JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长";
    
    NSString *subTitle = (JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头";
    
//    if (_mainGo) {
//
//        BOOL isCreater = [proListModel.group_info.myself_group isEqualToString:@"1"];
//
//        title = isCreater ? @"工人" : @"班组长";
//
//        subTitle = isCreater ? @"请选择要记账的工人" : @"请选择要记账的班组长/工头";
//    }
    
    self.titleArr = @[@[title,@"日期",@""],@[@"填写金额"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[subTitle,[self getWeekDaysString:[NSDate date]],@""],@[@"这里输入金额"],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
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
    if (indexPath.section == 1) {
        
        TextFileCell = [JGJMarkBillTextFileTableViewCell cellWithTableView:tableView];
        
        TextFileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TextFileCell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
        
        TextFileCell.textfiled.placeholder = self.subTitleArr[indexPath.section][indexPath.row];
                
        TextFileCell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
        
        [self loadDataTextfiledCellFromindexpath:indexPath fromTableViewCell:TextFileCell];
        
        return TextFileCell;
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
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1|| (indexpath.section == 0 && indexpath.row == 1)) {
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
             
                //  注释聊天进来能选择人员颜色，箭头修改(3.0.0yj添加)
                cell.arrowImageView.hidden = ![NSString isEmpty:self.yzgGetBillModel.name];
                cell.contentLable.textColor =  ![NSString isEmpty:self.yzgGetBillModel.name] ? AppFont999999Color: AppFont333333Color;
             
            }
   
        }else if (indexpath.row == 1){
      
            cell.contentLable.textColor = AppFont333333Color;
        
            if (![NSString isEmpty:self.yzgGetBillModel.date]) {
          
                cell.contentLable.text = self.yzgGetBillModel.date;
            }
        }
    }else if (indexpath.section == 2){
        
        if (indexpath.row == 0) {
            
            if (![NSString isEmpty:self.yzgGetBillModel.proname]) {
                
                cell.contentLable.numberOfLines = 1;
                cell.contentLable.text = self.yzgGetBillModel.proname;
                cell.contentLable.textColor = AppFont333333Color;
                if (self.markBillMore || self.isAgentMonitor) {
                    
                    cell.contentLable.textColor = AppFont999999Color;
                    
                }
                
                if (self.isAgentMonitor || self.markBillMore) {
                    
                    cell.arrowImageView.hidden = YES;
                }else {
                    
                    cell.arrowImageView.hidden = NO;
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
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
        
    }
    
    cell.textfiled.tag = 10;
    
    cell.maxLength = 6;
    
    cell.numberType = JGJNumberKeyBoardType;
    
    cell.textfiled.textColor = AppFonte83c76eColor;
    
    cell.delegate = self;
    

    if (self.yzgGetBillModel.browNum > 0 ) {
        cell.textfiled.font = [UIFont boldSystemFontOfSize:15];

        cell.textfiled.text = self.yzgGetBillModel.browNum;;

    }
    
    if ([NSString isEmpty: self.yzgGetBillModel.name ]) {
        cell.textfiled.userInteractionEnabled = NO;
    }else{
        cell.textfiled.userInteractionEnabled = YES;
        
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    _yzgGetBillModel = yzgGetBillModel;
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isAgentMonitor || self.markBillMore) {
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            return;
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }
//    if (indexPath.section == 2 && indexPath.row == 0 && self.markBillMore) {
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBrrowTableViewFromIndexpath:WithModel:)]) {
        [self.delegate didSelectBrrowTableViewFromIndexpath:indexPath WithModel:self.yzgGetBillModel];
    }
}
-(void)JGJMarkBillTextFileEditingText:(NSString *)text WithTag:(NSInteger)tag
{
    if (tag == 10) {
        TextFileCell.textfiled.font = [UIFont boldSystemFontOfSize:15];
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledBrrowEditing:andTag:)]) {
        [self.delegate textFiledBrrowEditing:text andTag:tag];
    }
    
}
-(void)JGJMarkBillWillBeginTextFilEditing
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textfiledBrrowWillBeginEting)]) {
        [self .delegate textfiledBrrowWillBeginEting];
    }
}
@end
