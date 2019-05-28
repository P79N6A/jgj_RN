//
//  JGJRecordStaFilterView.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaFilterView.h"

#import "ATDatePicker.h"

#import "NSDate+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJRecordStaFilterView ()

@property (weak, nonatomic) IBOutlet UILabel *startTime;

@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property (weak, nonatomic) IBOutlet UIImageView *startArrow;

@property (weak, nonatomic) IBOutlet UIImageView *endArrow;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

//是否是重置状态
@property (assign, nonatomic) BOOL isReset;

//是否选择开始或者结束时间
@property (assign, nonatomic) BOOL isSelTime;

//农历开始时间
@property (copy, nonatomic) NSString *lunarStTime;

//农历结束时间
@property (copy, nonatomic) NSString *lunarEnTime;

@property (weak, nonatomic) IBOutlet UILabel *lunarStTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *lunarEnTimeLable;

@property (weak, nonatomic) IBOutlet UIView *contentStView;

@property (weak, nonatomic) IBOutlet UIView *contentEnView;

@property (weak, nonatomic) IBOutlet UILabel *firItem;

@property (weak, nonatomic) IBOutlet UILabel *secItem;

@property (weak, nonatomic) IBOutlet UILabel *thirItem;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selTimeW;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIButton *checkStaBtn;

//筛选类型 所在项目、工人名字、记工分类
@property (strong, nonatomic) NSMutableArray *accounts_types;

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firItemH;


@end

@implementation JGJRecordStaFilterView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJRecordStaFilterView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    UIColor *lightColor = AppFont333333Color;
    
    self.startTime.textColor = lightColor;
    
    self.endTime.textColor = lightColor;
    
//    [self.confirmButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    //默认重置状态
    self.isReset = NO;
    
    //默认没有选择时间
    self.isSelTime = NO;
    
//    [self.contentStView.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius];
//    
//    [self.contentEnView.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius];
    
    self.contentStView.backgroundColor = [UIColor whiteColor];
    
    self.contentEnView.backgroundColor = [UIColor whiteColor];
    
    [self setInitialSelTimeButton];
    
    if (TYIS_IPHONE_5_OR_LESS) {
        
        self.selTimeW.constant = 75;
        
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    }else {
        
        self.selTimeW.constant = 98;
        
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
    }
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.startTime.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    self.endTime.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    self.filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    [self setFilterButtonStatus:NO];
    
    self.firItem.preferredMaxLayoutWidth = TYGetUIScreenWidth - 24;
    
    self.secItem.preferredMaxLayoutWidth = TYGetUIScreenWidth - 24;
    
    self.thirItem.preferredMaxLayoutWidth = TYGetUIScreenWidth - 24;
    
    self.checkStaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont24Size];
}

- (IBAction)startTimeButtonPressed:(UIButton *)sender {
    
    if (self.is_unCan_click) {
        
        return;
    }
    
    TYWeakSelf(self);
    
    ATDatePicker *startDatePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate  ATDatePickerType:ATDatePickerResetBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        if ([weakself.startTimeStr isEqualToString:dateString]) {
            
            return ;
        }else {
            
            weakself.startTimeStr = dateString;
            
            [weakself selDateAction];
        }
        
        weakself.isReset = NO;
        
        weakself.isSelTime = YES;
        
        [weakself setFilterTimeColor];
        
        

        TYLog(@"======== %@", dateString);
    }];
    
    startDatePicker.cusBtnFinishBlock = ^(NSString *dateString) {
      
        [weakself rsetEndTime];
        
        [weakself rsetStTime];
        
        [weakself selDateAction];
    };
    
    if (![self.startTime.text isEqualToString:EndTime]) {
        
        startDatePicker.maximumDate = [NSDate dateFromString:self.endTime.text withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![self.startTime.text isEqualToString:StartTime]) {
        
        startDatePicker.date = [NSDate dateFromString:self.startTime.text withDateFormat:@"yyyy-MM-dd"];
    }
    
    [startDatePicker show];
        
}


- (IBAction)endTimeButtonPressed:(UIButton *)sender {
    
    if (self.is_unCan_click) {
        
        return;
    }
    
    TYWeakSelf(self);
    
    ATDatePicker *endDatePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate  ATDatePickerType:ATDatePickerResetBtnType DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        if ([weakself.endTimeStr isEqualToString:dateString]) {
            
            return ;
        }else {
            
            weakself.endTimeStr = dateString;
            
            [weakself selDateAction];
            
        }
        
         weakself.isReset = NO;
        
        weakself.isSelTime = YES;
        
        [weakself setFilterTimeColor];
        
        TYLog(@"======== %@", dateString);
    }];
    
    endDatePicker.cusBtnFinishBlock = ^(NSString *dateString) {
        
        [weakself rsetEndTime];
        
        [weakself rsetStTime];
        
        [weakself selDateAction];
        
    };
    
    
    if (![self.startTime.text isEqualToString:StartTime]) {
        
        endDatePicker.minimumDate = [NSDate dateFromString:self.startTime.text withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![self.endTime.text isEqualToString:EndTime]) {
    
        endDatePicker.date = [NSDate dateFromString:self.endTime.text withDateFormat:@"yyyy-MM-dd"];
    }
    
   [endDatePicker show];

}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    
    if (_isSelTime) {
        
       self.isReset = !self.isReset;
        
    }else {
        
        return; //点击无效果
    }
    
    if (self.recordStaFilterViewBlock && _isSelTime && _isReset) {
        
        self.recordStaFilterViewBlock(self.startTime.text, self.endTime.text, _isReset);
        
    }else {
        
        [self rsetStTime];
        
        [self rsetEndTime];
        
        if ([self.startTime.text isEqualToString:[self rsetStTime]] && [self.endTime.text isEqualToString:[self rsetEndTime]]) {
            
            self.isSelTime = NO;
            
            [self setInitialSelTimeButton];
        }
        
        if (self.recordStaFilterViewBlock) {
            
            self.recordStaFilterViewBlock(self.startTime.text, self.endTime.text, _isReset);
        }
        
    }
    
    [self setFilterTimeColor];
    
}

#pragma mark - 选择时间回调
- (void)selDateAction {
    
    if (self.recordStaFilterViewBlock) {
        
        self.recordStaFilterViewBlock(self.startTime.text, self.endTime.text, _isReset);
    }
}

- (void)setIsReset:(BOOL)isReset {
    
    _isReset = isReset;
    
    NSString *buttonTitle = @"确定";
    
    UIColor *layerColor = AppFontEB4E4EColor;
    
    UIColor *textColor = AppFont333333Color;
    
    UIColor *backgroundColor = [UIColor whiteColor];
    
    if (_isReset) {
        
        buttonTitle = @"重置";
    
        layerColor = AppFont333333Color;
        
        textColor = AppFont333333Color;
        
        backgroundColor = [UIColor whiteColor];
        
    }
    else {

        buttonTitle = @"确定";

        layerColor = AppFontEB4E4EColor;

        textColor = [UIColor whiteColor];

        backgroundColor = AppFontEB4E4EColor;
    }
    
    [self.confirmButton.layer setLayerBorderWithColor:layerColor width:0.5 radius:5];
    
    [self.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [self.confirmButton setTitleColor:textColor forState:UIControlStateNormal];
    
    self.confirmButton.backgroundColor = backgroundColor;
}

- (void)setIsSelTime:(BOOL)isSelTime {
    
    _isSelTime = isSelTime;
    
    UIColor *layerColor = AppFontEB4E4EColor;
    
    UIColor *textColor = AppFont333333Color;
    
    UIColor *backgroundColor = [UIColor whiteColor];
    
    if (!_isSelTime) {
        
        layerColor = AppFontEB4E4EColor;
        
        backgroundColor = AppFontEB4E4EColor;
        
        textColor = [UIColor whiteColor];
        
    }else {
        
        backgroundColor = AppFontEB4E4EColor;
        
        layerColor = AppFontEB4E4EColor;
        
        textColor = [UIColor whiteColor];
    }
    
    [self.confirmButton.layer setLayerBorderWithColor:layerColor width:0.5 radius:5];
    
    [self.confirmButton setTitleColor:textColor forState:UIControlStateNormal];
    
    self.confirmButton.backgroundColor = backgroundColor;
    
}

#pragma mark - 初始按钮状态
- (void)setInitialSelTimeButton {
    
    [self.confirmButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius];
    
    [self.confirmButton setTitle:@"请选择时间" forState:UIControlStateNormal];
    
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.confirmButton.backgroundColor = AppFontEB4E4EColor;
}

#pragma mark - 设置筛选颜色
- (void)setFilterTimeColor {
    
    self.startTime.textColor = AppFont333333Color;
    
    self.endTime.textColor = AppFont333333Color;
    
}

- (void)setStartTimeStr:(NSString *)startTimeStr {
    
    _startTimeStr = startTimeStr;
    
    self.startTime.text = startTimeStr;
    
    if (![NSString isEmpty:startTimeStr]) {
        
        NSString *lunarStTime = [NSDate convertChineseDateWithDate:startTimeStr];
        
        self.lunarStTime = lunarStTime;
    }
    
}

- (void)setEndTimeStr:(NSString *)endTimeStr {
    
    _endTimeStr = endTimeStr;
        
    self.endTime.text = endTimeStr;
    
    if (![NSString isEmpty:endTimeStr]) {
        
        NSString *lunarEnTime = [NSDate convertChineseDateWithDate:endTimeStr];
        
        self.lunarEnTime = lunarEnTime;
    }
    
    NSLog(@"endlunarTime ====%@", self.lunarEnTime );
}

- (NSString *)rsetStTime {
    
    NSDate *date = [NSDate date];
    
    NSString *stTime = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @"01", @"01"]];
    
    self.startTimeStr = stTime;
    
    self.lunarStTime = @"正月初一";
    
    return stTime;
    
}

- (NSString *)rsetEndTime {
    
    NSDate *date = [NSDate date];

    NSString *format = @"yyyy-MM-dd";
    
    NSString *enTime = [NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @(date.components.month), @(date.components.day)];
    
    NSDate *end_date = [NSDate dateFromString:enTime withDateFormat:format];
    
    enTime = [NSDate stringFromDate:end_date format:format];

    self.endTimeStr = enTime;
    
    NSString *lunarEnTime = [NSDate convertChineseDateWithDate:enTime];
    
    self.lunarEnTime = lunarEnTime;

    return enTime;
}

- (void)setLunarStTime:(NSString *)lunarStTime {
    
    _lunarStTime = lunarStTime;
    
    self.lunarStTimeLable.text = [NSString stringWithFormat:@"(%@)", lunarStTime];
}

- (void)setLunarEnTime:(NSString *)lunarEnTime {
    
    _lunarEnTime = lunarEnTime;
    
    self.lunarEnTimeLable.text = [NSString stringWithFormat:@"(%@)", lunarEnTime];;
    
}

#pragma mark - 筛选条件改变颜色
- (void)setFilterButtonStatus:(BOOL)isNormal {
    
    UIColor *color = !isNormal ? AppFont333333Color :AppFontEB4E4EColor;
    
    [self.filterButton setImage:[UIImage imageNamed:!isNormal ? @"un_filter_icon" : @"filtered_icon" ] forState:UIControlStateNormal];
    
    [self.filterButton setTitleColor:color forState:UIControlStateNormal];
    
    [self.filterButton.layer setLayerBorderWithColor:color width:1 radius:3];
    
}

- (IBAction)filterButtonPressed:(UIButton *)sender {
    
    if (self.staFilterButtonBlock) {
        
        self.staFilterButtonBlock(self);
    }
    
}

- (IBAction)checkStaButtonPressed:(UIButton *)sender {
    
    if (self.staTimeBlock) {
        
        self.staTimeBlock(self);
    }
}

- (void)setIs_hidden_checkStaBtn:(BOOL)is_hidden_checkStaBtn {
    
    _is_hidden_checkStaBtn = is_hidden_checkStaBtn;
    
    self.checkStaBtn.hidden = is_hidden_checkStaBtn;
    
}

- (void)setIs_hidden_searchBtn:(BOOL)is_hidden_searchBtn {
    
    _is_hidden_searchBtn = is_hidden_searchBtn;
    
    self.filterButton.hidden = is_hidden_searchBtn;
    
}

- (void)setFilterRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel staFilterAccountypesBlock:(JGJRecordStaFilterAccountypesBlock)staFilterAccountypesBlock {
    
    self.recordWorkStaModel = recordWorkStaModel;
    
    if (staFilterAccountypesBlock) {
        
        staFilterAccountypesBlock(recordWorkStaModel, [self staFilterViewHeight]);
        
    }
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    self.accounts_types = [[NSMutableArray alloc] init];
    
    NSString *proname = _recordWorkStaModel.pro_name;
    
    if (![NSString isEmpty:proname]) {
        
        NSDictionary *dic = @{@"title" : [NSString stringWithFormat:@"所在项目：%@", proname],
                              @"remark" : proname
                              };
        
        [self.accounts_types addObject:dic];
        
    }
    
    NSString *name = _recordWorkStaModel.name;
    
    if (![NSString isEmpty:name]) {
        
        NSString *role = [NSString stringWithFormat:@"%@", JLGisLeaderBool?@"工人名字：" :@"班组长名字："];
        
        NSDictionary *dic = @{@"title" : [NSString stringWithFormat:@"%@%@",role, name],
                              @"remark" : name
                              };
        
        [self.accounts_types addObject:dic];
        
    }
    
    NSString *accounts_type_name = _recordWorkStaModel.accounts_type_name;
    
    if (![NSString isEmpty:accounts_type_name]) {
        
        NSDictionary *dic = @{@"title" : [NSString stringWithFormat:@"记工分类：%@", accounts_type_name],
                              @"remark" : accounts_type_name
                              };
        
        [self.accounts_types addObject:dic];
    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    if (self.accounts_types.count == 1) {
        
        NSDictionary *dic = self.accounts_types.firstObject;
        
        self.firItem.text = dic[@"title"];
        
        [self.firItem markText:dic[@"remark"] withFont:font color:AppFont000000Color];
        
    }else if (self.accounts_types.count == 2) {
        
        NSDictionary *firDic = self.accounts_types.firstObject;
        
        self.firItem.text = firDic[@"title"];
        
        [self.firItem markText:firDic[@"remark"] withFont:font color:AppFont000000Color];
        
        NSDictionary *secDic = self.accounts_types[1];
        
        self.secItem.text = secDic[@"title"];
        
        [self.secItem markText:secDic[@"remark"] withFont:font color:AppFont000000Color];
        
    }else if (self.accounts_types.count == 3) {
        
        NSDictionary *firDic = self.accounts_types[0];
        
        self.firItem.text = firDic[@"title"];
        
        [self.firItem markText:firDic[@"remark"] withFont:font color:AppFont000000Color];
        
        
        NSDictionary *secDic = self.accounts_types[1];
        
        self.secItem.text = secDic[@"title"];
        
        [self.secItem markText:secDic[@"remark"] withFont:font color:AppFont000000Color];

        
        NSDictionary *thirDic = self.accounts_types[2];
        
        self.thirItem.text = thirDic[@"title"];
        
        [self.thirItem markText:thirDic[@"remark"] withFont:font color:AppFont000000Color];
        
    }
    
    self.firItem.hidden = NO;
    
    self.secItem.hidden = NO;
    
    self.thirItem.hidden = NO;
    
    if (self.accounts_types.count == 0) {
        
        self.firItem.hidden = YES;
        
        self.secItem.hidden = YES;
        
        self.thirItem.hidden = YES;
        
    }else  if (self.accounts_types.count == 1) {
        
        self.secItem.hidden = YES;
        
        self.thirItem.hidden = YES;
        
    }else if (self.accounts_types.count == 2) {
        
        self.thirItem.hidden = YES;
    }
    
}

- (CGFloat)defaultHeight {
    
    return 100;
}

-(CGFloat)staFilterViewHeight {
    
    CGFloat height = 80;
    
    if (self.accounts_types.count == 2) {
        
        height = 100;
        
    }else if (self.accounts_types.count == 3) {
        
        height = 122;
        
    }else if (self.accounts_types.count == 1) {
        
        height = 80;
        
    } else {
        
        height = [self defaultHeight];
        
    }
    
    CGFloat proH = 0;
    
    if (![NSString isEmpty:_recordWorkStaModel.pro_name]) {
        
        NSString *proname = [NSString stringWithFormat:@"所在项目：%@", _recordWorkStaModel.pro_name];
        
        proH = [NSString stringWithContentWidth:TYGetUIScreenWidth - 24 content:proname font:AppFont30Size] + 2;
        
        height = height - 14 + proH;
        
        self.firItemH.constant = proH;
        
    }
        
    return height;
}

@end
