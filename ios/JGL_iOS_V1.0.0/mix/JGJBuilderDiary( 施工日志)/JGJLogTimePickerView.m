//
//  JGJLogTimePickerView.m
//  JGJCompany
//
//  Created by Tony on 2017/8/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogTimePickerView.h"
#import "NSString+Extend.h"
@interface JGJLogTimePickerView ()
{
//    NSString *yearStr;
//    NSString *monthStr;
}
@end
@implementation JGJLogTimePickerView
@synthesize yearArr = _yearArr;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    
}
-(void)initView
{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJLogTimePickerView" owner:self options:nil]firstObject];
    [UIView animateWithDuration:.4 animations:^{
        CGRect rect = _pickerBaseView.frame;
        rect.origin.y  = rect.origin.y - 300;
        [_pickerBaseView setFrame:rect]; 

    }];
//    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       _pickerView.showsSelectionIndicator=YES;

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), TYGetUIScreenWidth, 40)];
    view.backgroundColor = JGJMainColor;
    [self.pickerBaseView addSubview:view];
    UIButton *OkButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 100, 0, 100, 40)];
    
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    OkButton.titleLabel.font = [UIFont systemFontOfSize:15];
    OkButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [OkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];;

    [view addSubview:OkButton];
    [OkButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];;

    [view addSubview:cancelButton];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, TYGetUIScreenWidth - 220, 40)];
    label.text = @"选择时间";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    

    [self.contentView setFrame:self.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRemoveView)];
    [self.contentView addGestureRecognizer:tap];
    [self addSubview:self.contentView];

}
-(void)clickRemoveView
{
    [self removeFromSuperview];
    
}
+(void)showDatePickerAndSelfview:(UIView *)view adndelegate:(id)delegate timePickerType:(JGJLogTimeType)type andblock:(LogTimeBlock)logBlock andCurrentTime:(NSString *)time
{
    
    JGJLogTimePickerView *timePicker = [[JGJLogTimePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    timePicker.delegate = delegate;
    timePicker.logTimeType = type;
    timePicker.logBlock = logBlock;
    
    NSString *yearstr;
    NSString *monthstr;
    if (![NSString isEmpty:time]) {
    if (type == LogTimeYearType) {
        yearstr = time;
        }else{
        yearstr = [time substringWithRange:NSMakeRange(0, 4)];
        monthstr = [time substringWithRange:NSMakeRange(5, 2)];
    }
    }else{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateformatters = [[NSDateFormatter alloc]init];
    [dateformatters setDateFormat:@"MM"];
    yearstr = [dateformatter stringFromDate:[NSDate date]];
    monthstr = [dateformatters stringFromDate:[NSDate date]];
      }
    timePicker.yearTime = yearstr;
    timePicker.monthTime = monthstr;

    [timePicker.pickerView selectRow:[yearstr intValue] -2014 inComponent:0 animated:NO];
    if (type == LogTimeYearAndMonthType) {
    [timePicker.pickerView selectRow:[monthstr intValue] - 1 inComponent:1 animated:NO];
  
    }


    [[[UIApplication sharedApplication]keyWindow]addSubview:timePicker];
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_logTimeType == LogTimeYearType) {
        return self.yearArr.count;
    }else{
        if (component == 0) {
            return self.yearArr.count;
        }else{
            return self.MonthArr.count;
        }
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_logTimeType == LogTimeYearType) {
        return [[_yearArr objectAtIndex:row] stringByAppendingString:@"年"];
    }else{
        if (component == 0) {
            return [[_yearArr objectAtIndex:row] stringByAppendingString:@"年"];
        }else{
        
      return  [[self.MonthArr objectAtIndex:row] stringByAppendingString:@"月"];
        }
    
    }
return @"";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //    [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
        pickerLabel.textColor = [UIColor blackColor];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    if (_logTimeType == LogTimeYearType) {
    return 1;
    }else{
    return 2;
    }
}
- (IBAction)sureButton:(id)sender {
    if ([NSString isEmpty:_yearTime]) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy"];
        _yearTime = [dateformatter stringFromDate:[NSDate date]];
    }
    if ([NSString isEmpty:_monthTime]) {
        NSDateFormatter *dateformatters = [[NSDateFormatter alloc]init];
        [dateformatters setDateFormat:@"MM"];
        _monthTime = [dateformatters stringFromDate:[NSDate date]];
    }
    if (_monthTime.length == 1) {
        _monthTime = [@"0" stringByAppendingString:_monthTime];
    }
    if (_logTimeType == LogTimeYearAndMonthType) {
    _timeStr = [[_yearTime stringByAppendingString:@"-"] stringByAppendingString:_monthTime];
  
    }else{
        _timeStr = _yearTime;
    }
    self.logBlock(_timeStr);

    [self removeFromSuperview];
}
- (IBAction)cancelButton:(id)sender {
    [self removeFromSuperview];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_logTimeType == LogTimeYearType) {
        _yearTime = self.yearArr[row];
    }else{

        if (component == 0) {
            _yearTime = _yearArr[row];
        }else{
            _monthTime = _MonthArr[row];
        }
        

    }
}

-(void)setYearArr:(NSMutableArray *)yearArr
{
    
}

-(NSMutableArray *)yearArr
{
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int index = 2014; index < 2048; index ++) {
            NSString *obj = [NSString stringWithFormat:@"%d",index];
            [_yearArr addObject:obj];
        }
        
    }
    return _yearArr;

}
-(NSMutableArray *)MonthArr
{
    if (!_MonthArr) {
        _MonthArr = [NSMutableArray array];

        for (int index =1; index <=12 ; index ++) {
            NSString *obj = [NSString stringWithFormat:@"%d",index];
            [_MonthArr addObject:obj];
        }
    }
    return _MonthArr;

}
@end
