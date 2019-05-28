//
//  JLGDatePickerView.m
//  mix
//
//  Created by Tony on 16/1/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGDatePickerView.h"
#import "TYAnimate.h"
#import "TYShowMessage.h"
#import "NSDate+Extend.h"

@interface JLGDatePickerView ()

@property (nonatomic, copy) NSArray *weekDaysArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *rootPickerView;
@property (nonatomic, weak) IBOutlet UIView *detailContentView;//高度固定

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateViewLayoutH;
@end

@implementation JLGDatePickerView
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
    self.rootPickerView.backgroundColor = JGJMainColor;
    
    //初始化化dataPicker
    [self initDataPicker];
}

- (void)didReceiveMemoryWarning {
    self.weekDaysArray = nil;
}

#pragma mark - 日期控制器的初始化
- (void)initDataPicker{
    //UIDatePicker初始化
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];//选择date的显示模式
    
    //设置最小和最大的日期值
    [self.datePicker setMaximumDate:[NSDate date]];//设置最大日期值
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *minDate = [dateFormatter dateFromString:@"1970-01-01"];
    [self.datePicker setMinimumDate:minDate];

    //当值发生改变的时候调用的方法
    [self.datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setDatePickerMinDate:(NSString *)minDateString maxDate:(NSString *)maxDateString{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *minDate = [dateFormatter dateFromString:minDateString];
    NSDate *maxDate = [dateFormatter dateFromString:maxDateString];
    
    minDate?[self.datePicker setMinimumDate:minDate]:nil;
    maxDate?[self.datePicker setMaximumDate:maxDate]:nil;
}

- (void)setTitleLabelText:(NSString *)titleLabelText{
    self.titleLabel.text = titleLabelText;
}

//date改变的代理事件
- (void ) datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
    if ([paramDatePicker isEqual:self.datePicker] && [paramDatePicker.maximumDate compare:[NSDate date]] == NSOrderedSame)
    {
        BOOL isMoreThanRange = [paramDatePicker.date compare:paramDatePicker.maximumDate] == NSOrderedAscending;
        if (isMoreThanRange) {
            [TYShowMessage showPlaint:@"不能记录今天之后的账"];
        }else{
            NSString *titleString = [NSDate stringFromDate:paramDatePicker.date format:@"yyyy年MM月dd日 "];
            [titleString stringByAppendingString:self.weekDaysArray[[NSDate weekdayStringFromDate:paramDatePicker.date]]];
            [self setTitleLabelText:titleString];
        }
    }
}

#pragma mark - 按钮操作
- (IBAction)endSelectPickerView:(UIButton *)sender
{
    if (sender.tag == 2 && self.indexPath) {//存在indexPath
        if ([self.delegate respondsToSelector:@selector(JLGDatePickerSelect:byIndexPath:)]) {
            [self.delegate JLGDatePickerSelect:[self.datePicker date] byIndexPath:self.indexPath];
        }
    }else if(sender.tag == 2){
        if ([self.delegate respondsToSelector:@selector(JLGDataPickerSelect:)]) {
            [self.delegate JLGDataPickerSelect:[self.datePicker date]];
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
    [TYAnimate showWithView:self.detailContentView byStartframe:detailContentFrame endFrame:detailContentFrame byBlock:nil];
}

- (void)hiddenDatePicker{
    __weak typeof(self) weakSelf = self;
    [TYAnimate hiddenView:self.detailContentView byHiddenFrame:CGRectMake(0, TYGetViewH(self.contentView), TYGetViewW(self.contentView), self.dateViewLayoutH.constant) byBlock:^{
        if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
            weakSelf.hidden = YES;
            [weakSelf removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenDatePicker];
}

#pragma mark - 懒加载
- (NSArray *)weekDaysArray
{
    if (!_weekDaysArray) {
        _weekDaysArray = @[[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    
    return _weekDaysArray;
}

@end
