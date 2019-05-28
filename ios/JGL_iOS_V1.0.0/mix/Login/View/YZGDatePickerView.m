//
//  YZGDatePickerView.m
//  mix
//
//  Created by Tony on 16/3/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGDatePickerView.h"
#import "TYAnimate.h"
#import "NSDate+Extend.h"

static NSString *const yearString = @"yearString";
static NSString *const monthString = @"monthString";

@interface YZGDatePickerView ()
<
    UIPickerViewDelegate,
    UIPickerViewDataSource
>
{
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_selectedDate;
    
    NSInteger _leftIndex;
    NSInteger _rightIndex;
}
@property (strong, nonatomic) NSArray *arr;

@property (nonatomic,strong)NSArray *datesArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *detailContentView;//高度固定

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateViewLayoutH;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation YZGDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}


#pragma mark - pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.datesArray.count;
    }
    else {
        NSInteger seleProIndx = [pickerView selectedRowInComponent:0];
        NSDictionary *dict = self.datesArray[seleProIndx];
        NSArray *array = dict[monthString];
        _arr = [NSArray arrayWithArray:array];
    
        return _arr.count;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    [mycom1 setFont:[UIFont systemFontOfSize:24]];
    mycom1.textColor = AppFont333333Color;
    
    if (component == 0) {
        
        if (_leftIndex == row) {
            
            UILabel *selectedLable = (UILabel *)[self.pickView viewForRow:row forComponent:component];
            selectedLable.textColor = AppFontd7252cColor;
        }
        NSDictionary * year = self.datesArray[row];
        mycom1.text = year[yearString];
        
        
    } else {
        
        if (_rightIndex == row) {
            
            UILabel *selectedLable = (UILabel *)[self.pickView viewForRow:row forComponent:component];
            selectedLable.textColor = AppFontd7252cColor;
        }
        
        mycom1.text = self.arr[row];
    }
    
    return mycom1;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        [pickerView reloadComponent:1];
    }
    
    UILabel *selectedLable = (UILabel *)[self.pickView viewForRow:row forComponent:component];
    selectedLable.textColor = AppFontd7252cColor;
}

#pragma mark - 按钮操作
- (IBAction)endSelectPickerView:(UIButton *)sender
{
    NSDate *selectDate;
    if (sender.tag == 2) {
        NSInteger i = [self.pickView selectedRowInComponent:0];
        NSInteger j = [self.pickView selectedRowInComponent:1];
        NSString *str1 = self.datesArray[i][yearString];
        
        NSString *str2 = self.datesArray[i][monthString][j];
        NSInteger ind2 = str2.integerValue;
        
        NSString *string = @"";
        
        if (ind2 <= 9) {
            string = [NSString stringWithFormat:@"%ld0%ld",str1.integerValue,ind2];
        }else{
            string = [NSString stringWithFormat:@"%ld%ld",str1.integerValue,ind2];
        }
        
        selectDate = [NSDate dateFromString:string withDateFormat:@"yyyyMM"];
    }
    
    if (sender.tag == 2 && self.indexPath) {//存在indexPath
        if ([self.delegate respondsToSelector:@selector(YZGDatePickerSelect:byIndexPath:)]) {
            [self.delegate YZGDatePickerSelect:selectDate byIndexPath:self.indexPath];
        }
    }else if (sender.tag == 2){
        if ([self.delegate respondsToSelector:@selector(YZGDataPickerSelect:)]) {
            [self.delegate YZGDataPickerSelect:selectDate];
        }
    }
    
    [self hiddenDatePicker];
}

- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    [self showDatePicker];
}

- (void)showDatePicker{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
    //出现的动画
    self.hidden = NO;
    
    CGRect detailContentFrame = CGRectMake(0, TYGetViewH(self.contentView) - TYGetViewH(self.detailContentView), TYGetViewW(self.contentView), self.dateViewLayoutH.constant);
    [TYAnimate showWithView:self.detailContentView byStartframe:detailContentFrame endFrame:detailContentFrame byBlock:^{
    
#pragma mark - 此处改成默认显示已经选择的时间
        NSInteger maxRow1 = self.datesArray.count-1;
        NSInteger maxRow2 = 0;
        
        if (_date) {
            _selectedDate = _date;
            maxRow2 = [self acorrdingDateSelectpickRow:_date?:[NSDate date]] - 1;
            for (int i = 0;i<self.datesArray.count;i++) {
                NSString *yearStr = self.datesArray[i][@"yearString"];
                NSString *yeardate = [NSString stringWithFormat:@"%ld",(long)[self acorrdingDateSelectpickRowyear:_selectedDate?:[NSDate date]]];
                if ([yearStr containsString:yeardate]) {
                    maxRow1 = i;
                }
                
            }

        }
        
        if (_defultTime) {
            
            maxRow2 = [self acorrdingDateSelectpickRow:_selectedDate?:[NSDate date]] - 1;
        
            for (int i = 0;i<self.datesArray.count;i++) {
            
                NSString *yearStr = self.datesArray[i][@"yearString"];
            
                NSString *yeardate = [NSString stringWithFormat:@"%ld",(long)[self acorrdingDateSelectpickRowyear:_selectedDate?:[NSDate date]]];
            
                if ([yearStr containsString:yeardate]) {
               
                    maxRow1 = i;
            
                }
         
            }
        }
        [self.pickView selectRow:maxRow1 inComponent:0 animated:YES];
        [self.pickView reloadComponent:1];
        [self.pickView selectedRowInComponent:0];
        [self.pickView selectedRowInComponent:1];
        [self.pickView selectRow:maxRow2 inComponent:1 animated:YES];
        _leftIndex = maxRow1;
        _rightIndex = maxRow2;
    }];
}

- (NSInteger)acorrdingDateSelectpickRow:(NSDate *)date
{
    NSDate * currentDate =_selectedDate?:[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                       fromDate:currentDate];
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    NSInteger day = [comps day];
    
    return month;
}
- (NSInteger)acorrdingDateSelectpickRowyear:(NSDate *)date
{
    NSDate * currentDate =_selectedDate?:[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                       fromDate:currentDate];
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    NSInteger day = [comps day];
    
    return year;
}

- (void)hiddenDatePicker{
    
    __weak typeof(self) weakSelf = self;
    [TYAnimate hiddenView:self.detailContentView byHiddenFrame:CGRectMake(0, TYGetViewH(self.contentView), TYGetViewW(self.contentView), self.dateViewLayoutH.constant) byBlock:^{
        if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
            weakSelf.hidden = YES;
            [weakSelf removeFromSuperview];
            
            [self.pickView selectRow:self.datesArray.count-1 inComponent:0 animated:YES];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenDatePicker];
}

#pragma mark - 设置最大日期和最小日期
- (void)setDatePickerMinDate:(NSString *)minDateString maxDate:(NSString *)maxDateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _minDate = [dateFormatter dateFromString:minDateString];
    _maxDate = [dateFormatter dateFromString:maxDateString];
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    
    _selectedDate = selectedDate;
}

/**
 *  懒加载
 */
-(NSArray *)datesArray {
    
    if (!_datesArray) {
        if (!_minDate) {
            _minDate = [NSDate dateFromString:@"2014-01-01" withDateFormat:@"yyyy-MM-dd"];
        }
        
        if (!_maxDate) {
            _maxDate = [NSDate date];
        }
        
        NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
        
        [customDateFormatter setDateFormat:@"yyyy"];
        NSInteger year = [[customDateFormatter stringFromDate:_maxDate] integerValue];
        
        [customDateFormatter setDateFormat:@"MM"];
        NSInteger mon = [[customDateFormatter stringFromDate:_maxDate] integerValue];
        
        NSInteger minYear = [[NSDate stringFromDate:_minDate format:@"yyyy"] integerValue];
        NSMutableArray *muarr = [NSMutableArray array];
        for (NSInteger i = minYear; i <= year; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[yearString] = [NSString stringWithFormat:@"%ld",(long)i];
            
            NSMutableArray *arr = [NSMutableArray array];
            if (i == year) {
                for (int j = 1; j <= mon; j++) {
                    if (j < 10) {
                        [arr addObject:[NSString stringWithFormat:@"0%d",j]];
                    }else{
                        [arr addObject:[NSString stringWithFormat:@"%d",j]];
                    }
                }
                dict[monthString] = arr;
            }else{
                NSArray *a = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
                arr = [NSMutableArray arrayWithArray:a];
                dict[monthString] = arr;
            }
            
            [muarr addObject:dict];
        }
        _datesArray = [NSArray arrayWithArray:muarr];
    }
    return _datesArray;
}
@end
