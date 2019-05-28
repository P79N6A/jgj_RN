//
//  JGrecordWorkTimePickerview.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGrecordWorkTimePickerview.h"
#import "JGJGetViewFrame.h"
#import "JGJMorePeopleViewController.h"
#import "NSString+Extend.h"
@interface JGrecordWorkTimePickerview()
<
UIPickerViewDelegate,
UIPickerViewDataSource,
JGJRecordModePickerRemarkViewDelegate
>
{
    NSString  *_proNameStr;
    NSString  *_proTimeStr;
    
    NSInteger _workingTimeIndex;
    NSInteger _overWorkingTimeIndex;
    
}
@property(nonatomic,strong)UIPickerView *pickerview;
@property(nonatomic,strong)NSMutableArray *proTimeList;
@property(nonatomic,strong)NSMutableArray *proTitleList;
@property(nonatomic,strong)UILabel *topLable;
@property(nonatomic,strong)UILabel *norWorklable;
@property(nonatomic,strong)UILabel *overWorklable;
@property(nonatomic,strong)jgjrecordselectedModel *selectdModel;

@property(nonatomic,strong)UIView *topView;
@property (strong ,nonatomic)UIButton *leftButton;// 取消
@property (nonatomic, strong) UIButton *deleteBtn;// 删除
@property (strong ,nonatomic)UIButton *rightButton;// 确定
@property (nonatomic, strong) UIImageView *proimageArrow;

@property (strong, nonatomic) IBOutlet UILabel *TopDetaillable;
@property (strong, nonatomic) IBOutlet UILabel *MoneyAndTimeLable;

@property (strong ,nonatomic)UIView *proNameView;//项目名称的view
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;

// 上班时长, 加班时长 左右两边的线
@property (nonatomic, strong) UIView *workLeftLine;
@property (nonatomic, strong) UIView *workRightLine;

@property (nonatomic, strong) UIView *overTimeLeftLine;
@property (nonatomic, strong) UIView *overTimeRightLine;

@property (nonatomic, strong) UIView *remarkTopLineView;

@property (nonatomic, strong) UIImageView *imageview;
@end
@implementation JGrecordWorkTimePickerview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.selectdModel = [jgjrecordselectedModel new];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadEView];
        
    }
    return self;
}



- (void)SetdefaultTimeW_tpl:(NSString *)work_time andover_tpl:(NSString *)overtime andManTPL:(NSString *)manHourTpl andOverTimeTPL:(NSString *)overTpl {
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_proTitleList];;
    _proTitleList = [[NSMutableArray alloc]initWithArray:array];//上班时间
    NSMutableArray *Timearray = [[NSMutableArray alloc]initWithArray:_proTimeList];;
    _proTimeList = [[NSMutableArray alloc]initWithArray:Timearray];//加班时间
    
    int manTplIndex;
    int overTplIndex;
    int manWorkTimeIndex;
    int overTimeIndex;
    
    if (![NSString isEmpty: work_time]) {
        
        manWorkTimeIndex = [work_time floatValue]/0.5;
        _proNameStr = work_time;
        
    }else{
        manWorkTimeIndex = 16;
        _proNameStr = @"0";
        
    }
    if (![NSString isEmpty: overtime ]) {
        
        overTimeIndex = [overtime floatValue]/0.5;
        _proTimeStr = overtime;
    }else{
        overTimeIndex = 0;
        _proTimeStr = @"0";
    }
    if (![NSString isEmpty: manHourTpl ]) {
        manTplIndex = [manHourTpl floatValue]/0.5;
    }else{
        manTplIndex = 16;
    }
    if (![NSString isEmpty: overTpl]) {
        overTplIndex = [overTpl floatValue]/0.5;
    }else{
        overTplIndex = 0;
    }
    
    if (![NSString isEmpty:manHourTpl]) {
        if ((int)[manHourTpl floatValue] == [manHourTpl floatValue]) {
            
            NSString *obj = [NSString stringWithFormat:@"%.0f小时(1个工)",[manHourTpl floatValue]];
            [_proTitleList replaceObjectAtIndex:manTplIndex withObject:obj];
            
        }else{
            
            NSString *obj = [NSString stringWithFormat:@"%.1f小时(1个工)",[manHourTpl floatValue]];
            [_proTitleList replaceObjectAtIndex:manTplIndex withObject:obj];
        }
        
        //设置半个工,如果工作时间标准为整数才设置 (int)[workTpl floatValue] * 10 % 10 == 0 则为整数  大于 0 为小数
        NSString *workTplStr = [manHourTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        if ([NSString isPureInt:workTplStr]) {
            
            NSString *obj ;
            
            obj = [NSString stringWithFormat:@"%.1f小时(半个工)",[workTplStr floatValue] / 2];
            obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
            [_proTitleList replaceObjectAtIndex:manTplIndex/2 withObject:obj];
        }
    }
    
    if (![NSString isEmpty:overTpl]) {
        
        if ((int)[overTpl floatValue] == [overTpl floatValue]) {
            
            NSString *obj = [NSString stringWithFormat:@"%.0f小时(1个工)",[overTpl floatValue]];
            [_proTimeList replaceObjectAtIndex:overTplIndex withObject:obj];
            
        }else{
            
            NSString *obj = [NSString stringWithFormat:@"%.1f小时(1个工)",[overTpl floatValue]];
            [_proTimeList replaceObjectAtIndex:overTplIndex withObject:obj];
        }
        
        NSString *overTplStr = [overTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        if ([NSString isPureInt:overTplStr]) {
            
            NSString *obj ;
            
            obj = [NSString stringWithFormat:@"%.1f小时(半个工)",[overTpl floatValue] / 2];
            obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
            [_proTimeList replaceObjectAtIndex:overTplIndex/2 withObject:obj];
        }
    }
    
    _workingTimeIndex = manWorkTimeIndex;
    _overWorkingTimeIndex = overTimeIndex;
    [self.pickerview reloadAllComponents];
    [self.pickerview selectRow:manWorkTimeIndex inComponent:0 animated:YES];
    [self.pickerview selectRow:overTimeIndex inComponent:1 animated:YES];
    
    self.selectdModel.normal_work = work_time;
    self.selectdModel.overtime = overtime;
    
}
-(void)SetdefaultTimeW_tpl:(NSString *)work_time workTpl:(NSString *)workTpl andover_tpl:(NSString *)overtime overTpl:(NSString *)overTpl andDefult:(BOOL)defult
{
    
    TYLog(@"工作时间 = %@\n加班时间 = %@\n 标准上班时间 = %@ \n 加班标准时间 = %@",work_time,overtime,workTpl,overTpl);
    NSInteger leftRow = [workTpl floatValue]/0.5;
    
    NSInteger work_row = [work_time floatValue] / 0.5;
    NSInteger overWork_row = [overtime floatValue] / 0.5;
    if (leftRow < 0) {
        leftRow = _proTimeList.count;
    }
    
    if (_proTimeList.count && work_time) {
        
        int rightRow = [overTpl floatValue]/0.5;
        if (rightRow < 0) {
            
            rightRow = 0;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_proTitleList];;
        _proTitleList = [[NSMutableArray alloc]initWithArray:array];
        
        if ([workTpl floatValue] > 0) {
            
            NSString *obj = [NSString stringWithFormat:@"%@小时(1个工)",[workTpl stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            [_proTitleList replaceObjectAtIndex:leftRow withObject:obj];
            
            //设置半个工,如果工作时间标准为整数才设置 (int)[workTpl floatValue] * 10 % 10 == 0 则为整数  大于 0 为小数
            NSString *workTplStr = [workTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            if ([NSString isPureInt:workTplStr]) {
                
                NSString *obj ;
                
                obj = [NSString stringWithFormat:@"%.1f小时(半个工)",[workTpl floatValue] / 2];
                obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
                [_proTitleList replaceObjectAtIndex:leftRow/2 withObject:obj];
            }
            
            NSMutableArray *Timearray = [[NSMutableArray alloc]initWithArray:_proTimeList];;
            _proTimeList = [[NSMutableArray alloc]initWithArray:Timearray];
        }
        
        
        if (![NSString isEmpty:overTpl]) {
            if ([overTpl floatValue] > 0)  {
                
                NSString *obj = [NSString stringWithFormat:@"%@小时(1个工)",[overTpl stringByReplacingOccurrencesOfString:@".0" withString:@""]];
                
                [_proTimeList replaceObjectAtIndex:rightRow withObject:obj];
                
                NSString *overTplStr = [overTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                if ([NSString isPureInt:overTplStr]) {
                    
                    NSString *obj ;
                    
                    obj = [NSString stringWithFormat:@"%.1f小时(半个工)",[overTpl floatValue] / 2];
                    obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    [_proTimeList replaceObjectAtIndex:rightRow/2 withObject:obj];
                }
            }
        }
        _proTimeStr = @"0";
        _proNameStr = work_time;
        
        if (!defult) {
            _proTimeStr = overtime;
            _proNameStr = work_time;
            if ([NSString isEmpty:overtime]) {
                
            }
            [self.pickerview selectRow:leftRow inComponent:0 animated:YES];
            [self.pickerview selectRow:0 inComponent:1 animated:YES];
            _workingTimeIndex = leftRow;
            _overWorkingTimeIndex = 0;
            
        }else{
            
            [self.pickerview selectRow:work_row inComponent:0 animated:YES];
            [self.pickerview selectRow:overWork_row inComponent:1 animated:YES];
            _workingTimeIndex = work_row;
            _overWorkingTimeIndex = overWork_row;
            
        }
        
        [self.pickerview reloadAllComponents];
    }
    
    
}

- (void)SetdefaultTimeW_tpl:(NSString *)work_time workTpl:(NSString *)workTpl andover_tpl:(NSString *)overtime overTpl:(NSString *)overTpl andDefult:(BOOL)defult isMoreDayComming:(BOOL)isMoreDayComming {
    
    TYLog(@"工作时间 = %@\n加班时间 = %@\n 标准上班时间 = %@ \n 加班标准时间 = %@",work_time,overtime,workTpl,overTpl);
    NSInteger leftRow = [workTpl floatValue]/0.5;
    
    NSInteger work_row = [work_time floatValue] / 0.5;
    NSInteger overWork_row = [overtime floatValue] / 0.5;
    if (leftRow < 0) {
        leftRow = _proTimeList.count;
    }
    
    if (_proTimeList.count && work_time) {
        
        int rightRow = [overTpl floatValue]/0.5;
        if (rightRow < 0) {
            
            rightRow = 0;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_proTitleList];;
        _proTitleList = [[NSMutableArray alloc]initWithArray:array];
        
        if ([workTpl floatValue] > 0) {
            
            NSString *obj = [NSString stringWithFormat:@"%@小时",[workTpl stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            [_proTitleList replaceObjectAtIndex:leftRow withObject:obj];
            
            //设置半个工,如果工作时间标准为整数才设置 (int)[workTpl floatValue] * 10 % 10 == 0 则为整数  大于 0 为小数
            NSString *workTplStr = [workTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            if ([NSString isPureInt:workTplStr]) {
                
                NSString *obj ;
                
                obj = [NSString stringWithFormat:@"%.1f小时",[workTpl floatValue] / 2];
                
                obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
                [_proTitleList replaceObjectAtIndex:leftRow/2 withObject:obj];
            }
            
            NSMutableArray *Timearray = [[NSMutableArray alloc]initWithArray:_proTimeList];;
            _proTimeList = [[NSMutableArray alloc]initWithArray:Timearray];
        }
        
        
        if (![NSString isEmpty:overTpl]) {
            if ([overTpl floatValue] > 0)  {
                
                NSString *obj = [NSString stringWithFormat:@"%@小时",[overTpl stringByReplacingOccurrencesOfString:@".0" withString:@""]];
                
                [_proTimeList replaceObjectAtIndex:rightRow withObject:obj];
                
                NSString *overTplStr = [overTpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                if ([NSString isPureInt:overTplStr]) {
                    
                    NSString *obj ;
                    
                    obj = [NSString stringWithFormat:@"%.1f小时",[overTpl floatValue] / 2];
                    obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    [_proTimeList replaceObjectAtIndex:rightRow/2 withObject:obj];
                }
            }
        }
        _proTimeStr = @"0";
        _proNameStr = work_time;
        
        if (!defult) {
            _proTimeStr = overtime;
            _proNameStr = work_time;
            if ([NSString isEmpty:overtime]) {
                
            }
            [self.pickerview selectRow:leftRow inComponent:0 animated:YES];
            [self.pickerview selectRow:0 inComponent:1 animated:YES];
            _workingTimeIndex = leftRow;
            _overWorkingTimeIndex = 0;
            
        }else{
            
            [self.pickerview selectRow:work_row inComponent:0 animated:YES];
            [self.pickerview selectRow:overWork_row inComponent:1 animated:YES];
            _workingTimeIndex = work_row;
            _overWorkingTimeIndex = overWork_row;
            
        }
        
        
        [self.pickerview reloadAllComponents];
    }
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)SetdefaultTimeW_tpl:(NSString *)work_time andover_tpl:(NSString *)overtime andDefult:(BOOL)defult
{
    
    int leftRow = [overtime floatValue]/0.5 - 1;
    if (leftRow < 0) {
        leftRow = 0;
    }
    
    if (_proTimeList.count && work_time) {
        int rightRow = [work_time floatValue]/0.5 - 1;
        if (rightRow<0) {
            rightRow = 0;
        }
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_proTitleList];;
        _proTitleList = [[NSMutableArray alloc]initWithArray:array];
        
        if ([work_time floatValue] > 0) {
            
            if ([work_time intValue] % 2 == 0 && [work_time floatValue]>0) {
                
                NSString *obj = [NSString stringWithFormat:@"%d小时(半个工)",[work_time intValue]/2];
                
                [_proTitleList replaceObjectAtIndex:rightRow/2 withObject:obj];
                
            }
            else if ([work_time intValue] % 2 != 0 && [work_time floatValue]>0) {
                
                NSString *obj = [NSString stringWithFormat:@"%.1f小时(半个工)",[work_time floatValue]/2];
                obj = [obj stringByReplacingOccurrencesOfString:@".0" withString:@""];
                [_proTitleList replaceObjectAtIndex:rightRow/2 withObject:obj];
                
            }else{
                
            }
            
            NSMutableArray *Timearray = [[NSMutableArray alloc]initWithArray:_proTimeList];;
            _proTimeList = [[NSMutableArray alloc]initWithArray:Timearray];
        }
        
        
        if (overtime) {
            
            if ([overtime floatValue] > 0)  {
                
                if ([overtime intValue] % 2 == 0&& [overtime intValue]>0) {
                    
                    NSString *objs = [NSString stringWithFormat:@"%d小时(半个工)",[overtime intValue]/2];
                    [_proTimeList replaceObjectAtIndex:leftRow/2 withObject:objs];
                    
                }else if ([overtime intValue] % 2 != 0 && [overtime floatValue]>0)
                {
                    NSString *objs = [NSString stringWithFormat:@"%.1f小时(半个工)",[overtime floatValue]/2];
                    objs = [objs stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    [_proTimeList replaceObjectAtIndex:leftRow/2 withObject:objs];
                }
            }
            
        }
        _proTimeStr = @"0";
        _proNameStr = work_time;
        
        if (!defult) {
            _proTimeStr = overtime;
            _proNameStr = work_time;
            if ([NSString isEmpty:overtime]) {
                
            }
            [self.pickerview selectRow:rightRow inComponent:0 animated:YES];
            [self.pickerview selectRow:leftRow inComponent:1 animated:YES];
            
        }else{
            
            [self.pickerview selectRow:rightRow inComponent:0 animated:YES];
            [self.pickerview selectRow:_proTimeList.count - 1 inComponent:1 animated:YES];
            
        }
        
        [self.pickerview reloadAllComponents];
    }
    
}

-(void)overTimedefults
{
    if (_proTimeList) {
        [self.pickerview selectRow:_proTimeList.count-1 inComponent:1 animated:YES];
        [self.pickerview reloadAllComponents];
        
    }
    
}

- (void)loaview {
    self.backgroundColor = [UIColor whiteColor];
    [self loadXIB];
    [self addSubview:self.pickerview];
    [self.pickerview selectRow:3 inComponent:1 animated:NO];
    [self.pickerview selectRow:1 inComponent:0 animated:NO];
    
    self.selectdModel.normal_work = _proTitleList[3];
    self.selectdModel.overtime = _proTimeList[1];
    
}
- (void)setModelstr:(NSString *)modelstr
{
    _TopDetaillable.text = modelstr;
    [_TopDetaillable layoutIfNeeded];
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _MoneyAndTimeLable.layer.borderColor = AppFontf1f1f1Color.CGColor;
    _MoneyAndTimeLable.layer.borderWidth = 1;
    _MoneyAndTimeLable.backgroundColor = AppFontffffffColor;
    _MoneyAndTimeLable.layer.masksToBounds = YES;
    _MoneyAndTimeLable.layer.cornerRadius = 3;
}

- (void)setRecorderPeopleModel:(JgjRecordMorePeoplelistModel *)recorderPeopleModel {
    
    _recorderPeopleModel = recorderPeopleModel;
    self.selectdModel.name = _recorderPeopleModel.name;
    self.selectdModel.uid = _recorderPeopleModel.uid;
    self.selectdModel.salary_tpl = _recorderPeopleModel.tpl.s_tpl;
    self.selectdModel.work_hour_tpl = _recorderPeopleModel.tpl.w_h_tpl;
    self.selectdModel.overtime_hour_tpl = _recorderPeopleModel.tpl.o_h_tpl;
    self.selectdModel.accounts_type = _recorderPeopleModel.msg.accounts_type;
    self.selectdModel.unit_quan_work_hour_tpl = _recorderPeopleModel.unit_quan_tpl.w_h_tpl;
    self.selectdModel.unit_quan_overtime_hour_tpl = _recorderPeopleModel.unit_quan_tpl.o_h_tpl;
    self.selectdModel.record_id = _recorderPeopleModel.record_id;
}
- (IBAction)rightButtonClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickrightbutton:)]) {
        [self.delegate clickrightbutton:nil];
    }
    
}
- (IBAction)leftButtonClick:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickLeftButton)]) {
        [self.delegate ClickLeftButton];
    }
}
-(void)CancelButtonselected
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickLeftButton)]) {
        [self.delegate ClickLeftButton];
    }
    [self dismissview];
}

- (void)deleteButtonselected {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteRecordWorkingModelWithjgjrecordselectedModel:)]) {
        
        [self.delegate deleteRecordWorkingModelWithjgjrecordselectedModel:self.selectdModel];
    }
}

- (void)sureButtonselected {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickrightbutton:)]) {
        
        [self.delegate clickrightbutton:self.selectdModel];
    }
    
    
}

- (void)didSelectedRecordRemark {
    
    
    if ([self.delegate respondsToSelector:@selector(clickWorkTimePickerviewRemarkTxtWithJgjRecordMorePeoplelistModel:)]) {
        
        [self.delegate clickWorkTimePickerviewRemarkTxtWithJgjRecordMorePeoplelistModel:self.recorderPeopleModel];
    }
}


- (void)dismissview {
    
    [UIView animateWithDuration:.5 animations:^{
        
        [self setFrame:[self retrunframex:0 y:TYGetUIScreenHeight width:TYGetUIScreenWidth height:CGRectGetHeight(self.frame)]];
    }];
}
- (void)loadXIB{
    
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"picker" owner:self options:nil]firstObject];
    [view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 80)];
    [self addSubview:view];
    _TopDetaillable = [view viewWithTag:2];
    _leftButton = [view viewWithTag:1];
    _rightButton = [view viewWithTag:3];
    
}

- (void)setWorkTimeArr:(NSMutableArray *)workTimeArr {
    
    _proTitleList = [NSMutableArray array];
    _proTitleList = workTimeArr;
    [self.pickerview selectRow:1 inComponent:0 animated:NO];
    self.selectdModel.normal_work = _proTitleList[1];
    [_pickerview reloadAllComponents];
    
}
- (void)setOverTimeArr:(NSMutableArray *)overTimeArr {
    
    _proTimeList = [NSMutableArray array];
    _proTimeList = overTimeArr;
    [self.pickerview selectRow:3 inComponent:1 animated:NO];
    self.selectdModel.overtime = _proTimeList[3];
    [_pickerview reloadAllComponents];
    
}
-(UIPickerView *)pickerview
{
    if (!_pickerview) {
        
        _pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0,115, CGRectGetWidth(self.frame), 165)];
        // 显示选中框
        _pickerview.showsSelectionIndicator=YES;
        _pickerview.dataSource = self;
        _pickerview.delegate = self;
        _pickerview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.pickerview selectRow:8 inComponent:0 animated:NO];
        [self.pickerview selectRow:6 inComponent:1 animated:NO];
        
    }
    return _pickerview;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_proTitleList count];
    }
    
    return [_proTimeList count];
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        _proNameStr = [_proTitleList objectAtIndex:row];
        self.selectdModel.normal_work = _proNameStr;
        
        
    } else {
        
        _proTimeStr = [_proTimeList objectAtIndex:row];
        self.selectdModel.overtime = _proTimeStr;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pickerViewleft:overTime:)]) {
        
        [self.delegate pickerViewleft:_proNameStr overTime:_proTimeStr];
    }
    UILabel *selectedLable = (UILabel *)[self.pickerview viewForRow:row forComponent:component];
    selectedLable.textColor = AppFontd7252cColor;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        if (_workingTimeIndex == row) {
            
            UILabel *selectedLable = (UILabel *)[self.pickerview viewForRow:row forComponent:component];
            selectedLable.textColor = AppFontd7252cColor;
        }
        return [_proTitleList objectAtIndex:row];
        
    } else {
        
        if (_overWorkingTimeIndex == row) {
            
            UILabel *selectedLable = (UILabel *)[self.pickerview viewForRow:row forComponent:component];
            selectedLable.textColor = AppFontd7252cColor;
        }
        return [_proTimeList objectAtIndex:row];
    }
    
}

- (void)loadEView
{
    [self addSubview:self.topView];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.deleteBtn];
    [self.topView addSubview:self.topLable];
    [self.topView addSubview:self.rightButton];
    
    [self addSubview:self.detailInfoView];
    [self.detailInfoView addSubview:self.detailType];
    [self.detailInfoView addSubview:self.detailLable];
    [self addSubview:self.norWorklable];
    [self addSubview:self.workLeftLine];
    [self addSubview:self.workRightLine];
    [self addSubview:self.overWorklable];
    [self addSubview:self.overTimeLeftLine];
    [self addSubview:self.overTimeRightLine];
    [self addSubview:self.pickerview];
    [self addSubview:self.proNameView];
    [self addSubview:self.remarkTopLineView];
    [self addSubview:self.remarkView];
    
    [self setUpLayout];
    
}

- (void)setUpLayout {
    
    _workLeftLine.sd_layout.centerYEqualToView(_norWorklable).rightSpaceToView(_norWorklable, 0).widthIs(20).heightIs(1);
    _workRightLine.sd_layout.centerYEqualToView(_norWorklable).leftSpaceToView(_norWorklable, 0).widthIs(20).heightIs(1);
    
    _overTimeLeftLine.sd_layout.centerYEqualToView(_overWorklable).rightSpaceToView(_overWorklable, 0).widthIs(20).heightIs(1);
    _overTimeRightLine.sd_layout.centerYEqualToView(_overWorklable).leftSpaceToView(_overWorklable, 0).widthIs(20).heightIs(1);
    
}

- (void)setIsAddRemarkView:(BOOL)isAddRemarkView {
    
    _isAddRemarkView = isAddRemarkView;
    
    if (_isAddRemarkView) {
        
        self.proNameView.hidden = YES;
        self.remarkView.hidden = NO;
        self.remarkTopLineView.hidden = NO;
    }
}

- (void)setIsHideDeleteBtn:(BOOL)isHideDeleteBtn {
    
    _isHideDeleteBtn = isHideDeleteBtn;
    if (_isHideDeleteBtn) {
        
        self.deleteBtn.hidden = YES;
    }
}


- (UIView *)workLeftLine {
    
    if (!_workLeftLine) {
        
        _workLeftLine = [[UIView alloc] init];
        _workLeftLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _workLeftLine;
}

- (UIView *)workRightLine {
    
    if (!_workRightLine) {
        
        _workRightLine = [[UIView alloc] init];
        _workRightLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _workRightLine;
}

- (UIView *)overTimeLeftLine {
    
    if (!_overTimeLeftLine) {
        
        _overTimeLeftLine = [[UIView alloc] init];
        _overTimeLeftLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _overTimeLeftLine;
}

- (UIView *)overTimeRightLine {
    
    if (!_overTimeRightLine) {
        
        _overTimeRightLine = [[UIView alloc] init];
        _overTimeRightLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _overTimeRightLine;
}

- (UIView *)proNameView
{
    if (!_proNameView) {
        
        _proNameView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pickerview.frame) + 5, TYGetUIScreenWidth, 60)];
        _proNameView.backgroundColor = [UIColor whiteColor];
        UILabel *upLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        upLable.backgroundColor = AppFontf1f1f1Color;
        [_proNameView addSubview:upLable];
        
        UILabel *tipLable = [[UILabel alloc]init];
        tipLable.font = [UIFont systemFontOfSize:15];
        tipLable.textColor = AppFont333333Color;
        tipLable.text = @"所在项目";
        [_proNameView addSubview:tipLable];
        
        [tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(25);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(20);
        }];
        
        _proLable = [[UILabel alloc]init];
        _proLable.font = [UIFont systemFontOfSize:15];
        _proLable.textAlignment = NSTextAlignmentRight;
        _proLable.textColor = AppFont999999Color;
        _proLable.text = @"例如：万科魅力城";
        UITapGestureRecognizer *tapLable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNewProNameLable)];
        _proLable.userInteractionEnabled = YES;
        [_proLable addGestureRecognizer:tapLable];
        [_proNameView addSubview:_proLable];
        
        [_proLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(tipLable.mas_right).offset(10);
            make.centerY.equalTo(tipLable.mas_centerY).offset(0);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-28);
        }];
        
        UIImageView *proimage = [[UIImageView alloc]init];
        proimage.image = [UIImage imageNamed:@"arrow_right"];
        proimage.contentMode = UIViewContentModeRight;
        _proimageArrow = proimage;
        [_proNameView addSubview:proimage];
        [proimage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(13);
            make.centerY.equalTo(tipLable.mas_centerY).offset(0);
        }];
        
    }
    return _proNameView;
    
}

- (void)setIsAgentMonitor:(BOOL)isAgentMonitor {
    
    _isAgentMonitor = isAgentMonitor;
    if (_isAgentMonitor) {
        
        _proimageArrow.hidden = YES;
    }else {
        
        _proimageArrow.hidden = NO;
    }
    
}
- (void)tapNewProNameLable
{
    if (self.isAgentMonitor) {
        
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapProNameLable)]) {
        
        [self.delegate tapProNameLable];
    }
}
- (void)setProName:(UILabel *)proName
{
    _proLable.textColor = AppFont333333Color;
}

- (void)setTheDetailLableTexTAlignmentNeedLeft:(BOOL)theDetailLableTexTAlignmentNeedLeft {
    
    _theDetailLableTexTAlignmentNeedLeft = theDetailLableTexTAlignmentNeedLeft;
    if (_theDetailLableTexTAlignmentNeedLeft) {
        
        _detailLable.textAlignment = NSTextAlignmentLeft;
        
    }else {
        
        _detailLable.textAlignment = NSTextAlignmentRight;
    }
}


- (UIView *)topView
{
    if (!_topView) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
        _topView.backgroundColor = JGJMainColor;
    }
    return _topView;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50, 30)];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = FONT(15);
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(CancelButtonselected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 50, 30)];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = FONT(15);
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteButtonselected) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteBtn;
}
-(UIButton *)rightButton
{
    if (!_rightButton) {
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - 50, 10, 50, 30)];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = FONT(15);
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(sureButtonselected) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightButton;
    
}
-(UILabel *)topLable
{
    if (!_topLable) {
        _topLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, TYGetUIScreenWidth - 200, 30)];
        _topLable.textAlignment = NSTextAlignmentCenter;
        _topLable.textColor = [UIColor whiteColor];
        _topLable.font = [UIFont systemFontOfSize:15];
        
    }
    return _topLable;
}

- (UIView *)detailInfoView {
    
    if (!_detailInfoView) {
        
        _detailInfoView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_topView.frame) + 10, TYGetUIScreenWidth - 40, 30)];
        _detailInfoView.backgroundColor = AppFontf1f1f1Color;
        
        _detailInfoView.layer.masksToBounds = YES;
        _detailInfoView.layer.cornerRadius = 15;
        _detailInfoView.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _detailInfoView.layer.borderWidth = 0.5;
        
        _detailInfoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapguestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editeWorkMoney)];
        [_detailInfoView addGestureRecognizer:tapguestrue];
    }
    return _detailInfoView;
}

- (UILabel *)detailType {
    
    if (!_detailType) {
        
        _detailType = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailType.textColor = [UIColor blackColor];
        _detailType.text = @"";
        _detailType.font = [UIFont systemFontOfSize:12];
        _detailType.textAlignment = NSTextAlignmentLeft;
        _detailType.textColor = AppFont666666Color;
    }
    return _detailType;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        
        _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth - 40 - 20, 30)];
        _detailLable.text = @"";
        _detailLable.font = [UIFont systemFontOfSize:12];
        _detailLable.textAlignment = NSTextAlignmentCenter;
        _detailLable.textColor = AppFont666666Color;
        _detailLable.numberOfLines = 0;
        
    }
    return _detailLable;
}
- (void)editeWorkMoney{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editeMoneylable)]) {
        
        [self.delegate editeMoneylable];
    }
}
- (UILabel *)norWorklable
{
    if (!_norWorklable) {
        _norWorklable = [[UILabel alloc]initWithFrame:[self retrunframex:62.5 y:CGRectGetMaxY(_detailInfoView.frame)+15 width:80 height:18]];
        _norWorklable.textColor = AppFont666666Color;
        _norWorklable.text = @"上班时长";
        _norWorklable.textAlignment = NSTextAlignmentCenter;
        
        _norWorklable.font = [UIFont systemFontOfSize:AppFont24Size];
        
    }
    return _norWorklable;
}
- (UILabel *)overWorklable
{
    if (!_overWorklable) {
        _overWorklable = [[UILabel alloc]initWithFrame:[self retrunframex:TYGetUIScreenWidth-138 y:CGRectGetMaxY(_detailInfoView.frame)+15 width:75 height:18]];
        _overWorklable.text = @"加班时长";
        _overWorklable.textColor = AppFont666666Color;
        _overWorklable.textAlignment = NSTextAlignmentCenter;
        _overWorklable.font = [UIFont systemFontOfSize:AppFont24Size];
        
    }
    return _overWorklable;
}

- (UIView *)remarkTopLineView {
    
    if (!_remarkTopLineView) {
        
        _remarkTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.proNameView.frame), TYGetUIScreenWidth, 5)];
        _remarkTopLineView.backgroundColor = AppFontEBEBEBColor;
    }
    return _remarkTopLineView;
}

- (JGJRecordModePickerRemarkView *)remarkView {
    
    if (!_remarkView) {
        
        _remarkView = [[JGJRecordModePickerRemarkView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remarkTopLineView.frame), TYGetUIScreenWidth, 60 + 35)];
        _remarkView.remarkViewDelegate = self;
    }
    return _remarkView;
}

- (CGRect)retrunframex:(float)x y:(float)y width:(float)width height:(float)height
{
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}

-(void)setDayNum:(int)dayNum
{
    _dayNum = dayNum;
    
}


- (void)setDetailStr:(NSString *)detailStr
{
    if (_dayNum) {
        
        NSString *day_len = [NSString stringWithFormat:@"%d天",_dayNum];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
        
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:JGJMainColor
                        range:NSMakeRange(7, day_len.length)];
        
        _detailLable.attributedText = attrStr;
        
    }else{
        
        _detailLable.text = detailStr;
    }
    if (_shouldBoard) {
        
        _detailInfoView.layer.borderWidth = 0.5;
        _detailInfoView.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _detailInfoView.layer.masksToBounds = YES;
        _detailInfoView.layer.cornerRadius = 2.5;
        
        CGFloat textHeight = [NSString stringWithContentSize:CGSizeMake(CGRectGetWidth(_detailInfoView.frame) - 15 - 100 - 10 - 9, CGFLOAT_MAX) content:detailStr font:12].height + 15;
        
        textHeight = textHeight > 30 ? textHeight : 30;
        _detailInfoView.frame = CGRectMake(20, CGRectGetMaxY(_topView.frame) + 5, TYGetUIScreenWidth - 40, textHeight);
        _detailType.frame = CGRectMake(15, 0, 100, textHeight);
        _detailLable.frame = CGRectMake(CGRectGetMaxX(_detailType.frame), 0, CGRectGetWidth(_detailInfoView.frame) - 15 - 100 - 10 - 9, textHeight);
        self.imageview.frame = CGRectMake(CGRectGetWidth(_detailInfoView.frame) - 5 - 9, textHeight / 2 - 7.5, 9, 15);
        [_detailInfoView addSubview:self.imageview];
        
        _norWorklable.frame = [self retrunframex:62.5 y:CGRectGetMaxY(_detailInfoView.frame) + 5 width:80 height:18];
        _overWorklable.frame = [self retrunframex:TYGetUIScreenWidth - 138 y:CGRectGetMaxY(_detailInfoView.frame) + 5 width:75 height:18];
        
        _pickerview.frame = CGRectMake(0,CGRectGetMaxY(_norWorklable.frame) + 5, CGRectGetWidth(self.frame), self.frame.size.height - 50 - 5 - textHeight - 5 - 18 - 10);
        _proNameView.frame = CGRectMake(0, CGRectGetMaxY(_pickerview.frame), TYGetUIScreenWidth, 60);
    }
    
}

- (UIImageView *)imageview {
    
    if (!_imageview) {
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageview.image = [UIImage imageNamed:@"arrow_right"];
        _imageview.contentMode = UIViewContentModeRight;
    }
    return _imageview;
}
-(void)setNameAndPhone:(NSString *)nameAndPhone
{
    _topLable.text = nameAndPhone;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
        
        pickerLabel.textColor = AppFont333333Color;
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
    
}
@end
