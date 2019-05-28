//
//  JGJCheckStaTimeSectionPopView.m
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckStaTimeSectionPopView.h"

#import "JGJCheckStaPopViewCell.h"

#define PopViewCellH 47

@interface JGJCheckStaTimeSectionPopView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIView *containDetailView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDetailViewH;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *start_time;

@property (weak, nonatomic) IBOutlet UILabel *lunarStTime;

@property (weak, nonatomic) IBOutlet UILabel *end_time;

@property (weak, nonatomic) IBOutlet UILabel *lunarEnTime;

//显示类型
@property (nonatomic, assign) NSInteger showType;



@end

@implementation JGJCheckStaTimeSectionPopView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJCheckStaTimeSectionPopView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.containDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.start_time.textColor = AppFont333333Color;
    
    self.lunarStTime.textColor = AppFont666666Color;
    
    self.end_time.textColor = AppFont333333Color;
    
    self.lunarEnTime.textColor = AppFont666666Color;
    
    self.start_time.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    self.end_time.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    [self showView];
    
    //默认显示方式
    JGJAccountShowTypeModel *selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    _showType = selTypeModel.type;
    
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    _dataSource = [NSMutableArray array];
    
    [self setDataSource:_dataSource recordWorkStaModel:recordWorkStaModel];
    
    [self setTimeInfoWithRecordWorkStaModel:recordWorkStaModel];
}

- (void)setDataSource:(NSMutableArray *)dataSource recordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _dataSource = dataSource;
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    NSString *space = @"";
    
    //点工
    
    NSString *unit = @"小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @"个工";
    }
    
    NSString *over_work_unit = @"小时";
    
    if (_showType == 1) {
        
        over_work_unit = @"个工";
    }
    
    NSString *titleSpace = @"       ";
    
    //点工 上班加班
    JGJCheckStaPopViewCellModel *work_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    work_type.otherType = 1;
    
    work_type.typeTitle = [NSString stringWithFormat:@"点%@工", titleSpace];
    
    work_type.firTitle = @"上班";
    
    work_type.firChangeColor = redColor;
    
    work_type.money = [NSString stringWithFormat:@"￥%@%@",space,recordWorkStaModel.work_type.amounts];
    
    NSString *firChangeStr = _showType == 2 ?recordWorkStaModel.work_type.manhour :recordWorkStaModel.work_type.working_hours;
    
    work_type.firDes = [NSString stringWithFormat:@"%@%@%@", firChangeStr, space,unit];
    
    work_type.firChangeStr = firChangeStr;
    
    work_type.secTitle = @"加班";
    
    work_type.secChangeColor = redColor;
    
    NSString *secChangeStr = _showType != 1 ?recordWorkStaModel.work_type.overtime :recordWorkStaModel.work_type.overtime_hours;
    
    work_type.secDes = [NSString stringWithFormat:@"%@%@%@", secChangeStr,space, over_work_unit];
    
    work_type.secChangeStr = secChangeStr;
    
    [_dataSource addObject:work_type];
    
    //包工考勤 上班加班
    JGJCheckStaPopViewCellModel *attendance_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    attendance_type.typeTitle = @"包工记工天";
    
    attendance_type.otherType = 2;
    
    attendance_type.money = @"-";
    
    attendance_type.firTitle = @"上班";
    
    attendance_type.firChangeColor = redColor;
    
    firChangeStr = _showType == 2 ?recordWorkStaModel.attendance_type.manhour :recordWorkStaModel.attendance_type.working_hours;
    
    attendance_type.firDes = [NSString stringWithFormat:@"%@%@%@", firChangeStr, space,unit];
    
    attendance_type.firChangeStr = firChangeStr?:@"";
    

    attendance_type.secTitle = @"加班";
    
    attendance_type.secChangeColor = redColor;
    
    secChangeStr = _showType != 1 ?recordWorkStaModel.attendance_type.overtime :recordWorkStaModel.attendance_type.overtime_hours;
    
    attendance_type.secDes = [NSString stringWithFormat:@"%@%@%@", secChangeStr,space, over_work_unit];
    
    attendance_type.secChangeStr = secChangeStr;
    
    [_dataSource addObject:attendance_type];
    
    //工头才有包工分包
    if (JLGisLeaderBool) {
        
        //包工记账分包
        JGJCheckStaPopViewCellModel *contract_type = [[JGJCheckStaPopViewCellModel alloc] init];
        
        contract_type.money = [NSString stringWithFormat:@"￥%@%@",space,recordWorkStaModel.contract_type_two.amounts];
        
        contract_type.typeTitle = @"包工(分包)";
        
        contract_type.otherType = 6;
        
        contract_type.firChangeColor = redColor;
        
        contract_type.firChangeStr = recordWorkStaModel.contract_type_two.total?:@"";
        
        contract_type.firDes = [NSString stringWithFormat:@"%@笔", recordWorkStaModel.contract_type_two.total];
        
        [_dataSource addObject:contract_type];
        
    }
    
    //包工记账承包
    JGJCheckStaPopViewCellModel *undertake_contract_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    undertake_contract_type.money = [NSString stringWithFormat:@"￥%@%@",space,recordWorkStaModel.contract_type_one.amounts];
    
    undertake_contract_type.typeTitle = @"包工(承包)";
    
    undertake_contract_type.otherType = 3;
    
    undertake_contract_type.firChangeColor = JLGisLeaderBool ? greenColor : redColor;
    
    undertake_contract_type.firChangeStr = recordWorkStaModel.contract_type_one.total?:@"";
    
    undertake_contract_type.firDes = [NSString stringWithFormat:@"%@笔", recordWorkStaModel.contract_type_one.total];
    
    [_dataSource addObject:undertake_contract_type];
    
    
    
    
    //借支 笔数
    JGJCheckStaPopViewCellModel *expend_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    expend_type.otherType = 4;
    
    expend_type.typeTitle = [NSString stringWithFormat:@"借%@支", titleSpace];
    
    expend_type.money = [NSString stringWithFormat:@"￥%@%@",space,recordWorkStaModel.expend_type.amounts];
    
    expend_type.firChangeColor = greenColor;
    
    expend_type.firChangeStr = recordWorkStaModel.expend_type.total?:@"";
    
    expend_type.firDes = [NSString stringWithFormat:@"%@笔", recordWorkStaModel.expend_type.total];;
    
    [_dataSource addObject:expend_type];
    
    //结算 笔数
    JGJCheckStaPopViewCellModel *balance_type = [[JGJCheckStaPopViewCellModel alloc] init];
    
    balance_type.otherType = 5;
    
    balance_type.money = [NSString stringWithFormat:@"￥%@%@",space,recordWorkStaModel.balance_type.amounts];
    
    balance_type.typeTitle = [NSString stringWithFormat:@"结%@算", titleSpace];
    
    balance_type.firChangeColor = greenColor;
    
    balance_type.firChangeStr = recordWorkStaModel.balance_type.total?:@"";
    
    balance_type.firDes = [NSString stringWithFormat:@"%@笔", recordWorkStaModel.balance_type.total];
    
    [_dataSource addObject:balance_type];
    
    //承包和分包、点工。高度加20
    
    self.containDetailViewH.constant = _dataSource.count * PopViewCellH + 72 + 20;
    
    [self.tableView reloadData];
    
    
}

- (void)setTimeInfoWithRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    self.start_time.text = recordWorkStaModel.startTime;
    
    self.lunarStTime.text = [NSString stringWithFormat:@"(%@)", recordWorkStaModel.lunarStTime];
    
    self.end_time.text = recordWorkStaModel.endTime;
    
    self.lunarEnTime.text = [NSString stringWithFormat:@"(%@)",recordWorkStaModel.lunarEnTime];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaPopViewCell *cell = [JGJCheckStaPopViewCell cellWithTableView:tableView];
    
    cell.desInfoModel = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaPopViewCellModel *desInfoModel = _dataSource[indexPath.row];
    
    return (desInfoModel.otherType == 1 || desInfoModel.otherType == 2) ? PopViewCellH + 10 : PopViewCellH;
}

- (void)showView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView != self.containDetailView) {
        
        [self dismissView];
        
    }

}

@end
