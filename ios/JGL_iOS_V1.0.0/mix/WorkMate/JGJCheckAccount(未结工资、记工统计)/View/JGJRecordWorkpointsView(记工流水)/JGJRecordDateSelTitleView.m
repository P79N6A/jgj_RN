//
//  JGJRecordDateSelTitleView.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordDateSelTitleView.h"

#import "YZGDatePickerView.h"

#import "NSDate+Extend.h"

@interface JGJRecordDateSelTitleView () <YZGDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) NSIndexPath *selIndexPath;

@property (nonatomic, strong) NSDate *selDate;

@property (nonatomic, copy) NSString *dateCoverStr;

@end

@implementation JGJRecordDateSelTitleView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJRecordDateSelTitleView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.dateBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.containView.backgroundColor = [UIColor clearColor];
    
    NSDate *curDate = [NSDate date];
    
//    NSString *date = [NSDate stringFromDate:curDate format:@"yyyy-MM"];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@年-%@月", @(curDate.components.year), @(curDate.components.month)];
    
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    self.rightBtn.hidden = YES;
    
    self.dateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}


- (IBAction)leftBtnPressed:(UIButton *)sender {
    
    NSString *date = self.dateCoverStr;
    
    NSDate *selDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM"];
    
    NSDateComponents *com = [NSDate getYearAndMonthWithDate:selDate];
    
    NSInteger year = com.year;
    
    NSInteger month = com.month;
    
    if (year == 2014 && month == 1) {
        
        self.leftBtn.hidden = YES;
        
        return;
    }else {
        
        self.leftBtn.hidden = NO;
        
        self.rightBtn.hidden = NO;
    }
    
    month --;
    
    if (month == 0) {
        
        year --;
        
        month = 12;
    }
    
    NSString *cutDown = [NSString stringWithFormat:@"%@-%02ld", @(year), month];
    
    self.dateCoverStr = cutDown;
    
//    [self.dateBtn setTitle:cutDown forState:UIControlStateNormal];
    
    if (self.recordDateSelTitleViewBlock) {
        
        self.recordDateSelTitleViewBlock(cutDown);
    }
}

- (IBAction)rightBtnPressed:(UIButton *)sender {
    
    NSString *date = self.dateCoverStr;
    
    NSDate *selDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM"];
    
    NSDateComponents *com = [NSDate getYearAndMonthWithDate:selDate];

    NSInteger year = com.year;

    NSInteger month = com.month;

    NSDateComponents *maxCom = [NSDate getYearAndMonthWithDate:[NSDate date]];
    
    month ++;
    
    if (month == 13) {
        
        year ++;
        
        month = 1;
    }

    if (year == maxCom.year && month >= maxCom.month) {

        self.rightBtn.hidden = YES;

    }else {

        self.rightBtn.hidden = NO;

        self.leftBtn.hidden = NO;
    }
    
    
    NSString *riseDate = [NSString stringWithFormat:@"%@-%02ld", @(year), month];
    
    self.dateCoverStr = riseDate;
    
//    [self.dateBtn setTitle:riseDate forState:UIControlStateNormal];
    
    if (self.recordDateSelTitleViewBlock) {
        
        self.recordDateSelTitleViewBlock(riseDate);
    }
}

#pragma mark - 最大的时间
- (void)selMaxDateWithSelDate:(NSDate *)selDate {
    
    NSDateComponents *com = [NSDate getYearAndMonthWithDate:selDate];
    
    NSInteger year = com.year;
    
    NSInteger month = com.month;
    
    NSDateComponents *maxCom = [NSDate getYearAndMonthWithDate:[NSDate date]];
    self.rightBtn.hidden = NO;
    if (year == maxCom.year && month >= maxCom.month) {
        
        self.rightBtn.hidden = YES;
        
    }else if (year >= 2014 && month > 1 && year <= maxCom.year && month > maxCom.month) {
        
        self.leftBtn.hidden = NO;
        
        self.rightBtn.hidden = NO;
    }
}

#pragma mark - 最小的时间
- (void)selMinDateWithSelDate:(NSDate *)selDate {
    
    NSDateComponents *com = [NSDate getYearAndMonthWithDate:selDate];
    
    NSDateComponents *maxCom = [NSDate getYearAndMonthWithDate:[NSDate date]];
    
    NSInteger year = com.year;
    
    NSInteger month = com.month;
    
     self.leftBtn.hidden = NO;
    
    if (year == 2014 && month == 1) {
        
        self.leftBtn.hidden = YES;
        
    }else if (year >= 2014 && month > 1 && year <= maxCom.year && month > maxCom.month) {
        
        self.leftBtn.hidden = NO;
        
        self.rightBtn.hidden = NO;
    }
}

- (void)setDate:(NSString *)date {
    
    _date = date;
    
    if (self.is_change_date) {
        
        NSString *format = @"yyyy年MM月";
        
        NSArray *dateComs = [date componentsSeparatedByString:@"-"];
        
        NSDate *seldate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM-dd"];
        
        if (dateComs.count == 2) {
            
            seldate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM"];
        }
        
        NSString *month = [NSString stringWithFormat:@"%@",  @(seldate.components.month)];
        
        if (seldate.components.month < 10) {
            
            month = [NSString stringWithFormat:@"%.1ld",  seldate.components.month];
        }
        
        NSString *dateStr = [NSString stringWithFormat:@"%@年%@月", @(seldate.components.year), month];
        
        [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
        
    }else {
        
        self.dateCoverStr = date;
        
        //    [self.dateBtn setTitle:date forState:UIControlStateNormal];
        
        NSDate *curDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM"];
        
        //最小，最大时间判断左边和右边按钮的显示问题
        
        [self selMaxDateWithSelDate:curDate];
        
    }
    
    
}

- (void)setDateCoverStr:(NSString *)dateCoverStr {
    
    _dateCoverStr = dateCoverStr;
    
    NSString *format = @"yyyy-MM";
    
    NSDate *date = [NSDate dateFromString:_dateCoverStr withDateFormat:format];
    
    NSString *month = [NSString stringWithFormat:@"%@",  @(date.components.month)];
    
    if (date.components.month < 10) {
        
        month = [NSString stringWithFormat:@"%.1ld",  date.components.month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月", @(date.components.year), month];
    
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        
        _yzgDatePickerView.delegate = self;
        
    }
    return _yzgDatePickerView;
}

- (IBAction)dateBtnPressed:(UIButton *)sender {
    
    //记工变更进入不能点击
    if (self.is_change_date) {
        
        return;
    }
    
    [self.yzgDatePickerView showDatePicker];
    
    NSString *dateStr = self.dateBtn.titleLabel.text;
    
    NSDate *date = nil;
    
    if (![dateStr containsString:@"年"]) {
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
        
    }else {
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月"];
        
        dateStr = [NSDate stringFromDate:date format:@"yyyy-MM"];
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
    }

    
    self.yzgDatePickerView.date = date;
    
}

- (void)setIs_change_date:(BOOL)is_change_date {
    
    _is_change_date = is_change_date;
    
    self.leftBtn.hidden = is_change_date;
    
    self.rightBtn.hidden = is_change_date;
    
}

#pragma mark - YZGDatePickerViewDelegate

- (void)YZGDataPickerSelect:(NSDate *)date {
    
    self.selDate = date;
    
    NSString *selDate = [NSDate stringFromDate:date format:@"yyyy-MM"];
    
    self.date = selDate;

    //最小，最大时间判断左边和右边按钮的显示问题
    
    [self selMaxDateWithSelDate:date];
    
    [self selMinDateWithSelDate:date];
    
    if (self.recordDateSelTitleViewBlock) {
        
        self.recordDateSelTitleViewBlock(self.date);
    }
    
}

@end
