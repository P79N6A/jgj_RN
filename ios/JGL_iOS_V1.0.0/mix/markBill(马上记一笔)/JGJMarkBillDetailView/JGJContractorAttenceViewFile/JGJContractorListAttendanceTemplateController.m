//
//  JGJContractorListAttendanceTemplateController.m
//  mix
//
//  Created by Tony on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorListAttendanceTemplateController.h"
#import "JGJAttendanceTemplateCell.h"
#import "JGJManHourPickerView.h"
@interface JGJContractorListAttendanceTemplateController ()<UITableViewDelegate,UITableViewDataSource,JGJManHourPickerViewDelegate>
{
    JGJAttendanceTemplateCell *_cell;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, copy) NSArray *titleArr;
@end

@implementation JGJContractorListAttendanceTemplateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.title = @"考勤模板";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureBtn];
    
    _tableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(150 + 60);
    _sureBtn.sd_layout.leftSpaceToView(self.view, 20).topSpaceToView(_tableView, 20).rightSpaceToView(self.view, 20).heightIs(50);
    
    [_sureBtn updateLayout];
    
    _sureBtn.layer.cornerRadius = 5;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = AppFontEB4E4EColor;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:AppFontffffffColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (NSArray *)titleArr {
    
    if (!_titleArr) {
        
        _titleArr = @[JLGisLeaderBool ? @"工人":@"班组长",@"上班标准",@"加班标准"];
    }
    return _titleArr;
}

- (void)setTargVC:(JGJMorePeopleViewController *)targVC {
    
    _targVC = targVC;
}
- (void)clickSureBtn {
    
    if (self.yzgGetBillModel.unit_quan_tpl.w_h_tpl <= 0) {
        
        self.yzgGetBillModel.unit_quan_tpl.w_h_tpl = 8;
    }
    
    if (self.yzgGetBillModel.unit_quan_tpl.o_h_tpl <= 0) {
        
        self.yzgGetBillModel.unit_quan_tpl.o_h_tpl = 6;
    }

    NSMutableArray *tpl_arr = [[NSMutableArray alloc] init];
    
    NSDictionary *parame = @{@"uid":@(_yzgGetBillModel.uid),
                             @"work_hour_tpl":@(self.yzgGetBillModel.unit_quan_tpl.w_h_tpl),
                             @"overtime_hour_tpl":@(self.yzgGetBillModel.unit_quan_tpl.o_h_tpl),
                             @"accounts_type":@"5"};
    [tpl_arr addObject:parame];
    
    NSString *paramStr = [tpl_arr mj_JSONString];
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/set-workday-tpl" parameters:@{@"params":paramStr} success:^(id responseObject) {
        
        
        if (self.attendanceTemplate) {
            
            self.attendanceTemplate(self.yzgGetBillModel);
        }
        
        _targVC.yzgGetBillModel = self.yzgGetBillModel;
        [self.navigationController popViewControllerAnimated:YES];
        
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];

}
- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    
    if (_yzgGetBillModel.unit_quan_tpl.w_h_tpl == 0) {
        
        // 默认上班上次为模板上班时长
        _yzgGetBillModel.manhour = 8;
    }
    // 默认加班时长为0
//    _yzgGetBillModel.overtime = 0;
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *ID = NSStringFromClass([JGJAttendanceTemplateCell class]);
    
    _cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!_cell) {

        _cell = [[JGJAttendanceTemplateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    _cell.cellTag = indexPath.row;
    _cell.titleArr = self.titleArr;
    _cell.yzgGetBillModel = _yzgGetBillModel;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerBack = [[UIView alloc]init];
    [headerBack setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    headerBack.backgroundColor = AppFontEBEBEBColor;
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    promptLabel.backgroundColor = AppFontFDF1E0Color;
    promptLabel.font = FONT(AppFont26Size);
    promptLabel.textColor = AppFontFF6600Color;
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    promptLabel.text = @"包工记工天无需设置工资金额\n如需设置工资金额，请为他记点工";
    
    [headerBack addSubview:promptLabel];
    
    UIView *headerViewTopLine = [[UIView alloc]init];
    [headerViewTopLine setFrame:CGRectMake(0, 51, TYGetUIScreenWidth, 1)];
    headerViewTopLine.backgroundColor = AppFontf1f1f1Color;
    [headerBack addSubview:headerViewTopLine];
    
    UIView *headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, TYGetUIScreenWidth, 1)];
    headerViewBottomLine.backgroundColor = AppFontdbdbdbColor;
    [headerBack addSubview:headerViewBottomLine];
    
    
    return headerBack;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选择上班标准
    if (indexPath.row == 1) {
        
        [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:YES andBillModel:self.yzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:NO];
        
    }else if (indexPath.row == 2) {// 选择加班标准
        
        [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:YES andBillModel:self.yzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:NO];
    }
}

- (void)selectManHourTime:(NSString *)Manhour {
    
    _yzgGetBillModel.unit_quan_tpl.w_h_tpl = [Manhour floatValue];
    [_tableView reloadData];
}

- (void)selectOverHour:(NSString *)overTime {
    
    _yzgGetBillModel.unit_quan_tpl.o_h_tpl = [overTime floatValue];
    [_tableView reloadData];
}

@end
