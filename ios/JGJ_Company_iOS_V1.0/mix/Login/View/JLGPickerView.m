//
//  JLGPickerView.m
//  HuDuoDuoCustomer
//
//  Created by jizhi on 15/9/21.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import "JLGPickerView.h"
#import "TYAnimate.h"

//动画时间
#define durationTimeFloat 0.5

@interface JLGPickerView (){

}

@property (nonatomic, assign) BOOL isMulti;
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  finish:第一个保存的是indexPath,第二个保存的是数据，如果是取消，则还有第三个元素
 */
@property (nonatomic, strong) NSMutableArray *finishArray;
@property (nonatomic, strong) NSMutableArray *selectedComponentsArray;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIPickerView *selectPicker;
//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;

@end

@implementation JLGPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        // Initialization code
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
    self.contentView.layer.cornerRadius = 5;
    self.isShowEditButton = NO; //1.4.5增加编辑按钮
}

- (void)setAllSelectedComponents:(NSArray *)selectedComponentsArray{
    if (selectedComponentsArray) {
        self.selectedComponentsArray = [selectedComponentsArray mutableCopy];
    }
}

- (void)showPickerByIndexPath:(NSIndexPath *)indexPath dataArray:(NSArray *)dataArray title:(NSString *)title isMulti:(BOOL )isMulti{
    
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }

    self.isMulti = isMulti;
    self.indexPath = indexPath;
    self.titleLabel.text = title;
    self.dataArray = [dataArray mutableCopy];
    [self.finishArray removeAllObjects];
    
    //出现的动画
    self.hidden = NO;
    [self.selectPicker reloadAllComponents];
    
    __weak typeof(self) weakSelf = self;
    [self.selectedComponentsArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        [weakSelf.selectPicker selectRow:[obj integerValue] inComponent:idx animated:NO];
        UILabel *statusLable = (UILabel *)[weakSelf.selectPicker viewForRow:0 forComponent:0];
        statusLable.textColor = AppFontd7252cColor;
    }];
    
    if (self.selectedComponentsArray.count == 0) {
        UILabel *statusLable = (UILabel *)[self.selectPicker viewForRow:0 forComponent:0];
        statusLable.textColor = AppFontd7252cColor;
    }

    [UIView animateWithDuration:durationTimeFloat animations:^
     {
         weakSelf.pickerView.frame = CGRectMake(0, TYGetViewH(weakSelf.contentView) - TYGetViewH(weakSelf.pickerView), TYGetViewW(weakSelf.contentView), weakSelf.pickerViewLayoutH.constant);
     } completion:^(BOOL finished)
     {
         if (finished)
         {
             if (weakSelf.selectedComponentsArray.count > 0) {
                 [weakSelf.selectedComponentsArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
                     [weakSelf setFinishArrayDatainComponent:idx row:[obj integerValue]];
                 }];
             }else{
                 [weakSelf setFinishArrayDatainComponent:0 row:0];
             }

             [UIView animateWithDuration:durationTimeFloat/2.0 animations:^
              {
                  weakSelf.pickerView.frame = CGRectMake(0, TYGetViewH(weakSelf.contentView) - TYGetViewH(weakSelf.pickerView), TYGetViewW(weakSelf.contentView), weakSelf.pickerViewLayoutH.constant);
              }];
         }
     }];
}

- (void)setIsShowEditButton:(BOOL)isShowEditButton {
    _isShowEditButton = isShowEditButton;
    if (!_isShowEditButton) {
        self.cancelButtonW.constant = 0;
        self.editButton.hidden = YES;
    } else {
        self.cancelButtonW.constant = 50;
        self.editButton.hidden = NO;
    }
}

- (void)hiddenPicker{
    self.subTitleLabel.text = @"";
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:durationTimeFloat animations:^{
         weakSelf.pickerView.frame = CGRectMake(0, TYGetViewH(weakSelf.contentView), TYGetViewW(weakSelf.contentView), weakSelf.pickerViewLayoutH.constant);
     }completion:^(BOOL finished) {
         [weakSelf removeFromSuperview];
         weakSelf.hidden = YES;
     }];
}

#pragma mark - setPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.isMulti == YES) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.isMulti == YES) {
        NSArray *rowArray = self.dataArray[component];
        return rowArray.count;
    }else{
        return self.dataArray.count;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (self.isMulti == YES) {
//        NSArray *rowArray = self.dataArray[component];
//        return rowArray[row];
//    }else{
//        return self.dataArray[row][@"name"];
//    }
//}

-(UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *statuslable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
    statuslable.backgroundColor = [UIColor whiteColor];
    statuslable.font = [UIFont systemFontOfSize:AppFont34Size];
    statuslable.textAlignment = NSTextAlignmentCenter;
    if (self.isMulti == YES) {
        NSArray *rowArray = self.dataArray[component];
        statuslable.text = rowArray[row];
    }else{
        statuslable.text = self.dataArray[row][@"name"];
    }
    statuslable.textColor = AppFont333333Color;
    return statuslable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.isMulti == YES) {
        return TYGetViewW(self.contentView)/self.dataArray.count;
    }else{
        return TYGetViewW(self.contentView);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *statusLable = (UILabel *)[pickerView viewForRow:row forComponent:component];
    statusLable.textColor = AppFontd7252cColor;
    [self setFinishArrayDatainComponent:component row:row];
}

- (void)setFinishArrayDatainComponent:(NSInteger)component row:(NSUInteger )row{
    if (self.dataArray.count < component) {
        return;
    }
    
    if (self.isMulti == YES) {
        [self.finishArray insertObject:self.dataArray[component][row] atIndex:component];
    }else{
        if (self.dataArray.count > 0) {
            self.finishArray[0] = self.dataArray[row];
        }
    }
}

#pragma mark - 按钮操作
- (IBAction)endSelectPickerView:(UIButton *)sender
{
    [self hiddenPicker];
    
    if (!self.indexPath) {
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.finishArray addObject:self.indexPath];
    if (sender.tag == 102)
    {
        if ([self.delegate respondsToSelector:@selector(JLGPickerViewSelect:)]) {
            [self.delegate JLGPickerViewSelect:self.finishArray];
        }
    }
    if (sender.tag == 101)
    {
        [self.finishArray addObject:@"取消"]; //这里还有一个编辑作用
        if (![self.leftButton.titleLabel.text isEqualToString:@"取消"]) { //不是取消按钮才执行
            if ([self.delegate respondsToSelector:@selector(JLGPickerViewSelect:)]) {
                [self.delegate JLGPickerViewSelect:self.finishArray];
            }
        }
    }
//    1.4.5新增编辑按钮
    if (sender.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(JGJPickViewEditButtonPressed:)]) {
            [self.delegate JGJPickViewEditButtonPressed:self.dataArray];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenPicker];
}

#pragma mark - lazy
- (NSMutableArray *)finishArray
{
    if (!_finishArray) {
        _finishArray = [[NSMutableArray alloc] init];
    }
    return _finishArray;
}

- (NSMutableArray *)selectedComponentsArray
{
    if (!_selectedComponentsArray) {
        _selectedComponentsArray = [[NSMutableArray alloc] init];
    }
    return _selectedComponentsArray;
}


@end
