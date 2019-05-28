//
//  ATDatePicker.m
//  ATDatePicker
//
//  Created by Jam on 16/8/4.
//  Copyright © 2016年 Attu. All rights reserved.
//

#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "ATDatePicker.h"

#import "NSDate+Extend.h"

@interface ATDatePicker ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *datePickerBgView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) NSLayoutConstraint *constraint_Bottom_datePickerBgView;

@property (nonatomic, strong) NSString *dateFormatter;
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) DatePickerFinishBlock datePickerFinishBlock;
@property (nonatomic, weak) UIView *headerView;
@end

@implementation ATDatePicker

- (instancetype)initWithDatePickerMode:(UIDatePickerMode)datePickerMode DateFormatter:(NSString *)dateFormatter datePickerFinishBlock:(DatePickerFinishBlock)datePickerFinishBlock {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.datePicker.datePickerMode = datePickerMode;
        self.datePickerFinishBlock = datePickerFinishBlock;
        self.dateFormatter = dateFormatter;
        [self configSubViews];
    }
    return self;
}

- (instancetype)initWithDatePickerMode:(UIDatePickerMode)datePickerMode ATDatePickerType:(ATDatePickerType)type DateFormatter:(NSString *)dateFormatter datePickerFinishBlock:(DatePickerFinishBlock)datePickerFinishBlock {
    self = [super init];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        self.datePicker.datePickerMode = datePickerMode;
        self.datePickerFinishBlock = datePickerFinishBlock;
        self.dateFormatter = dateFormatter;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    [self addSubview:self.bgView];
    [self addSubview:self.datePickerBgView];
    [self.datePickerBgView addSubview:self.datePicker];
    
    UIView *headerView = [[UIView alloc] init];
    self.headerView = headerView;
    headerView.backgroundColor = AppFontd7252cColor;
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.datePickerBgView addSubview:headerView];
    NSArray *constraint_H_lineView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)];
    NSArray *constraint_V_lineView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(==42)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)];
    [self.datePickerBgView addConstraints:constraint_H_lineView];
    [self.datePickerBgView addConstraints:constraint_V_lineView];
    
    [headerView addSubview:self.sureButton];
    [headerView addSubview:self.cancelButton];
    
    
    NSArray *constraint_H_bgView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bgView)];
    NSArray *constraint_V_bgView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bgView)];
    NSArray *constraint_H_datePickerBgView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_datePickerBgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_datePickerBgView)];
    NSLayoutConstraint *constraint_Height_datePickerBgView = [NSLayoutConstraint constraintWithItem:self.datePickerBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:220.0f];
    self.constraint_Bottom_datePickerBgView = [NSLayoutConstraint constraintWithItem:self.datePickerBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:220.0f];
    
    NSArray *constraint_H_datePicker = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_datePicker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_datePicker)];
    NSArray *constraint_V_datePicker = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_datePicker(==170)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_datePicker)];
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_cancelButton(==60)]-gapWidth-[_sureButton(==60)]-10-|" options:0 metrics:@{@"gapWidth": [NSNumber numberWithFloat:WINDOW_WIDTH-70*2]} views:NSDictionaryOfVariableBindings(_sureButton, _cancelButton)];
    NSArray *constriant_V_cancelButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_cancelButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)];
    NSArray *constriant_V_sureButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_sureButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sureButton)];
    
    [self addConstraints:constraint_H_bgView];
    [self addConstraints:constraint_V_bgView];
    [self addConstraints:constraint_H_datePickerBgView];
    [self addConstraint:constraint_Height_datePickerBgView];
    [self addConstraint:self.constraint_Bottom_datePickerBgView];
    
    [self.datePickerBgView addConstraints:constraint_H_datePicker];
    [self.datePickerBgView addConstraints:constraint_V_datePicker];
    [headerView addConstraints:constraint_H];
    [headerView addConstraints:constriant_V_sureButton];
    [headerView addConstraints:constriant_V_cancelButton];
    
    if (self.type == ATDatePickerResetBtnType || self.type == ATDatePickerCusBtnType) {
        
        [headerView addSubview:self.titleLable];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {

            make.center.mas_equalTo(headerView.center);

            make.size.mas_equalTo(CGSizeMake(100, 32));
        }];
        
        
    }
    
//    NSDate *minDate = [NSDate dateFromString:@"2014-01-01" withDateFormat:@"yyyy-MM-dd"];
//    
//    self.minimumDate = minDate;
//    
//    NSString *date = [NSString stringWithFormat:@"%@-%@-%@", @([NSDate date].components.year + 1), @"01", @"01"];
//
//    NSDate *maxDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM-dd"];
//    
//    self.maximumDate = maxDate;
    
    
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [keyWindow addSubview:self];

    NSLayoutConstraint *constraint_Left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:keyWindow attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_Top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:keyWindow attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_Right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:keyWindow attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_Buttom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:keyWindow attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [keyWindow addConstraint:constraint_Left];
    [keyWindow addConstraint:constraint_Top];
    [keyWindow addConstraint:constraint_Buttom];
    [keyWindow addConstraint:constraint_Right];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1f animations:^{
        weakSelf.bgView.alpha = 0.5;
    }];
    
    [self performSelector:@selector(showDatePickerView) withObject:nil afterDelay:0.1f];
}

- (void)hide {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1f animations:^{
        weakSelf.bgView.alpha = 0.0;
    }];
    [self performSelector:@selector(hideDatePickerView) withObject:nil afterDelay:0.1f];
}

- (void)showDatePickerView {
    __weak typeof(self) weakSelf = self;
    self.constraint_Bottom_datePickerBgView.constant = 0;
    [UIView animateWithDuration:0.4f animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (void)hideDatePickerView {
    __weak typeof(self) weakSelf = self;
    self.constraint_Bottom_datePickerBgView.constant = 220.0f;
    [UIView animateWithDuration:0.4f animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)onClickSureButton {
    if (_datePickerFinishBlock) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:self.dateFormatter];
        _datePickerFinishBlock([formatter stringFromDate:self.datePicker.date]);
    }
    [self hide];
}

#pragma mark - 重置日期 默认是今天根据需要回调处理
-(void)resetDate {
    
    if (self.cusBtnFinishBlock) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:self.dateFormatter];
    
        self.cusBtnFinishBlock([formatter stringFromDate:[NSDate date]]);
        
    }
    
    [self hide];
}

-(void)clearDate {
    
    if (_datePickerFinishBlock) {
        
        _datePickerFinishBlock(@"");
    
    }
    [self hide];
}

- (void)setDate:(NSDate *)date {
    _date = date;
    self.datePicker.date = date;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        [_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _datePicker;
}

- (UIView *)datePickerBgView {
    if (!_datePickerBgView) {
        _datePickerBgView = [[UIView alloc] init];
        [_datePickerBgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _datePickerBgView.backgroundColor = [UIColor whiteColor];
    }
    return _datePickerBgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tapGesture.numberOfTapsRequired = 1;
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _sureButton;
}

- (UILabel *)titleLable {
    
    if (!_titleLable) {
        
        _titleLable = [[UILabel alloc] init];
        
        _titleLable.text = @"选择时间";
        
        _titleLable.font = [UIFont systemFontOfSize:15];
        
        _titleLable.textColor = [UIColor whiteColor];
        
        _titleLable.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _titleLable;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSString *title = [self butttitle];

        [_cancelButton setTitle:title forState:UIControlStateNormal];
        
        if (self.type == ATDatePickerCusBtnType) {
           
            [_cancelButton addTarget:self action:@selector(clearDate) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (self.type == ATDatePickerResetBtnType) {
            
            [_cancelButton addTarget:self action:@selector(resetDate) forControlEvents:UIControlEventTouchUpInside];
        }
        
        else {
            
            [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _cancelButton;
}

- (NSString *)butttitle {
    
    NSString *title = @"取消";
    
    switch (self.type) {
            
        case ATDatePickerDefautType:
            
            title = @"取消";
            
            break;
            
        case ATDatePickerCusBtnType:
            
            title = @"清空";
            break;
            
        case ATDatePickerResetBtnType:
            
            title = @"重置";
            
            break;
            
        default:
            break;
    }
    
    return title;
}

@end
