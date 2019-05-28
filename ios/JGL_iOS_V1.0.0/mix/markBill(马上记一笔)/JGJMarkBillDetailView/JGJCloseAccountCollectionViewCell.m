//
//  JGJCloseAccountCollectionViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCloseAccountCollectionViewCell.h"

#import "IDJCalendar.h"

#import "NSDate+Extend.h"

#import "JGJMarkBillTextFileTableViewCell.h"

#import "JGJMarkBillTinyTableViewCell.h"

#import "JGJCloseAccountTwoImageTableViewCell.h"

#import "JGJWaringSuggustTableViewCell.h"

#import "JGJCloseAccountOpenTableViewCell.h"

#import "JGJCloseAccountMoreTableViewCell.h"

#import "JGJQustionShowView.h"

#import "UILabel+GNUtil.h"

#import "JGJWaringMarkBillTableViewCell.h"

#define RowHeight  55

#define headerHeight 10

@interface JGJCloseAccountCollectionViewCell()
<
UITableViewDelegate,

UITableViewDataSource,

UIScrollViewDelegate,

JGJWaringSuggustTableViewCellDelegate,

JGJMarkBillTextFileTableViewCellDelegate
>{
    
    BOOL _isEditeCurrentReciveMoney;
    
}
@property(nonatomic ,strong)NSArray *nowTitleArr;


@property(nonatomic ,strong)NSArray *titleArr;

@property(nonatomic ,strong)NSArray *subTitleArr;

@property(nonatomic ,strong)NSArray *nowSubTitleArr;

@property(nonatomic ,strong)NSArray *imageArr;

@property(nonatomic ,strong)NSArray *nowImageArr;

@property(nonatomic ,strong)NSArray *openTitleArr;

@property(nonatomic ,strong)NSArray *openSubTitleArr;

@property(nonatomic ,strong)NSArray *openImageArr;

@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic, strong) UIView *lineView;

@end
@implementation JGJCloseAccountCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setIsAgentMonitor:(BOOL)isAgentMonitor {
    
    _isAgentMonitor = isAgentMonitor;
    [self loadView];
}

- (void)loadView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;

    self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期",@""]
                      ,@[@"未结工资",@""]
                      ,@[@"补贴 、奖励 、罚款",@"补贴金额(+)",@"奖励金额(+)",@"罚款金额(-)"]
                      ,@[(JLGisLeaderBool || self.isAgentMonitor)?@"本次实付金额":@"本次实收金额",@"抹零金额",@"本次结算金额"]
                      ,@[@"剩余未结金额"],@[@"所在项目",@"备注"]];
    self.openTitleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期",@""]
                          ,@[@"未结工资",@[@""]]
                          ,@[@"补贴 、奖励 、罚款"]
                          ,@[(JLGisLeaderBool || self.isAgentMonitor)?@"本次实付金额":@"本次实收金额",@"抹零金额",@"本次结算金额"]
                          ,@[@"剩余未结金额"]
                          ,@[@"所在项目",@"备注"]];
    
    
  
    self.subTitleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]],@""]
                       ,@[@"",@""]
                       ,@[@"",@"请输入金额(可不填)",@"请输入金额(可不填)",@"请输入金额(可不填)"]
                       ,@[@"请输入金额",@"请输入金额(可不填)",@""]
                       ,@[@""]
                       ,@[@"可不填",@"可填写备注信息"]];
    
    
    self.openSubTitleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",[self getWeekDaysString:[NSDate date]],@""]
                             ,@[@"",@""]
                             ,@[@""]
                             ,@[@"",@"",@""]
                             ,@[@""]
                             ,@[@"可不填",@"可填写备注信息"]];
    
    
    self.imageArr = @[@[@"lederHeadImage",@"markCalender",@""],
                    @[@"openSalary",@"garyPlaint"],
                    @[@"fine"],
                    @[@"nowPaySalary",@"countSmall",@"monyImage"],
                    @[@"residueSalary"],
                    @[@"SitPro",@"markBillremark"]];
    
    
    
    self.openImageArr = @[@[@"lederHeadImage",@"markCalender",@""]
                          ,@[@"openSalary",@"garyPlaint"]
                          ,@[@"fine",@"",@"",@""]
                          ,@[@"nowPaySalary",@"countSmall",@"monyImage"]
                          ,@[@"residueSalary"]
                          ,@[@"SitPro",@"markBillremark"]];
    

    self.nowTitleArr = [[NSArray alloc]initWithArray:self.titleArr];
    self.nowImageArr = [[NSArray alloc]initWithArray:self.imageArr];
    self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.subTitleArr];
    
    self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];

    self.tableView.tableFooterView = self.lineView;

    // 进入结算页面 交互说明：“补贴、奖励、罚款”选项默认收起 3.1.0v cc加
    self.nowTitleArr = [[NSArray alloc]initWithArray:self.openTitleArr];
    self.nowImageArr = [[NSArray alloc]initWithArray:self.openImageArr];
    self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.openSubTitleArr];
    
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
    [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    NSString *title = (JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长";
    
    NSString *subTitle = (JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头";
    
    if (_mainGo) {
        
        BOOL isCreater = [proListModel.group_info.myself_group isEqualToString:@"1"];
        
        title = isCreater ? @"工人" : @"班组长";
        
        subTitle = isCreater ? @"请选择要记账的工人" : @"请选择要记账的班组长/工头";
    }
    
    self.titleArr = @[@[title,@"日期",@""],
                      @[@"未结工资",@""],
                      @[@"补贴 、奖励 、罚款",@"补贴金额(+)",@"奖励金额(+)",@"罚款金额(-)"],
                      @[(JLGisLeaderBool || self.isAgentMonitor)?@"本次实付金额":@"本次实收金额",@"抹零金额",@"本次结算金额"],
                      @[@"剩余未结金额"]
                      ,@[@"所在项目",@"备注"]];
    

    self.subTitleArr = @[@[subTitle,[self getWeekDaysString:[NSDate date]],@""]
                         ,@[@"",@""]
                         ,@[@"",@"请输入金额(可不填)",@"请输入金额(可不填)",@"请输入金额(可不填)"]
                         ,@[@"请输入金额",@"请输入金额(可不填)",@""]
                         ,@[@""]
                         ,@[@"可不填",@"可填写备注信息"]];
    

    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        JGJWaringSuggustTableViewCell  *cell = [JGJWaringSuggustTableViewCell cellWithTableView:tableView];
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([NSString isEmpty:self.yzgGetBillModel.name]|| [self.yzgGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {
            
            cell.contentView.hidden = YES;
            
        }else{
            cell.contentView.hidden = NO;;

            cell.contentLable.text = self.yzgGetBillModel.salary_desc?:@"";

            [cell.contentLable markText:[NSString stringWithFormat:@"%@笔",self.yzgGetBillModel.un_salary_tpl?:@"0"] withColor:AppFontEB4E4EColor];
        }
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
        
    }else if ((indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 2)|| (indexPath.section == 4 && indexPath.row == 0)){
        
        JGJCloseAccountTwoImageTableViewCell  *cell = [JGJCloseAccountTwoImageTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self loadCloseAccountHaveQuestionMarkFromindexpath:indexPath fromtableviewCell:cell];
        
        return cell;
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
        
            JGJCloseAccountOpenTableViewCell *cell = [JGJCloseAccountOpenTableViewCell cellWithTableView:tableView];
        
            [self loadTwoImageTextfiledCellFromindexpath:indexPath fromTableViewCell:cell];
        
            return cell;
            
        }else{
       
            JGJMarkBillTextFileTableViewCell *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:tableView];
        
            cell.headImageView.hidden = YES;
        
            cell.textfiled.tag = 20 + indexPath.row;
            
            cell.textfiledRightConstance.constant = 50;
            
            cell.titleWidth.constant = 80;
            if (indexPath.row == 1 || indexPath.row == 2 ) {
               
                cell.leftLineConstance.constant = 50;
            }

            [self loadCloseAccountSalaryTextfiledfromIndexpath:indexPath FromTableviewcell:cell];
            
            return cell;
        }

    }else if (indexPath.section == 3|| indexPath.section == 4){
        
        if ((indexPath.section == 3 && indexPath.row == 0 )||( indexPath.section == 3 && indexPath.row == 1)) {
            
            JGJMarkBillTextFileTableViewCell *cell = [JGJMarkBillTextFileTableViewCell cellWithTableView:tableView];
            
            cell.textfiled.tag = 40 + indexPath.row;
            
            [self loadCloseAccountMainSalaryTextfiledfromIndexpath:indexPath FromTableviewcell:cell];
            
            return cell;
            
        }else{
           
            JGJCloseAccountMoreTableViewCell *cell = [JGJCloseAccountMoreTableViewCell cellWithTableView:tableView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLable.text = self.nowTitleArr[indexPath.section][indexPath.row];
            
            cell.contentLable.text = self.nowSubTitleArr[indexPath.section][indexPath.row];
            
            cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexPath.section][indexPath.row]];
            
            [self loadCloseMoreDataCellFromindexpath:indexPath fromTableViewCell:cell];
            return cell;
        }
        
    }else{
        
        JGJMarkBillTinyTableViewCell *cell = [JGJMarkBillTinyTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLable.text = self.nowTitleArr[indexPath.section][indexPath.row];
        
        cell.contentLable.text = self.nowSubTitleArr[indexPath.section][indexPath.row];
        
        cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexPath.section][indexPath.row]];
        
        [self loadDataContentCellFromindexpath:indexPath fromTableViewCell:cell];
        return cell;
    }
    
}
#pragma mark - 常规显示
- (void)loadDataContentCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJMarkBillTinyTableViewCell *)cell
{
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1) {
        
        cell.lineView.hidden = YES;
    }else{
       
        cell.lineView.hidden = NO;
        if (indexpath.row == 1 && indexpath.section == 0) {
        
            cell.lineView.hidden = YES;
        }
    }
 
    
    if (indexpath.section == 0) {
        if (indexpath.row == 0) {
            if (![NSString isEmpty:self.yzgGetBillModel.name]) {
                cell.contentLable.text = self.yzgGetBillModel.name;
                cell.contentLable.textColor = AppFont333333Color;
                
            }
            if (_mainGo) {
                
                //  注释聊天进来能选择人员颜色，箭头修改(3.0.0yj添加)
                cell.arrowImageView.hidden = ![NSString isEmpty:self.yzgGetBillModel.name];
                cell.contentLable.textColor =  ![NSString isEmpty:self.yzgGetBillModel.name] ? AppFont999999Color: AppFont333333Color;
                
            }
        }else if (indexpath.row == 1) {
            
            cell.contentLable.textColor = AppFont333333Color;
            
            if (![NSString isEmpty:self.yzgGetBillModel.date]) {
                cell.contentLable.text = self.yzgGetBillModel.date?:@"";
                
            }
        }
   
    }else if (indexpath.section == 1){
        if (indexpath.row == 0) {
            cell.arrowImageView.hidden = YES;
            cell.rightConstance.constant = 0;
        }
    }else if(indexpath.section == 5){
        
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
                
            }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count) {
                
                cell.contentLable.text = @"[图片]";
                cell.contentLable.textColor = AppFont333333Color;
            }
            
        }
    }
    
}
#pragma mark 展开收拢
- (void)loadTwoImageTextfiledCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJCloseAccountOpenTableViewCell *)cell
{

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    
    cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
    
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    if (![NSString isEmpty:self.yzgGetBillModel.totalCalculation]) {
        
        cell.contentLable.text = self.yzgGetBillModel.totalCalculation;
    }
    if (indexpath.row != 0) {
        
        cell.subImageView.hidden = YES;
        cell.titleLable.font = [UIFont systemFontOfSize:15];

    }else{
        
        cell.subImageView.hidden = NO;
        cell.contentLable.textColor = AppFont000000Color;
        cell.titleLable.font = [UIFont systemFontOfSize:15];

        if ([self.nowTitleArr[indexpath.section] count] >1) {
            
            cell.subImageView.image = [UIImage imageNamed:@"new_arrow_up"];
            
        }else{
            // arrow_down
            cell.subImageView.image = [UIImage imageNamed:@"arrow_down"];
        }
    }
}
#pragma mark -标题比较长的
- (void)loadCloseMoreDataCellFromindexpath:(NSIndexPath *)indexpath fromTableViewCell:(JGJCloseAccountMoreTableViewCell *)cell
{
    
    
}
#pragma mark - 补贴奖励罚款输入框
- (void)loadCloseAccountSalaryTextfiledfromIndexpath:(NSIndexPath *)indexpath FromTableviewcell:(JGJMarkBillTextFileTableViewCell *)cell
{
    if ([NSString isEmpty:self.yzgGetBillModel.name]) {
        
        cell.textfiled.userInteractionEnabled = NO;
    }else{
        
        cell.textfiled.userInteractionEnabled = YES;
    }
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    cell.textfiled.placeholder = self.nowSubTitleArr[indexpath.section][indexpath.row];
    cell.titleLable.font = [UIFont systemFontOfSize:14];
    cell.textfiled.font = [UIFont systemFontOfSize:14];
    cell.textfiled.textColor = AppFont333333Color;
    cell.leftConstance.constant = 12;
    cell.maxLength = 8;
    cell.numberType = JGJNumberKeyBoardType;
    cell.delegate = self;
    if (indexpath.row == 1) {
        if (![NSString isEmpty: self.yzgGetBillModel.subsidy_amount ]) {
            cell.textfiled.text = self.yzgGetBillModel.subsidy_amount;
        }
    }else if(indexpath.row == 2){
        
        if (![NSString isEmpty: self.yzgGetBillModel.reward_amount ]) {
            cell.textfiled.text = self.yzgGetBillModel.reward_amount;
        }
    }else if(indexpath.row == 3){
        
        if (![NSString isEmpty: self.yzgGetBillModel.penalty_amount]) {
            cell.textfiled.text = self.yzgGetBillModel.penalty_amount;
        }
    }
    
}
#pragma mark - 初始化有问号的cell
- (void)loadCloseAccountHaveQuestionMarkFromindexpath:(NSIndexPath *)indexpath fromtableviewCell:(JGJCloseAccountTwoImageTableViewCell *)cell{
    //最后一行时隐藏那条分割线
    if (indexpath.row == [self.nowTitleArr[indexpath.section] count] - 1 || (indexpath.section == 1 && indexpath.row == 0)) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
        
    }
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
    
    cell.contentLable.text = self.nowSubTitleArr[indexpath.section][indexpath.row];
    
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    if (indexpath.section == 1) {
        cell.questionBtn.tag = 0;
    }else if (indexpath.section == 3){
        cell.questionBtn.tag = 1;
    }else if (indexpath.section == 4){
        cell.questionBtn.tag = 2;
    }
    [cell.questionBtn addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    if (indexpath.row == 0 && indexpath.section == 1) {
    
        cell.contentLable.textColor = AppFont000000Color;
        cell.titleLable.font = [UIFont systemFontOfSize:15];
        cell.contentLable.text = self.yzgGetBillModel.balance_amount?:@"";
        
        //0.00不显示3.0.0yj添加
//        if ([cell.contentLable.text isEqualToString:@"0.00"]) {
//
//            cell.contentLable.text = @"";
//        }
        
        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
            cell.contentView.hidden = YES;
        }else{
            cell.contentView.hidden = NO;
        }
    }else if (indexpath.section == 3 && indexpath.row == 2){

        cell.contentView.hidden = YES;
        cell.contentLable.textColor = AppFont999999Color;
        
        cell.contentLable.text = self.yzgGetBillModel.settlementAmount;
        
    }else if (indexpath.section == 4 && indexpath.row == 0){
#pragma mark - 剩余未结金额

        cell.contentView.hidden = YES;
        cell.contentLable.textColor = AppFont999999Color;

        cell.contentLable.text = self.yzgGetBillModel.remainingAmount;

    }
}
#pragma mark - 本次结算金额 抹零金额
- (void)loadCloseAccountMainSalaryTextfiledfromIndexpath:(NSIndexPath *)indexpath FromTableviewcell:(JGJMarkBillTextFileTableViewCell *)cell
{
    
    if ([NSString isEmpty:self.yzgGetBillModel.name]) {
        cell.textfiled.userInteractionEnabled = NO;
    }else{
        cell.textfiled.userInteractionEnabled = YES;
    }
    if (indexpath.row == [self.titleArr[indexpath.section] count] - 1 || indexpath.row == [self.titleArr[indexpath.section] count] - 2) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;

    }
    
    cell.titleLable.text = self.nowTitleArr[indexpath.section][indexpath.row];
//    cell.textfiled.placeholder = self.nowSubTitleArr[indexpath.section][indexpath.row];
    if (indexpath.row == 0) {
        
        if (!_isEditeCurrentReciveMoney) {
            
            cell.textfiled.placeholder = @"请输入金额";
            
        }else {
            
            if (_editeMoney == 0) {
                
                cell.textfiled.placeholder = @"请输入金额";
            }else {
                
                cell.textfiled.text = [NSString stringWithFormat:@"%.2f",_editeMoney];
            }
            
        }

    }else {
        
        cell.textfiled.placeholder = @"请输入金额(可不填)";
    }
    cell.headImageView.image = [UIImage imageNamed:self.nowImageArr[indexpath.section][indexpath.row]];
    cell.titleLable.font = [UIFont systemFontOfSize:15];

    if (indexpath.section == 3) {
        cell.titleLable.font = [UIFont boldSystemFontOfSize:15];

    }
    cell.maxLength = 8;
    cell.numberType = JGJStrKeyBoardType;
    cell.delegate = self;
    
    if (indexpath.section == 3) {
        if (indexpath.row == 0) {
            if (self.yzgGetBillModel.salary != 0) {
                
//                cell.textfiled.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
                
//                //未结工资是0不显示(3.0.0yj添加)
                
                if ([NSString isFloatZero:self.yzgGetBillModel.salary]) {

                    
                    cell.textfiled.text = @"";
                }
                
            }
            cell.textfiled.font = [UIFont boldSystemFontOfSize:15];

        }else if (indexpath.row == 1){
            
            cell.titleLable.font = [UIFont systemFontOfSize:15];

            cell.textfiled.textColor = AppFont333333Color;
            if ([self.yzgGetBillModel.deduct_amount?:@"0" floatValue] >= 0) {

                cell.textfiled.text = self.yzgGetBillModel.deduct_amount?:@"";
            }
            
            //3.0.0yj添加
            if ([self.yzgGetBillModel.deduct_amount isEqualToString:@"0.00"]) {
                
                cell.textfiled.text = nil;
            }
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case sectionZero:
            return [self.nowTitleArr[0] count];
            break;
        case sectionOne:
            return [self.nowTitleArr[1] count];
            break;
        case sectionTwo:
            return [self.nowTitleArr[2] count];
            break;
        case sectionThree:
            return [self.nowTitleArr[3] count];
            break;
        case sectionFour:
            return [self.nowTitleArr[4] count];
            break;
        case sectionFive:
            return [self.nowTitleArr[5] count];
            break;
        default:
            break;
    }
    return 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endEditing:YES];
    [JGJQustionShowView removeQustionView];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    UIView *headerView = [[UIView alloc]init];
    [headerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, headerHeight)];
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


    if ((section == 1&& ![NSString isEmpty: self.yzgGetBillModel.name]) || section == 2 || section == 5) {
        return headerHeight;
    }else{
        
        return CGFLOAT_MIN;
        return tableView.sectionFooterHeight;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        if ([NSString isEmpty:self.yzgGetBillModel.name] || [self.yzgGetBillModel.un_salary_tpl?:@"0" floatValue] <= 0) {
            return 0;
        }
        return 36;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        if ([NSString isEmpty:self.yzgGetBillModel.name] || [self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0) {
            return 0;
        }
        return 36;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
            return 0;
        }
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
//        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
//
//
//        }
        return 0;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
//        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
//
//        }
        return 0;
    }
    return RowHeight;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nowTitleArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isAgentMonitor || self.markBillMore) {
        
        if (indexPath.section == 5 && indexPath.row == 0) {
            
            return;
        }
    }
    if ([NSString isEmpty:self.yzgGetBillModel.name]  ) {
        if ((indexPath.section == 2 && indexPath.row == 1) ||(indexPath.section == 2 && indexPath.row == 2)||(indexPath.section == 2 && indexPath.row == 3)||(indexPath.section == 3 && indexPath.row ==0)||(indexPath.section == 3 && indexPath.row ==1)) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }

    }

    [self endEditing:YES];
    [JGJQustionShowView removeQustionView];

    if (indexPath.section == 2 && indexPath.row == 0) {
        
        JGJCloseAccountOpenTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.subImageView.image isEqual:[UIImage imageNamed:@"new_arrow_up"]]) {
            
            self.nowTitleArr = [[NSArray alloc]initWithArray:self.openTitleArr];
            self.nowImageArr = [[NSArray alloc]initWithArray:self.openImageArr];
            self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.openSubTitleArr];

        }else{
            
            self.nowTitleArr = [[NSArray alloc]initWithArray:self.titleArr];
            self.nowImageArr = [[NSArray alloc]initWithArray:self.imageArr];
            self.nowSubTitleArr = [[NSArray alloc]initWithArray:self.subTitleArr];
        }
        
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
        [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (self.delegete &&[self.delegete respondsToSelector:@selector(didSelectCloseAccountFromIndexpath:withModel:)]) {
        
        [self.delegete didSelectCloseAccountFromIndexpath:indexPath withModel:self.yzgGetBillModel];
    }
}
- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    _yzgGetBillModel = yzgGetBillModel;
    [self.tableView reloadData];
}

- (void)setEditeMoney:(CGFloat)editeMoney {
    
    _editeMoney = editeMoney;
    [self.tableView reloadData];
}

-(void)clickLookforDetailBtn
{
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickNoSalaryTplBtn)]) {
        [self.delegete clickNoSalaryTplBtn];
    }
}
-(void)JGJMarkBillTextFileEditingText:(NSString *)text WithTag:(NSInteger)tag
{
    NSIndexPath *indexpaths = [NSIndexPath indexPathForRow:0 inSection:3];
    JGJMarkBillTextFileTableViewCell *cells = [self.tableView cellForRowAtIndexPath:indexpaths];
    
    if ([NSString isEmpty: self.yzgGetBillModel.name ]) {
        cells.textfiled.text = @"";
        return;
    }
    
    if (tag == 21) {
        
        self.yzgGetBillModel.subsidy_amount = text?:@"0";
        
    }else if (tag == 22){
        
        self.yzgGetBillModel.reward_amount = text?:@"0";
        
    }else if (tag == 23){
        
        self.yzgGetBillModel.penalty_amount = text?:@"0";
        
    }else if (tag == 40){//本次实收/付金额
       
        self.yzgGetBillModel.salary = [[NSString stringWithFormat:@"%.2f",[text?:@"0" doubleValue]] doubleValue];
        
        if (self.yzgGetBillModel.salary != 0) {
            
            _editeMoney = self.yzgGetBillModel.salary;
            _isEditeCurrentReciveMoney = YES;
        }else {
            
            _editeMoney = 0.0;
        }

    }else if (tag == 41){//抹零金额
        self.yzgGetBillModel.deduct_amount = text?:@"0";

    }
    

    if (self.delegete && [self.delegete respondsToSelector:@selector(closeAccountTextfiledEditing:andtag:)]) {
        [self.delegete closeAccountTextfiledEditing:text andtag:tag];
    }
    
   
}

- (void)btnClick:(id)sender event:(id)event{
    
    NSSet *touches=[event allTouches];
    UITouch *touch=[touches anyObject];
    CGPoint cureentTouchPosition=[touch locationInView:self.tableView];
    cureentTouchPosition.y = cureentTouchPosition.y + 64 + 80 - self.tableView.contentOffset.y ;;
    UIButton *btn = (UIButton *)sender;
    CGPoint cureentTouchBtn=[touch locationInView:btn];
    cureentTouchPosition.x = cureentTouchPosition.x + (11.5 - cureentTouchBtn.x);
    cureentTouchPosition.y = cureentTouchPosition.y + (11.5 - cureentTouchBtn.y);
    JGJQuestionShowtype type;

    if (btn.tag == 0) {
        type = JGJBalanceAmountType;
    }else if(btn.tag == 1){
        type = JGJNowPayAmountType;
    }else{
        type = JGJRemaingAmountType;
    }
    //得到cell中的IndexPath
//    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:cureentTouchPosition];
    [JGJQustionShowView showQustionFromPoint:cureentTouchPosition FromShowType:type];
    
}
#pragma mark - 结束编辑
- (void)JGJMarkBillTextFilEndEditing
{
    [self.tableView reloadData];
}
@end
