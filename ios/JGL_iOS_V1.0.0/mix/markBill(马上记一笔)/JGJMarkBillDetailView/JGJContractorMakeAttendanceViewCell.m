//
//  JGJNewContracortCollectionViewCell.m
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAttendanceViewCell.h"
#import "JGJContractorListAttendanceCell.h"
#import "JGJContractorTypeChoiceHeaderView.h"

#import "JGJContractorListAccountCell.h"
#import "IDJCalendar.h"

#import "NSDate+Extend.h"
#import "JGJWaringMarkBillTableViewCell.h"
@interface JGJContractorMakeAttendanceViewCell ()<UITableViewDelegate,UITableViewDataSource,JGJContractorListAccountCellDelegate>
{
    JGJContractorListAttendanceCell *_cell;
    JGJContractorListAccountCell *_accountCell;
    BOOL _contractorAccountType;// 包工记账类型,默认为NO(包工记考勤)  YES(包工记账)
}
@property (nonatomic, strong) UITableView *contractorListView;
@property (nonatomic, strong) JGJContractorTypeChoiceHeaderView *headerView;

// 类型
@property (nonatomic, strong) NSArray *imageName;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeHolderArr;

@property (nonatomic, strong) IDJCalendar *calendar;

@end
@implementation JGJContractorMakeAttendanceViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
        
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.contractorListView];
    [self setUpLayout];
}

- (void)setIsAgentMonitor:(BOOL)isAgentMonitor {
    
    _isAgentMonitor = isAgentMonitor;
    [self initializeData];
}

- (void)initializeData {
    
    if (_contractorAccountType) {
        
        self.imageName = @[@[@"lederHeadImage",@"markCalender",@"",@"SitPro"],@[@"subProTitle",@"openSalary",@"writeNumber",@"residueSalary"],@[@"markBillremark"]];
        self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期",@"",@"所在项目"],@[@"分项名称",@"填写单价",@"填写数量",@"包工工钱"],@[@"备注"]];
        self.placeHolderArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",@"",@"",@"例如:万科魅力之城"],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@""],@[@"可填写备注信息"]];
        
    }else {
        
        self.imageName = @[@[@"lederHeadImage",@"markCalender",@"",@"SitPro"],@[@"openSalary",@"workNormalTime",@"overTimeNormal"],@[@"markBillremark"]];
        self.titleArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"工人":@"班组长",@"日期",@"",@"所在项目"],@[@"考勤模板",@"上班时长",@"加班时长"],@[@"备注"]];
        self.placeHolderArr = @[@[(JLGisLeaderBool || self.isAgentMonitor)?@"请选择要记账的工人":@"请选择要记账的班组长/工头",@"",@"",@"例如:万科魅力之城"],@[@"这里设置模板",@"",@""],@[@"可填写备注信息"]];
    }
}

- (void)setUpLayout {
    
    _contractorListView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    
}

- (UITableView *)contractorListView {
    
    if (!_contractorListView) {
        
        _contractorListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contractorListView.delegate = self;
        _contractorListView.dataSource = self;
        _contractorListView.tableFooterView = [[UIView alloc] init];
        _contractorListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contractorListView.rowHeight = 55;
        _contractorListView.backgroundColor = AppFontf1f1f1Color;
    }
    return _contractorListView;
}

- (NSArray *)titleArr {
    
    if (!_titleArr) {
        
        _titleArr = [[NSArray alloc] init];
    }
    return _titleArr;
}

- (NSArray *)placeHolderArr {
    
    if (!_placeHolderArr) {
        
        _placeHolderArr = [[NSArray alloc] init];
    }
    return _placeHolderArr;
}

- (NSArray *)imageName {
    
    if (!_imageName) {
        
        _imageName = [[NSArray alloc] init];
    }
    return _imageName;
}

- (JGJContractorTypeChoiceHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[JGJContractorTypeChoiceHeaderView alloc] init];
    }
    return _headerView;
}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    
    _yzgGetBillModel = yzgGetBillModel;
    if (!_yzgGetBillModel.date) {
        
        self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
        
    }
    [_contractorListView reloadData];
}

#pragma mark - method
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
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 4;
        
    }else if (section == 1) {
        
        if (_contractorAccountType) {
            
            return 4;
        }else {
            
            return 3;
        }
        
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_contractorAccountType) {
        
        if (indexPath.section == 0 && indexPath.row == 2)//有包工待确认账单
        {
            JGJWaringMarkBillTableViewCell  *cell = [JGJWaringMarkBillTableViewCell cellWithTableView:tableView];
            if ([self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0) {

                cell.contentView.hidden = YES;
            }else{

                cell.contentView.hidden = NO;
            }
            
            cell.contentLable.text = self.yzgGetBillModel.bill_desc?:@"";
            
            return cell;
            
        }else {
            
            NSString *ID = NSStringFromClass([JGJContractorListAccountCell class]);
            JGJContractorListAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                
                cell = [[JGJContractorListAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            // 类型名
            cell.title = self.titleArr[indexPath.section][indexPath.row];
            // 类型placeHolder
            cell.placeHolder = self.placeHolderArr[indexPath.section][indexPath.row];
            // 类型图标
            cell.imageName = self.imageName[indexPath.section][indexPath.row];
            cell.delegate = self;
            if ([self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0) {
                
                if (indexPath.section == 0 && indexPath.row == 1) {
                    
                    cell.hiddenLine = YES;
                }
            }else{
                
                if (indexPath.section == 0 && indexPath.row == 1) {
                    
                    cell.hiddenLine = NO;
                }
            }
            cell.manGo = self.mainGo;
            cell.isMarkBillMore = self.markBillMore;
            cell.isAgentMonitor = self.isAgentMonitor;
            cell.cellTag = indexPath.section * 10 + indexPath.row;
            cell.yzgGetBillModel = self.yzgGetBillModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    }else {
        
        if (indexPath.section == 0 && indexPath.row == 2)//有包工待确认账单
        {
            
            JGJWaringMarkBillTableViewCell  *cell = [JGJWaringMarkBillTableViewCell cellWithTableView:tableView];

            cell.contentLable.text = self.yzgGetBillModel.bill_desc?:@"";
            cell.contentView.hidden = YES;
            return cell;
            
        }else {
            
            NSString *ID = NSStringFromClass([JGJContractorListAttendanceCell class]);
            JGJContractorListAttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            
            if (!cell) {
                
                cell = [[JGJContractorListAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            // 类型名
            cell.title = self.titleArr[indexPath.section][indexPath.row];
            // 类型placeHolder
            cell.placeHolder = self.placeHolderArr[indexPath.section][indexPath.row];
            // 类型图标
            cell.imageName = self.imageName[indexPath.section][indexPath.row];
            
            if ([self.yzgGetBillModel.bill_num ? :@"0" floatValue] <= 0) {
                
                if (indexPath.section == 0 && indexPath.row == 1) {
                 
                    cell.hiddenLine = YES;
                }
            }else{
                
                if (indexPath.section == 0 && indexPath.row == 1) {
                    
                    cell.hiddenLine = NO;
                }
            }
            
            cell.manGo = self.mainGo;
            cell.isMarkBillMore = self.markBillMore;
            cell.isAgentMonitor = self.isAgentMonitor;
            cell.cellTag = indexPath.section * 10 + indexPath.row;
            cell.yzgGetBillModel = self.yzgGetBillModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *contractorType = [[UIView alloc] init];
        contractorType.backgroundColor = AppFontf1f1f1Color;
        
        contractorType.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = AppFontdbdbdbColor;
        [contractorType addSubview:topLine];
        topLine.sd_layout.leftSpaceToView(contractorType, 0).topSpaceToView(contractorType, 0).rightSpaceToView(contractorType, 0).heightIs(0.5);
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = AppFontdbdbdbColor;
        [contractorType addSubview:bottomLine];
        bottomLine.sd_layout.leftSpaceToView(contractorType, 0).rightSpaceToView(contractorType, 0).bottomSpaceToView(contractorType, 0).heightIs(0.5);
        
        // 加header
        [contractorType addSubview:self.headerView];
        _headerView.sd_layout.leftSpaceToView(contractorType, 50).topSpaceToView(contractorType, 15).rightSpaceToView(contractorType, 50).heightIs(35);
        
        // 加提示
        UILabel *remindLabel = [[UILabel alloc] init];
        remindLabel.text = @"如果是小工等，需要确定每天的固定工资，请去点工为他记工";
        remindLabel.textColor = [UIColor redColor];
        remindLabel.font = FONT(11);
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [contractorType addSubview:remindLabel];
        remindLabel.sd_layout.leftSpaceToView(contractorType, 15).rightSpaceToView(contractorType,15).topSpaceToView(_headerView, 10).heightIs(10);
        
        if (_contractorAccountType) {
            
            remindLabel.hidden = YES;
        }else {
            
            remindLabel.hidden = NO;
        }
        __weak typeof(self)weakSelf = self;
        __strong typeof(self) strongSelf = self;
        _headerView.contractorHeaderBlcok = ^(NSInteger index) {
            
            if (index == 0) {
                
                strongSelf -> _contractorAccountType = NO;
                
            }else {
                
                strongSelf -> _contractorAccountType = YES;
            }
            
            [weakSelf initializeData];
            [weakSelf.contractorListView reloadData];
            
            [weakSelf.delegate didSelectContractTableViewWithContractorMakeType:strongSelf -> _contractorAccountType ?JGJContractorMakeAccountType:JGJContractorMakeAttendanceType];
        };
        return contractorType;
    }else if (section == 2) {
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = AppFontf1f1f1Color;
        backView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = AppFontdbdbdbColor;
        [backView addSubview:topLine];
        topLine.sd_layout.leftSpaceToView(backView, 0).topSpaceToView(backView, 0).rightSpaceToView(backView, 0).heightIs(0.5);
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = AppFontdbdbdbColor;
        [backView addSubview:bottomLine];
        bottomLine.sd_layout.leftSpaceToView(backView, 0).rightSpaceToView(backView, 0).bottomSpaceToView(backView, 0).heightIs(0.5);
        return backView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        if (_contractorAccountType) {
            
            return 60;
        }else {
            
            return 80;
        }
        
    }else if (section == 2) {
        
        return 10;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.yzgGetBillModel.bill_num?:@"0" floatValue] <= 0 && indexPath.section == 0 && indexPath.row == 2 ) {
        
        return 0;
        
    }else if ([self.yzgGetBillModel.bill_num floatValue] > 0&& indexPath.section == 0 && indexPath.row == 2 ){
       
        // 包工记考勤没有 待确认账单的cell
        if (!_contractorAccountType) {
            
            return 0;
        }else {
            
            return 40;
        }
        
    }
    return 55;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    TYLog(@"选择了第%ld行\n第%ld列", indexPath.section,indexPath.row);
    if (self.isAgentMonitor || self.markBillMore) {
        
        if (indexPath.section == 0 && indexPath.row == 3) {
            
            return;
        }
    }
    if ((indexPath.section == 1 && indexPath.row == 0) ||(indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 2)) {
        
        if ([NSString isEmpty:self.yzgGetBillModel.name]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }
    
    
    
    if ([_delegate respondsToSelector:@selector(didSelectContractTableViewFromIndexpath:WithContractorMakeType:)]) {
        
        [_delegate didSelectContractTableViewFromIndexpath:indexPath WithContractorMakeType:_contractorAccountType ?JGJContractorMakeAccountType:JGJContractorMakeAttendanceType];
    }
}

#pragma mark - JGJContractorListAccountCellDelegate
- (void)JGJContractorListAccountTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag{
    
    if ([self.delegate respondsToSelector:@selector(textFiledContractEditing:andTag:)]) {
        
        [_delegate textFiledContractEditing:text andTag:cellTag];
    }
}

- (void)textFieldEndEditing {
    
    if ([self.delegate respondsToSelector:@selector(JGJTextFieldEndEditing)]) {
        
        [_delegate JGJTextFieldEndEditing];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endEditing:YES];
    
}
@end
