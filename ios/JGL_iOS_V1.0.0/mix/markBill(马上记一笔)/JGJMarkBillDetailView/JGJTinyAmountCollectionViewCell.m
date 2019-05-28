//
//  JGJTinyAmountCollectionViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTinyAmountCollectionViewCell.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJTime.h"

#import "IDJCalendar.h"

#import "NSDate+Extend.h"

#import "YZGAddForemanAndMateViewController.h"

#import "JGJAccountingMemberVC.h"

#define RowHeight  55

@interface JGJTinyAmountCollectionViewCell()
<
UITableViewDelegate,

UITableViewDataSource,

UIScrollViewDelegate
>
@property(nonatomic ,strong)NSArray *titleArr;

@property(nonatomic ,strong)NSArray *subTitleArr;

@property(nonatomic ,strong)NSArray *imageArr;

@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation JGJTinyAmountCollectionViewCell

- (void)awakeFromNib {

    [super awakeFromNib];

}


- (void)loadView{
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.bounces = NO;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期"],@[@"工资标准",@"上班时长",@"加班时长",@"点工工钱"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择工人":@"请添加你的班组长/工头",[self getWeekDaysString:[NSDate date]]
                           ],@[@"这里设置工资",@"",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
    self.imageArr = @[@[@"lederHeadImage",@"markCalender"],@[@"openSalary",@"workNormalTime",@"overTimeNormal",@"residueSalary"],@[@"SitPro",@"markBillremark"]];
    
    self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    
    self.tableView.tableFooterView = self.lineView;
}

- (void)setIsAgentMonitor:(BOOL)isAgentMonitor {
    
    _isAgentMonitor = isAgentMonitor;
    [self loadView];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    NSString *title;
    
    NSString *subTitle;
    
    if (_mainGo) {
        
        BOOL isCreater = [proListModel.group_info.myself_group isEqualToString:@"1"];
        
        title = isCreater ? @"工人" : @"班组长";
        
        subTitle = isCreater ? @"请选择工人" : @"请添加你的班组长/工头";
    }
    
    title = (JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长";
    
    subTitle = (JLGisLeaderBool || self.isAgentMonitor)?@"请选择工人":@"请添加你的班组长/工头";
    
    self.titleArr = @[@[title,@"日期"],@[@"工资标准",@"上班时长",@"加班时长",@"点工工钱"],@[@"所在项目",@"备注"]];
    
    self.subTitleArr = @[@[subTitle,[self getWeekDaysString:[NSDate date]]
                           ],@[@"这里设置工资",@"",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
    
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
    if (indexPath.section == 1 && indexPath.row == 3) {
        
        JGJMarkBillTextFileTableViewCell  *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:tableView];
   
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
        
        cell.textfiled.placeholder = self.subTitleArr[indexPath.section][indexPath.row];
        
        cell.textfiled.userInteractionEnabled = NO;
      
        cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
   
        [self loadDataTextfiledCellFromindexpath:indexPath fromTableViewCell:cell];

        return cell;
        
    }else{
        
   
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
        
        cell.contentLable.textColor = AppFont999999Color;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
        cell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
        
        cell.contentLable.text = self.subTitleArr[indexPath.section][indexPath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
        
        [self loadDataContentCellFromindexpath:indexPath fromTableViewCell:cell];
      
        if (indexPath.row == [self.titleArr[indexPath.section] count] - 1) {
           
            cell.lineView.hidden = YES;
       
        }else{
           
            cell.lineView.hidden = NO;
            
        }
        return cell;
    }
    
}
- (void)loadDataContentCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTinyTableViewCell *)cell
{

    if (indexpath.section == rowzero) {
        if (indexpath.row == 0) {
        
            if (![NSString isEmpty:self.yzgGetBillModel.name]) {
                
                cell.contentLable.text = self.yzgGetBillModel.name;
                cell.contentLable.textColor = AppFont333333Color;
            }
            
            if (_mainGo) {

                cell.arrowImageView.hidden = ![NSString isEmpty:self.yzgGetBillModel.name];
                cell.contentLable.textColor =  ![NSString isEmpty:self.yzgGetBillModel.name] ? AppFont999999Color: AppFont333333Color;
            }
            
        }else if (indexpath.row == 1) {
            
            cell.contentLable.textColor = AppFont333333Color;
            
            if (![NSString isEmpty:self.yzgGetBillModel.date]) {
                
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";

            }
        }
    }else if (indexpath.section == rowone){
        if (indexpath.row == 0) {
            [self setTplFromCell:cell];
        }else if (indexpath.row == 1){
            [self setManhourTimeAndCell:cell];
        }else if (indexpath.row == 2){
            [self setoverTimeAndCell:cell];
        }
        
    }else{
        if (indexpath.row == 0) {
            
            if (![NSString isEmpty:self.yzgGetBillModel.proname]) {
                
                cell.contentLable.numberOfLines = 1;
                cell.contentLable.text = self.yzgGetBillModel.proname;
                cell.contentLable.textColor = AppFont333333Color;
                if (self.markBillMore) {
                
                    cell.contentLable.textColor = AppFont999999Color;
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
                cell.contentLable.numberOfLines = 1;
                
            }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count) {
                cell.contentLable.text = @"[图片]";
                cell.contentLable.textColor = AppFont333333Color;
            }
            
        }

    }
    
}
#pragma mark - 设置薪资模板显示
- (void)setTplFromCell:(JGJMarkBillTinyTableViewCell *)cell
{

    if (self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
        cell.contentLable.textColor = AppFont333333Color;
        if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
            
            NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.w_h_tpl];
            
            w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.o_h_tpl];
            
            o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            cell.contentLable.text = [NSString stringWithFormat:@"%@小时(上班)/%@小时(加班)", w_h_tpl,o_h_tpl];

        }else{
            
            NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.w_h_tpl];
            
            w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.o_h_tpl];
            
            o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            cell.contentLable.text = [NSString stringWithFormat:@"%.2f元/个工\n%@小时(上班)/%@小时(加班)",_yzgGetBillModel.set_tpl.s_tpl, w_h_tpl,o_h_tpl];
        }
    }
    
}
#pragma mark - 设置上班是长显示
- (void)setManhourTimeAndCell:(JGJMarkBillTinyTableViewCell *)cell
{
    if (self.yzgGetBillModel.manhour >= 0) {
        
        cell.contentLable.textColor = AppFont333333Color;
        if (self.yzgGetBillModel.manhour == 0 && self.yzgGetBillModel.isRest) {
            cell.contentLable.text = @"休息";
            
        }else if (self.yzgGetBillModel.manhour == 0 && !self.yzgGetBillModel.isRest){
            
            cell.contentLable.text = @"";

        }else{
            
            NSString *unitStr;
            if (self.yzgGetBillModel.set_tpl.w_h_tpl == self.yzgGetBillModel.manhour) {
               
                unitStr = @"(1个工)";
                
            }else{
                
                // 工资标准为整数
                if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                    
                    if (self.yzgGetBillModel.manhour == self.yzgGetBillModel.set_tpl.w_h_tpl / 2) {
                        
                        unitStr = @"(半个工)";
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                }else {
                    
                    unitStr = @"";
                }
                
                
            }
            
            
            if ((int)self.yzgGetBillModel.manhour == self.yzgGetBillModel.manhour) {
                
                cell.contentLable.text = [NSString stringWithFormat:@"%.0f小时%@",self.yzgGetBillModel.manhour,unitStr];
                
            }else{
                
                cell.contentLable.text = [NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.manhour,unitStr];
                
            }
        }
        
    }
    
}
#pragma mark - 设置加班时长显示

- (void)setoverTimeAndCell:(JGJMarkBillTinyTableViewCell *)cell
{
    cell.contentLable.textColor = AppFont333333Color;

    if (self.yzgGetBillModel.overtime >= 0) {
        
        if ((self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.isOverWork) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.manhour >0) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.isRest)) {
            cell.contentLable.text = @"无加班";
        }else if (self.yzgGetBillModel.overtime == 0 && !self.yzgGetBillModel.isOverWork){
            
            cell.contentLable.text = @"";
            
        }else{
            
            NSString *unitStr;
            if (self.yzgGetBillModel.set_tpl.o_h_tpl == self.yzgGetBillModel.overtime) {
               
                unitStr = @"(1个工)";
                
            }else{
                
                // 工资标准为整数
                if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                    
                    if (self.yzgGetBillModel.overtime == self.yzgGetBillModel.set_tpl.o_h_tpl / 2) {
                        
                        unitStr = @"(半个工)";
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                }else {
                    
                    unitStr = @"";
                }
                
                
            }

            
            if ((int)self.yzgGetBillModel.overtime == self.yzgGetBillModel.overtime) {
                
                cell.contentLable.text = [NSString stringWithFormat:@"%.0f小时%@",self.yzgGetBillModel.overtime, unitStr];
                
            }else{
                
                cell.contentLable.text = [NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.overtime, unitStr];
                
            }
        }
    }else{
        
        cell.contentLable.text = @"无加班";
    }
    
}
#pragma mark - 设置金额
- (void)setSalaryFromCell:(JGJMarkBillTextFileTableViewCell *)cell
{
    
    if (![NSString isEmpty:self.yzgGetBillModel.name]) {
        
        if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
            
            cell.textfiled.text = @"-";
            
        }else{
            
            cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
        }
        
       
        cell.textfiled.textColor = AppFontEB4E4EColor;

    }

}
- (void)loadDataTextfiledCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTextFileTableViewCell *)cell
{
    
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1) {
        
        cell.lineView.hidden = YES;
    }else{
        
        cell.lineView.hidden = NO;
    }
    [self setSalaryFromCell:cell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case rowzero:
            return [self.titleArr[0] count];
            break;
        case rowone:
            return [self.titleArr[1] count];
            break;
        case rowtwo:
            return [self.titleArr[2] count];
            break;
        default:
            break;
    }
    return 0;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
    
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
            return tableView.sectionHeaderHeight;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 0 && self.markBillMore) {
        
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTinyTableViewFromIndexpath:WithModel:)]) {
        
        [self.delegate didSelectTinyTableViewFromIndexpath:indexPath WithModel:self.yzgGetBillModel];
    }
   
}
-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    if (!_yzgGetBillModel) {
        
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }
    
    _yzgGetBillModel = yzgGetBillModel;
   
    [self.tableView reloadData];
}

@end
