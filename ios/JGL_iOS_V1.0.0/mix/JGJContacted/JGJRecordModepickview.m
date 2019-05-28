//
//  JGJRecordModepickview.m
//  mix
//
//  Created by Tony on 2017/2/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordModepickview.h"

#import "UILabel+GNUtil.h"

@interface JGJRecordModepickview ()
<
UIPickerViewDelegate,

UIPickerViewDataSource,
JGJRecordModePickerRemarkViewDelegate
>
{
    
    NSString  *_proNameStr;
    
    NSString  *_proTimeStr;
    
}
@property(nonatomic,strong)UIPickerView *pickerview;

@property(nonatomic,strong)UILabel *topLable;

@property(nonatomic,strong)UILabel *norWorklable;

@property(nonatomic,strong)UILabel *overWorklable;

@property(nonatomic,strong)jgjrecordselectedModel *selectdModel;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIView *bottomView;

@property (strong ,nonatomic)UIButton *leftButton;

@property (strong ,nonatomic)UIButton *rightButton;

@property(nonatomic,strong)UILabel *reminLable;


@property (nonatomic, strong) UIView *remarkTopLineView;

@end
@implementation JGJRecordModepickview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        //        [self loaview];
        self.selectdModel = [jgjrecordselectedModel new];
        
        self.backgroundColor = [UIColor darkGrayColor];
        self.alpha = .5;
        [self loadEView];
        
    }
    return self;
}
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if( (self = [super initWithCoder:aDecoder]) ) {
//        [self loaview];
//    }
//    return self;
//}

- (void)loaview{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerview];
    [self.pickerview selectRow:3 inComponent:1 animated:NO];
    [self.pickerview selectRow:1 inComponent:0 animated:NO];
    
    self.selectdModel.normal_work = self.manhourTimeArr[3];
    self.selectdModel.overtime = self.oversTimeArr[1];
    
}



-(void)CancelButtonselected
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ClickLeftButtondelegate)]) {
        [self.delegate ClickLeftButtondelegate];
    }
    [self dismissview];
}
-(void)sureButtonselected
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickrightbuttontoModel:)]) {
        
        self.selectdModel.ClickBtn = YES;
        [self.delegate clickrightbuttontoModel:self.selectdModel];
    }
    [self dismissview];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickrightbuttontoModel:)]) {
        self.selectdModel.ClickBtn = NO;
        [self.delegate clickrightbuttontoModel:nil];
    }

}
-(void)setWorkTimeArr:(NSArray *)workTimeArr
{
    self.manhourTimeArr = [[NSMutableArray alloc]initWithArray:workTimeArr];;
    [self.pickerview selectRow:1 inComponent:0 animated:NO];
    self.selectdModel.normal_work = self.manhourTimeArr[1];
    [_pickerview reloadAllComponents];
    
}
-(void)setOverTimeArr:(NSArray *)overTimeArr
{
    self.overTimeArr = [[NSMutableArray alloc]initWithArray:overTimeArr];
    [self.pickerview selectRow:3 inComponent:1 animated:NO];
    self.selectdModel.overtime = self.oversTimeArr[3];
    [_pickerview reloadAllComponents];
    
}
-(NSMutableArray *)manhourTimeArr
{
    if (!_manhourTimeArr) {
        
        _manhourTimeArr = [[NSMutableArray alloc]init];
    }
    return _manhourTimeArr;
}
-(NSMutableArray *)oversTimeArr
{
    if (!_oversTimeArr) {
        
        _oversTimeArr = [[NSMutableArray alloc]init];
    }
    return _oversTimeArr;
}
-(UIPickerView *)pickerview
{
    if (!_pickerview) {
        _pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.norWorklable.frame), CGRectGetWidth(self.frame),130)];
        // 显示选中框
        _pickerview.showsSelectionIndicator=YES;
        _pickerview.dataSource = self;
        _pickerview.delegate = self;
        
        for (int index = 0; index <= 48; index ++) {
            if ((int)(index *0.5) == (index *0.5)) {
                
                [self.manhourTimeArr addObject:[NSString stringWithFormat:@"%.0f",index *0.5]];
                [self.oversTimeArr addObject:[NSString stringWithFormat:@"%.0f",index *0.5]];
            }else{
                
                [self.manhourTimeArr addObject:[NSString stringWithFormat:@"%.1f",index *0.5]];
                [self.oversTimeArr addObject:[NSString stringWithFormat:@"%.1f",index *0.5]];
            }
         

        }

        [_pickerview selectRow:16 inComponent:0 animated:NO];
        [_pickerview selectRow:0 inComponent:1 animated:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *WorkSelectedLable = (UILabel *)[self.pickerview viewForRow:16 forComponent:0];
            WorkSelectedLable.textColor = AppFontd7252cColor;
            
            UILabel *overSelectedLable = (UILabel *)[self.pickerview viewForRow:0 forComponent:1];
            overSelectedLable.textColor = AppFontd7252cColor;
        });

        _proNameStr = self.manhourTimeArr[16];
        self.selectdModel.normal_work = _proNameStr;
            
        _proTimeStr = @"0";
        self.selectdModel.overtime = _proTimeStr;

    }
    return _pickerview;
}

- (JGJRecordModePickerRemarkView *)remarkView {
    
    if (!_remarkView) {
        
        _remarkView = [[JGJRecordModePickerRemarkView alloc] initWithFrame:CGRectMake(0, 240, TYGetUIScreenWidth, 60 + 35)];
        _remarkView.remarkViewDelegate = self;
    }
    return _remarkView;
}


- (void)didSelectedRecordRemark {
    
    if ([self.delegate respondsToSelector:@selector(clickRecordRemark)]) {
        
        [self.delegate clickRecordRemark];
    }
}

- (UIView *)remarkTopLineView {
    
    if (!_remarkTopLineView) {
        
        _remarkTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 235, TYGetUIScreenWidth, 5)];
        _remarkTopLineView.backgroundColor = AppFontEBEBEBColor;
    }
    return _remarkTopLineView;
}
-(void)setWorkTimeselected:(NSString *)workTime andOverTime:(NSString *)overTime
{
    
    if ([workTime?:@"0" containsString:@"小时"]) {
        workTime = [workTime stringByReplacingOccurrencesOfString:@"小时" withString:@""];
    }
    if ([overTime?:@"0" containsString:@"小时"]) {
        overTime = [overTime stringByReplacingOccurrencesOfString:@"小时" withString:@""];
    }
    
    [self.pickerview selectRow:[workTime floatValue] * 2 inComponent:0 animated:YES];
    [self.pickerview selectRow:[overTime floatValue] * 2 inComponent:1 animated:YES];
    _proNameStr = workTime;
    self.selectdModel.normal_work = _proNameStr;
    
    _proTimeStr = overTime;
    self.selectdModel.overtime = _proTimeStr;
    

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [self.manhourTimeArr count];
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    UILabel *selectedLable = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectedLable.textColor = AppFontd7252cColor;
    
    if (component == 0) {
        
        _proNameStr = [self.manhourTimeArr objectAtIndex:row];
        self.selectdModel.normal_work = _proNameStr;
        
    } else {
        
        _proTimeStr = [self.oversTimeArr objectAtIndex:row];
        self.selectdModel.overtime = _proTimeStr;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectpickerViewleft:overTime:)]) {
        
        [self.delegate selectpickerViewleft:_proNameStr overTime:_proTimeStr];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (![self.manhourTimeArr[row] floatValue]) {
            return @"休息";
        }
        return [NSString stringWithFormat:@"%@小时",self.manhourTimeArr[row]];
    } else {
        if (![self.oversTimeArr[row] floatValue]) {
            return @"无加班";
        }
        return [NSString stringWithFormat:@"%@小时",self.oversTimeArr[row]];
        
    }
}

- (void)loadEView
{
    [self addSubview:self.bottomView];
    [_bottomView addSubview:self.topView];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.topLable];
    [self.topView addSubview:self.rightButton];
    [_bottomView addSubview:self.reminLable];
    [_bottomView addSubview:self.norWorklable];
    [_bottomView addSubview:self.overWorklable];
    [_bottomView addSubview:self.pickerview];
    [_bottomView addSubview:self.remarkView];
    [_bottomView addSubview:self.remarkTopLineView];
    
}
- (UIView *)topView
{
    if (!_topView) {
       
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 45)];
        _topView.backgroundColor = JGJMainColor;
        
    }
    return _topView;
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 50, 30)];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(CancelButtonselected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
    
}
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth-60, 7, 50, 30)];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(sureButtonselected) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightButton;
    
}
-(UILabel *)topLable
{
    if (!_topLable) {
        _topLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2-100, 7, 200, 30)];
        _topLable.textAlignment = NSTextAlignmentCenter;
        _topLable.textColor = [UIColor whiteColor];
        _topLable.font = [UIFont systemFontOfSize:15];
        _topLable.text = @"正常上班/加班时长";
        
    }
    return _topLable;
    
}
-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_topView.frame)+12, TYGetUIScreenWidth-80, 32)];
        _detailLable.textColor = [UIColor blackColor];
        _detailLable.text = @"";
        _detailLable.font = [UIFont systemFontOfSize:13];
        _detailLable.textAlignment = NSTextAlignmentCenter;
        _detailLable.layer.borderWidth = 1;
        _detailLable.layer.borderColor = [UIColor grayColor].CGColor;
        _detailLable.layer.masksToBounds = YES;
        _detailLable.layer.cornerRadius = 2.5;
        _detailLable.textColor = AppFont333333Color;
        _detailLable.backgroundColor = AppFontffffffColor;
    }
    return _detailLable;
}
- (UILabel *)reminLable
{
    if (!_reminLable) {
        
        _reminLable = [[UILabel alloc]initWithFrame:CGRectMake((TYGetUIScreenWidth - 257) / 2, CGRectGetMaxY(_topView.frame) + 15, 257, 25)];
        _reminLable.text = @"将选中的0个工人，按以下工时记录";
        _reminLable.backgroundColor = AppFontf1f1f1Color;
        _reminLable.textColor = AppFont666666Color;
        
        _reminLable.layer.masksToBounds = YES;
        _reminLable.layer.cornerRadius = 12.5;
        _reminLable.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _reminLable.layer.borderWidth = 0.5;
        _reminLable.font = [UIFont systemFontOfSize:14];
        _reminLable.textAlignment = NSTextAlignmentCenter;
        
    }
    return _reminLable;
}
-(UILabel *)norWorklable
{
    if (!_norWorklable) {
        
        _norWorklable = [[UILabel alloc]initWithFrame:[self retrunframex:65 y:CGRectGetMaxY(_topView.frame) + 55 width:80 height:18]];
        
        _norWorklable.textColor = AppFont666666Color;
        
        _norWorklable.text = @"上班时长";
        
        _norWorklable.textAlignment = NSTextAlignmentCenter;
        
        _norWorklable.font = [UIFont systemFontOfSize:AppFont24Size];
        
        UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_norWorklable.frame) - 20, CGRectGetMaxY(_topView.frame)+64, 20, 1)];
        leftLine.backgroundColor = AppFontdbdbdbColor;
        [_bottomView addSubview:leftLine];
       
        UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_norWorklable.frame) , CGRectGetMaxY(_topView.frame)+64, 20, 1)];
        rightLine.backgroundColor = AppFontdbdbdbColor;
        [_bottomView addSubview:rightLine];
    }
    
    return _norWorklable;
}
-(UILabel *)overWorklable
{
    if (!_overWorklable) {
        _overWorklable = [[UILabel alloc]initWithFrame:[self retrunframex:TYGetUIScreenWidth-135 y:CGRectGetMaxY(_topView.frame)+55 width:70 height:18]];
        
        _overWorklable.text = @"加班时长";
        
        _overWorklable.textColor = AppFont666666Color;
        
        _overWorklable.textAlignment = NSTextAlignmentCenter;
        
        _overWorklable.font = [UIFont systemFontOfSize:AppFont24Size];
        
        UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_overWorklable.frame) - 20, CGRectGetMaxY(_topView.frame)+64, 20, 1)];
        
        leftLine.backgroundColor = AppFontdbdbdbColor;
        
        [_bottomView addSubview:leftLine];
        
        UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_overWorklable.frame) , CGRectGetMaxY(_topView.frame)+64, 20, 1)];
        
        rightLine.backgroundColor = AppFontdbdbdbColor;
        
        [_bottomView addSubview:rightLine];
        
    }
    
    return _overWorklable;
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 300 + 35)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.alpha = 1;
    }
    return _bottomView;
}
-(CGRect)retrunframex:(float)x y:(float)y width:(float)width height:(float)height
{
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}
-(void)setDetailStr:(NSString *)detailStr
{
   self.detailLable.text = detailStr;
}
- (void)showPicker{
   
    [self setFrame:[self retrunframex:0 y:0 width:TYGetUIScreenWidth height:CGRectGetHeight(self.frame)]];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.bottomView];

    [UIView animateWithDuration:.5 animations:^{
   
        [_bottomView setFrame:CGRectMake(0, TYGetUIScreenHeight-335 , TYGetUIScreenWidth, 335)];

    }];
}

- (void)dismissview
{
    [self setFrame:[self retrunframex:0 y:TYGetUIScreenHeight width:TYGetUIScreenWidth height:CGRectGetHeight(self.frame)]];
    
    [UIView animateWithDuration:.5 animations:^{
        
        [_bottomView setFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 250)];
    }];
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
        pickerLabel.textColor = AppFont333333Color;
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
    
}
- (void)SetTitleAndTitleText:(NSString *)title
{
    self.topLable.text = title;

}
-(void)setReminLableAndNum:(NSString *)num
{

    _reminLable.text = [NSString stringWithFormat:@"将选中的 %@ 个工人，按以下工时记录",num];
    [_reminLable markText:num withColor:AppFontEB4E4EColor];

}
@end
