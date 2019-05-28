//
//  JGJManHourPickerView.m
//  mix
//
//  Created by Tony on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJManHourPickerView.h"

@interface JGJManHourPickerView()
<
UIPickerViewDataSource,

UIPickerViewDelegate,
JGJManHourPickerHalfOrOneSelectedViewDelegate
>{
    
    BOOL _isContractType;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *halfOrOneSelectedViewHieght;



@end
@implementation JGJManHourPickerView

- (instancetype)initWithFrame:(CGRect)frame showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    if (self = [super initWithFrame:frame]) {
        
        self.manHourType = ManhourType;
        self.hourHalfType = hourHalfType;
        self.delegate = delegate;
        self.isManHourTime = manHour;
        self.noShowRest = noShowRest;
        self.nowManTime = yzgGetBillModel.manhour?:0;
        self.nowOverTime = yzgGetBillModel.overtime?:0;
        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = yzgGetBillModel;
        
        [self loadView];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isContractType:(BOOL)isContractType {
    
    if (self = [super initWithFrame:frame]) {
        
        self.manHourType = ManhourType;
        self.hourHalfType = hourHalfType;
        self.delegate = delegate;
        self.isManHourTime = manHour;
        self.noShowRest = noShowRest;
        self.nowManTime = yzgGetBillModel.manhour?:0;
        self.nowOverTime = yzgGetBillModel.overtime?:0;
        _isContractType = isContractType;
        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = yzgGetBillModel;
        
        [self loadView];
        
    }
    return self;
}
- (void)loadView
{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    [contentView setFrame:self.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfView)];
    [contentView addGestureRecognizer:tap];
    [self addSubview:contentView];
    
    _halfOrOneSelectedViewHieght.constant = 0;
    _halfOrOneSelectedView.halfOrOneDelegate = self;
    self.JGJPickerView.delegate = self;
    self.JGJPickerView.dataSource = self;
    
    [UIView animateWithDuration:.2 animations:^{
        self.bottomConstance.constant = 0;
    }];
    if (self.manHourType == JGJManhourOnelineType) {
        
    }else{
        
    }
    if (self.hourHalfType == JGJManhourOneHalfType) {
        int index;
        if (_noShowRest) {
            index = 2;
#pragma mark - 设置薪资模板  没有上班时间和加班时间
            if (_isContractType) {
                
                self.nowManTime = self.yzgGetBillModel.unit_quan_tpl.w_h_tpl?:0;
                self.nowOverTime = self.yzgGetBillModel.unit_quan_tpl.o_h_tpl?:0;
            }else {
                
                self.nowManTime = self.yzgGetBillModel.set_tpl.w_h_tpl?:0;
                self.nowOverTime = self.yzgGetBillModel.set_tpl.o_h_tpl?:0;
            }
            
        }else{
            index = 0;
        }
        for (int i = index; i <= 48; i ++) {
            if ((int)(i*0.5) == i *0.5) {
                
                [self.oneLineArr addObject:[NSString stringWithFormat:@"%.0f",i*0.5]];
                [self.twoLineArr addObject:[NSString stringWithFormat:@"%.0f",i*0.5]];
                
            }else{
                
                [self.oneLineArr addObject:[NSString stringWithFormat:@"%.1f",i*0.5]];
                [self.twoLineArr addObject:[NSString stringWithFormat:@"%.1f",i*0.5]];
            }
        }

    }else{
        
        for (int i = 0; i <= 24; i ++) {
            
            [self.oneLineArr addObject:[NSString stringWithFormat:@"%d",i*1]];
            [self.twoLineArr addObject:[NSString stringWithFormat:@"%d",i*1]];

        }
    }
    
    //设置默认值 一行
    if (self.manHourType == JGJManhourOnelineType) {
        NSInteger index = 0;
        
        if (_noShowRest) {//设置薪资模板
            if (_isManHourTime) {
                index = self.nowManTime *2 - 2;
                
                if (index < 0) {
                    
                    index = 14;
                }
            }else{
                
                index = self.nowOverTime *2 - 2;
                
                if (index < 0) {
                    
                    index = 10;
                }
                
            }
        }else{//选择上班时间
            if (_isManHourTime) {
                index = self.nowManTime *2;
            }else{
                index = self.nowOverTime *2;
            }
        }
        
        
        if (self.isManHourTime) {
   
            if (self.nowManTime * 2 < self.oneLineArr.count) {
                [self.JGJPickerView selectRow:index inComponent:0 animated:YES];
                self.manHourStr = [NSString stringWithFormat:@"%.1f",self.nowManTime];
            }
        }else{
            if (self.nowOverTime *2 < self.twoLineArr.count) {
                [self.JGJPickerView selectRow:index inComponent:0 animated:YES];
                self.overTimeStr = [NSString stringWithFormat:@"%.1f",self.nowOverTime];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadPickerViewFromRow:index andFromComponent:0];
        });
        
    }else{
        if (self.isManHourTime) {
            if (self.nowManTime *2 < self.oneLineArr.count) {
                
                [self.JGJPickerView selectRow:self.nowManTime * 2 inComponent:0 animated:YES];
              
                self.manHourStr = [NSString stringWithFormat:@"%.1f",self.nowManTime];
                
            }
        }else{
            if (self.nowOverTime *2 < self.twoLineArr.count) {
                
                [self.JGJPickerView selectRow:self.nowOverTime * 2 inComponent:1 animated:YES];
                
                self.overTimeStr = [NSString stringWithFormat:@"%.1f",self.nowOverTime];

            }
        }
    }

    [self.JGJPickerView reloadAllComponents];

}

#pragma mark - 设置字体颜色
- (void)loadPickerViewFromRow:(NSInteger)row andFromComponent:(NSInteger)compent
{
    
    if (row < self.oneLineArr.count) {
        UILabel *selectedLable = (UILabel *)[self.JGJPickerView viewForRow:row forComponent:compent];
        selectedLable.textColor = AppFontd7252cColor;
    }
  
}
-(NSMutableArray *)oneLineArr
{
    if (!_oneLineArr) {
        _oneLineArr = [[NSMutableArray alloc]init];
    }
    return _oneLineArr;
}
-(NSMutableArray *)twoLineArr
{
    
    if (!_twoLineArr) {
        _twoLineArr = [[NSMutableArray alloc]init];
    }
    return _twoLineArr;
}
- (IBAction)clickCancelBtn:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        self.pickerBaseView.transform = CGAffineTransformMakeTranslation(0, 270);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)removeSelfView
{
    [UIView animateWithDuration:.3 animations:^{
        self.pickerBaseView.transform = CGAffineTransformMakeTranslation(0, 270);
        self.alpha = 0;

    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
- (IBAction)clickSureBtn:(id)sender {
    if (_manHourType == JGJManhourOnelineType) {
        if (_isManHourTime) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectManHourTime:)]) {
                [self.delegate selectManHourTime:self.manHourStr];
            }
        }else{
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectOverHour:)]) {
                [self.delegate selectOverHour:self.overTimeStr];
            }
        }
    }else{
     if (self.delegate &&[self.delegate respondsToSelector:@selector(selectManHourTime:andOverHour:)]) {
        [self.delegate selectManHourTime:self.manHourStr andOverHour:self.overTimeStr];
     }
    }
    [self removeFromSuperview];

}

- (void)setIsShowHalfOrOneSelectedView:(BOOL)isShowHalfOrOneSelectedView {
    
    _isShowHalfOrOneSelectedView = isShowHalfOrOneSelectedView;
    
    if (isShowHalfOrOneSelectedView) {
        
        _halfOrOneSelectedViewHieght.constant = 60;
        _halfOrOneSelectedView.hidden = NO;
        _halfOrOneSelectedView.isManHourTime = self.isManHourTime;
        _halfOrOneSelectedView.isContractType = _isContractType;
        _halfOrOneSelectedView.yzgGetBillModel = self.yzgGetBillModel;
        
    }else {
        
        _halfOrOneSelectedViewHieght.constant = 0;
        _halfOrOneSelectedView.hidden = YES;
    }
}

- (void)selectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime {
    
    if ([self.delegate respondsToSelector:@selector(manHourViewSelectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
        
        [self.delegate manHourViewSelectedHalfOrOneTimeWithTimeStr:timeSelected isManHourTime:isManHourTime];
    }
    
    [self removeFromSuperview];
}

+ (void)showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isShowHalfOrOneSelectedView:(BOOL)isShowHalfOrOneSelectedView
{
    JGJManHourPickerView *manHourView = [[JGJManHourPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds showManhpurViewFrom:hourHalfType withotherType:ManhourType andDelegate:delegate isManHourTime:manHour noShowRest:noShowRest andBillModel:yzgGetBillModel];
    manHourView.isShowHalfOrOneSelectedView = isShowHalfOrOneSelectedView;
    [UIView animateWithDuration:.2 animations:^{
        
        manHourView.pickerBaseView.transform = CGAffineTransformMakeTranslation(0, -270);

    }];
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:manHourView];
 
}

+ (void)showManhpurViewFrom:(JGJhourHalfType)hourHalfType withotherType:(JGJManhourType)ManhourType  andDelegate:(id)delegate isManHourTime:(BOOL)manHour noShowRest:(BOOL)noShowRest andBillModel:(YZGGetBillModel *)yzgGetBillModel isContractType:(BOOL)isContractType isShowHalfOrOneSelectedView:(BOOL)isShowHalfOrOneSelectedView{
    
    JGJManHourPickerView *manHourView = [[JGJManHourPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds showManhpurViewFrom:hourHalfType withotherType:ManhourType andDelegate:delegate isManHourTime:manHour noShowRest:noShowRest andBillModel:yzgGetBillModel isContractType:isContractType];
    manHourView.isShowHalfOrOneSelectedView = isShowHalfOrOneSelectedView;
    [UIView animateWithDuration:.2 animations:^{
        
        manHourView.pickerBaseView.transform = CGAffineTransformMakeTranslation(0, -270);
        
    }];
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:manHourView];
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.oneLineArr.count;
    }else{
        return self.twoLineArr.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {//一行单选
        if ([self.oneLineArr[row] isEqualToString:@"0"]) {
            if (self.isManHourTime) {
                return @"休息";

            }else{
                
                return @"无加班";
            }
        }
        
        if (self.isManHourTime) {
            
            // 判断是否显示(一个工)
            if ((self.yzgGetBillModel.set_tpl.w_h_tpl == [self.oneLineArr[row]?:@""  floatValue] && !_noShowRest) || (self.yzgGetBillModel.unit_quan_tpl.w_h_tpl == [self.oneLineArr[row]?:@""  floatValue] && !_noShowRest)) {
                
                return [self.oneLineArr[row] stringByAppendingString:@"小时(1个工)"];
            }
            // 判断是否显示(半个工),只有设定的标准上班时间为整数时，一半上班时间才显示(半个工)
            if ((self.yzgGetBillModel.set_tpl.w_h_tpl / 2 == [self.oneLineArr[row]?:@""  floatValue] && !_noShowRest) || (self.yzgGetBillModel.unit_quan_tpl.w_h_tpl / 2 == [self.oneLineArr[row]?:@""  floatValue] && !_noShowRest)) {
                
                return [self.oneLineArr[row] stringByAppendingString:@"小时(半个工)"];
            }
        }else{
            if ((self.yzgGetBillModel.set_tpl.o_h_tpl == [self.oneLineArr[row]?:@""  floatValue]&& !_noShowRest) || (self.yzgGetBillModel.unit_quan_tpl.o_h_tpl == [self.oneLineArr[row]?:@""  floatValue]&& !_noShowRest)) {
                
                return [self.oneLineArr[row] stringByAppendingString:@"小时(1个工)"];
            }
            if ((self.yzgGetBillModel.set_tpl.o_h_tpl / 2 == [self.oneLineArr[row]?:@""  floatValue]&& !_noShowRest) || (self.yzgGetBillModel.unit_quan_tpl.o_h_tpl / 2 == [self.oneLineArr[row]?:@""  floatValue]&& !_noShowRest)) {
                
                return [self.oneLineArr[row] stringByAppendingString:@"小时(半个工)"];
            }
        }

        return [self.oneLineArr[row] stringByAppendingString:@"小时"];
    }else{//两行
        if ([self.twoLineArr[row] isEqualToString:@"0"]) {
            return @"无加班";
        }
     
        return [self.twoLineArr[row] stringByAppendingString:@"小时"];

    }
    return @"";
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.manHourType == JGJManhourTwolineType) {
        return 2;
    }else{
        return 1;
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.manHourStr = self.oneLineArr[row];
    self.overTimeStr = self.twoLineArr[row];
    UILabel *selectedLable = (UILabel *)[self.JGJPickerView viewForRow:row forComponent:component];
    selectedLable.textColor = AppFontd7252cColor;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
        pickerLabel.textColor = AppFont333333Color;

    }

    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

@end
