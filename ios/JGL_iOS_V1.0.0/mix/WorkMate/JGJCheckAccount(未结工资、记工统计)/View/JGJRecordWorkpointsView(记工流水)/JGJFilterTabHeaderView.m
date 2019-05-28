//
//  JGJFilterTabHeaderView.m
//  mix
//
//  Created by yj on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJFilterTabHeaderView.h"

#import "JGJCustomLable.h"

#import "YZGDatePickerView.h"

#import "NSDate+Extend.h"

@interface JGJFilterTabHeaderView()<YZGDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet JGJCustomLable *title;

@property (weak, nonatomic) IBOutlet JGJCustomLable *des;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIImageView *nextArrow;


@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) NSString *selDate;

@end

@implementation JGJFilterTabHeaderView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJFilterTabHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self.containView addGestureRecognizer:tap];
    
    self.title.textColor = AppFont333333Color;
    
    self.des.textColor = AppFontEB4E4EColor;
    
    self.title.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
}

- (void)setTimeInfoModel:(JGJComTitleDesInfoModel *)timeInfoModel {
    
    _timeInfoModel = timeInfoModel;
    
    self.title.text = timeInfoModel.title;
    
    self.des.text = timeInfoModel.des;
    
}

- (void)tapAction {
    
    if (self.staModel.is_change_date) {
        
        return;
    }
    
    [self.yzgDatePickerView showDatePicker];
    
    NSString *dateStr = self.des.text;
    
    self.yzgDatePickerView.date = [self selDateStr:dateStr];
    
}

- (void)setStaModel:(JGJRecordWorkStaListModel *)staModel {
    
    _staModel = staModel;
    
    NSDate *date = [self selDateStr:_staModel.date];
    
    [self handleSelStaModelDate:date];
    
    self.nextArrow.hidden  = _staModel.is_change_date;
}

- (void)YZGDataPickerSelect:(NSDate *)date {
        
    [self handleSelStaModelDate:date];
}

- (void)handleSelStaModelDate:(NSDate *)date {
    
    NSString *month = [NSString stringWithFormat:@"%@",  @(date.components.month)];
    
    NSString *year = [NSString stringWithFormat:@"%@",  @(date.components.year)];
    
    if (date.components.month < 10) {
        
        month = [NSString stringWithFormat:@"%.1ld",  date.components.month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月", year, month];
    
    self.des.text = dateStr;
    
//    self.staModel.date = [NSString stringWithFormat:@"%@-%@", year, month];
    
    self.selDate = [NSString stringWithFormat:@"%@-%@", year, month];
    
}

- (NSDate *)selDateStr:(NSString *)dateStr {
    
    NSDate *date = nil;
    
    if (![dateStr containsString:@"年"]) {
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
        
        NSArray *dateComs = [dateStr componentsSeparatedByString:@"-"];
        
        if (dateComs.count == 2) {
            
            date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
            
        }else if (dateComs.count == 3) {
            
            dateStr = [NSString stringWithFormat:@"%@-%@",dateComs[0],dateComs[1]];
            
            date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
            
        }
        
    }else {
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月"];
        
        if ([dateStr containsString:@"年"] && [dateStr containsString:@"月"] && [dateStr containsString:@"日"]) {
            
            date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月dd日"];
        }
        
        dateStr = [NSDate stringFromDate:date format:@"yyyy-MM"];
        
        date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM"];
        
    }
    
    return date;
}

- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        
        _yzgDatePickerView.delegate = self;
        
    }
    return _yzgDatePickerView;
}

@end
