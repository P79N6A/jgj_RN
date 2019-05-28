//
//  JGJCalendarCheckCategoryView.m
//  mix
//
//  Created by yj on 16/6/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarCheckCategoryView.h"
#import "UIView+GNUtil.h"
#import "TYFMDB.h"
@interface JGJCalendarCheckCategoryView ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *categoryDataSource;//获取到表中所有模型
@property (strong, nonatomic) NSMutableArray *categoryDes;//获取到表中所有分类描述
@property (strong , nonatomic) JGJCalendarModel *calendarModel;//吉凶返回模型

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewBottom;
@end
@implementation JGJCalendarCheckCategoryView
static JGJCalendarCheckCategoryView *categoryView;
+ (instancetype)calendarCheckWithCalendarModel:(JGJCalendarModel *)calendarModel{
    
    if (categoryView) {
        [categoryView removeFromSuperview];
    }
    categoryView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCalendarCheckCategoryView" owner:nil options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    categoryView.frame = window.bounds;
    [window addSubview:categoryView];
    [categoryView.pickView selectRow:calendarModel.favAvoidRow inComponent:0 animated:NO];
    [categoryView.pickView selectRow:calendarModel.favAvoidDetailRow inComponent:1 animated:NO];
    categoryView.calendarModel = calendarModel;
    categoryView.containView.y = TYGetUIScreenHeight;
    [categoryView showPickView];
    return categoryView;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count > 0) {
        [self.pickView reloadAllComponents];
    }
}

- (void)commonSet {

    NSArray *componentsFirst = @[@"宜", @"忌"];
    self.dataSource = [[NSArray alloc] initWithObjects:componentsFirst, self.categoryDes,nil];
    self.backgroundColor = TYColorRGBA(0, 0, 0, 0.5);
}

#pragma Mark - PickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *dataSource = self.dataSource[component];
    return dataSource.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *dateLable = [[UILabel alloc]init];
    dateLable.textColor = AppFont333333Color;
    dateLable.textAlignment   = NSTextAlignmentCenter;
    dateLable.backgroundColor = [UIColor clearColor];
    [dateLable setFont:[UIFont boldSystemFontOfSize:AppFont36Size]];
    NSArray *dataSource = self.dataSource[component];
    dateLable.text = [NSString stringWithFormat:@"%@", dataSource[row]];
    return dateLable;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUInteger favAvoidRow = [pickerView selectedRowInComponent:0];
    NSUInteger favAvoidDetailRow = [pickerView selectedRowInComponent:1];
    JGJCalendarModel *calendarModel = [self.categoryDataSource objectAtIndex:favAvoidDetailRow];
    NSString *selectedCategoryString = [NSString stringWithFormat:@"%@",[self.dataSource[0] objectAtIndex:favAvoidRow]];
    calendarModel.category  = selectedCategoryString;
    calendarModel.favAvoidContent = [NSString stringWithFormat:@"%@(%@)", calendarModel.category, calendarModel.jixiong];
    calendarModel.favAvoidRow = favAvoidRow;
    calendarModel.favAvoidDetailRow = favAvoidDetailRow;
    self.calendarModel = calendarModel; //保存选中模型
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0;
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.0;
    switch (component) {
        case 0:
            width = 90;
            break;
        case 1:
            width = TYGetUIScreenWidth - 90;
            break;
        default:
            break;
    }
    return width;
}
#pragma Mark - buttonAction

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissPickView];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    if (self.blockCalendar) {
        self.blockCalendar(self.calendarModel);
    }
    [self dismissPickView];
}

- (void)showPickView {
    [UIView animateWithDuration:0.5 animations:^{
        self.containView.y = TYGetUIScreenHeight - TYGetViewH(self.containView);
    }];
}

- (void)dismissPickView {

    [UIView animateWithDuration:0.5 animations:^{
        self.containView.y = TYGetUIScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self dismissPickView];
}

- (NSMutableArray *)categoryDes {

    if (!_categoryDes) {
        _categoryDes = [NSMutableArray array];
        for (JGJCalendarModel *calendarModel in self.categoryDataSource) {
            NSString *categoryDesString = [NSString stringWithFormat:@"%@:%@", calendarModel.jixiong, calendarModel.jixiong_desc];
            [_categoryDes addObject:categoryDesString];
        }
    }
    return _categoryDes;
}
- (NSArray *)categoryDataSource {
    
    if (!_categoryDataSource) {
        NSArray *dataArray = [TYFMDB searchCalendarTable:@"jgj_jixiong" sqlite:@"SELECT * FROM jgj_jixiong"];
        _categoryDataSource = [JGJCalendarModel mj_objectArrayWithKeyValuesArray:dataArray];
    }
    return _categoryDataSource;
}

- (JGJCalendarModel *)calendarModel {

    if (!_calendarModel) {
        
        _calendarModel = [[JGJCalendarModel alloc] init];
    }
    return _calendarModel;
}

@end
