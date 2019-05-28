//
//  BMDatePickerView.m
//  BMDeliverySpecialists
//
//  Created by 1 on 16/2/16.
//  Copyright © 2016年 BlueMoon. All rights reserved.
//

#import "BMDatePickerView.h"

@interface BMDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

// 透明view 点击效果
@property (weak, nonatomic) IBOutlet UIView *clearTapClick;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic,strong)NSArray *citiesArray;
@property (strong, nonatomic) NSArray *arr;

@property (weak, nonatomic) IBOutlet UIButton      *certainButton;    // 确定按钮
@property (weak, nonatomic) IBOutlet UIButton      *cancelButton;     // 取消按钮
@property (weak, nonatomic) IBOutlet UILabel       *dateLabel;        // 显示日期标签

@end

@implementation BMDatePickerView
/**
 *  懒加载
 */
-(NSArray *)citiesArray {
    
    if (!_citiesArray) {
        
        NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
        
        [customDateFormatter setDateFormat:@"yyyy"];
        NSInteger year = [[customDateFormatter stringFromDate:[NSDate date]] integerValue];
        
        [customDateFormatter setDateFormat:@"MM"];
        NSInteger mon = [[customDateFormatter stringFromDate:[NSDate date]] integerValue];
        
        NSMutableArray *muarr = [NSMutableArray array];
        for (int i = kMIN_YEAR; i <= year; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = [NSString stringWithFormat:@"%d年",i];

            NSMutableArray *arr = [NSMutableArray array];
            if (i == year) {
                
                for (int j = 1; j <= mon; j++) {
                    
                    if (j < 10) {
                        [arr addObject:[NSString stringWithFormat:@"0%d月",j]];
                    }else{
                        [arr addObject:[NSString stringWithFormat:@"%d月",j]];
                    }
                }
                dict[@"cities"] = arr;
            }else{
                NSArray *a = @[@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];
                arr = [NSMutableArray arrayWithArray:a];
                dict[@"cities"] = arr;
            }
            
            [muarr addObject:dict];
        }
        _citiesArray = [NSArray arrayWithArray:muarr];
    }
    return _citiesArray;
}

+ (instancetype)BMDatePickerViewCertainActionBlock:(SelectActionBlock)selectActionBlock {
    
    BMDatePickerView *timeSelectPickView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    timeSelectPickView.frame = [UIScreen mainScreen].bounds;
    
    timeSelectPickView.backgroundColor = [UIColor clearColor];
    
    [timeSelectPickView.clearTapClick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:timeSelectPickView action:@selector(clearTapClickclearTapClick)]];
    
    timeSelectPickView.selectActionBlock = selectActionBlock;
    
    return timeSelectPickView;
}

- (void)clearTapClickclearTapClick {
    
    NSInteger i = [self.pickView selectedRowInComponent:0];
    NSInteger j = [self.pickView selectedRowInComponent:1];
    NSLog(@"%@ - %@",self.citiesArray[i][@"name"],self.citiesArray[i][@"cities"][j]);
    
    [self  removeFromSuperview];
}

- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];

    NSInteger maxRow1 = self.citiesArray.count-1;
    
    NSInteger maxRow2 = [self.citiesArray.lastObject[@"cities"] count]-1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickView selectRow:maxRow1 inComponent:0 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pickerView:self.pickView didSelectRow:maxRow2 inComponent:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.pickView selectRow:maxRow2 inComponent:1 animated:YES];
                NSInteger i = [self.pickView selectedRowInComponent:0];
                NSInteger j = [self.pickView selectedRowInComponent:1];
                NSLog(@"%@ - %@",self.citiesArray[i][@"name"],self.citiesArray[i][@"cities"][j]);
                NSString *string = [NSString stringWithFormat:@"%@%@",self.citiesArray[i][@"name"],self.citiesArray[i][@"cities"][j]];
                self.dateLabel.text = string;
            });
        });
    });
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.citiesArray.count;
    }
    else {
        NSInteger seleProIndx = [pickerView selectedRowInComponent:0];
        NSDictionary *dict = self.citiesArray[seleProIndx];
        NSArray *array = dict[@"cities"];
        _arr = [NSArray arrayWithArray:array];
        return _arr.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        NSDictionary * city = self.citiesArray[row];
        return city[@"name"];
    }else{
        return self.arr[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
    NSInteger i = [self.pickView selectedRowInComponent:0];
    NSInteger j = [self.pickView selectedRowInComponent:1];
    NSString *string = [NSString stringWithFormat:@"%@%@",self.citiesArray[i][@"name"],self.citiesArray[i][@"cities"][j]];
    self.dateLabel.text = string;
}

//取消按钮
- (IBAction)cancelAction:(id)sender {
    
    [self clearTapClickclearTapClick];
}

//确定按钮
- (IBAction)certainAction:(id)sender {
    
    [self clearTapClickclearTapClick];
    if (self.selectActionBlock) {
        NSInteger i = [self.pickView selectedRowInComponent:0];
        NSInteger j = [self.pickView selectedRowInComponent:1];
        NSString *str1 = self.citiesArray[i][@"name"];
        
        NSString *str2 = self.citiesArray[i][@"cities"][j];
        NSInteger ind2 = str2.integerValue;
        
        NSString *string = @"";
        
        if (ind2 < 9) {
            string = [NSString stringWithFormat:@"%ld0%ld",str1.integerValue,ind2];
        }else{
            string = [NSString stringWithFormat:@"%ld%ld",str1.integerValue,ind2];
        }
        self.selectActionBlock(string);
    }
}

@end
