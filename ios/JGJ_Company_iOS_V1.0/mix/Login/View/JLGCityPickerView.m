//
//  JLGCityPickerView.m
//  mix
//
//  Created by jizhi on 15/12/5.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGCityPickerView.h"
#import "TYFMDB.h"
#import "TYAnimate.h"

//动画时间
#define durationTimeFloat 0.5

@interface JLGCityPickerView ()
<
    UIPickerViewDelegate
>
{
    JLGCityModel *_privceModel;
    JLGCityModel *_cityModel;
    JLGCityModel *_subCityModel;
    NSString *_selectCityStr;
    NSString *_selectCityCode;
}
@property (nonatomic,retain) NSArray *privices;
@property (nonatomic,retain) NSArray *citys;
@property (nonatomic,retain) NSArray *subCitys;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIView *rootPickerView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIPickerView *datePicker;
@property (nonatomic, weak) IBOutlet UIView *detailContentView;//高度固定

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewLayoutH;
//3.22根据不同类型的选择确定pickView标题
@property (weak, nonatomic) IBOutlet UILabel *selectedAreaTitle;
@end

@implementation JLGCityPickerView

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
    [self dataInit];//初始化数据
    self.hidden = YES;
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.contentView.layer.cornerRadius = 5;
    self.rootPickerView.backgroundColor = JGJMainColor;
}

- (void)showCityPickerByIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    [self showCityPicker];
}

- (void)showCityPicker{
    [self.contentView layoutIfNeeded];
    //出现的动画
    self.hidden = NO;
    
    self.datePicker.delegate = self;
    __weak typeof(self) weakSelf = self;

    CGRect endFrame = CGRectMake(0, TYGetViewH(self.contentView) - TYGetViewH(self.detailContentView), TYGetViewW(self.contentView), self.pickerViewLayoutH.constant);
    
    [TYAnimate showWithView:self.detailContentView byStartframe:TYSetRectY(endFrame, TYGetRectY(endFrame) - 20) endFrame:endFrame byBlock:^{
        //picker转到第一个
        weakSelf.privices.count > 0 ?[weakSelf showSelectResult:[weakSelf.datePicker selectedRowInComponent:0] component:0]:@"";
        weakSelf.citys.count > 0 ?[weakSelf showSelectResult:[weakSelf.datePicker selectedRowInComponent:1] component:1]:@"";
        
        if (!weakSelf.onlyShowCitys) {
            weakSelf.subCitys.count > 0 ?[weakSelf showSelectResult:[weakSelf.datePicker selectedRowInComponent:2] component:2]:@"";
            ;
        }
        [weakSelf.datePicker reloadAllComponents];
    }];
    
    //    根据不同类型的选择确定PickView标题
    switch (self.selectedAreaType) {
        case HometownType:
            self.selectedAreaTitle.text = @"请选择你的家乡";
            break;
        case ExpectAreaType:
            self.selectedAreaTitle.text = @"请选择你的地区";
            break;
        default:
            break;
    }
}

- (void)hiddenCityPicker{
    __weak typeof(self) weakSelf = self;
    [TYAnimate hiddenView:self.detailContentView byHiddenFrame:CGRectMake(0, TYGetViewH(weakSelf.contentView), TYGetViewW(weakSelf.contentView), weakSelf.pickerViewLayoutH.constant) byBlock:^{
        weakSelf.hidden = YES;
    }];
}

- (void)dataInit{
    //加载所有省
    self.privices= [TYFMDB getAllProvince];
    
    //加载省对应城市
    JLGCityModel *city=[self.privices objectAtIndex:0];
    self.citys = [TYFMDB getCitysByProvince:city];
    
    //加载城市对应的区
    city = [self.citys objectAtIndex:0];
    self.subCitys = [TYFMDB getSubCitysByCity:city];
}

#pragma mark - setPickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.onlyShowCitys?2:3;
}

#pragma mark - 宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return TYGetUIScreenWidth/(self.onlyShowCitys?2:3);
}

#pragma mark - 返回每列的数量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        return self.privices.count;
    }else if (component==1) {
        NSInteger privoceIndex=[pickerView selectedRowInComponent:0];
        JLGCityModel *privoice=[self.privices objectAtIndex:privoceIndex];
        self.citys = [TYFMDB getCitysByProvince:privoice];
        
        return self.citys.count;
    }else {
        NSInteger cityIndex=[pickerView selectedRowInComponent:1];
        if (self.citys.count==0) {
            return 0;
        }
        JLGCityModel *subCitys=[self.citys objectAtIndex:cityIndex];
        self.subCitys=[TYFMDB getSubCitysByCity:subCitys];
        
        return self.subCitys.count;
    }
}

#pragma mark - 选择城市以后
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        [pickerView reloadComponent:1];
        if (!self.onlyShowCitys) {
            [pickerView reloadComponent:2];
        }

        [pickerView selectRow:0 inComponent:1 animated:YES];

        _subCityModel=nil;
        _cityModel = nil;
        
        self.citys.count > 0?[self showSelectResult:0 component:1]:@"";
        if (!self.onlyShowCitys) {
            self.subCitys.count > 0?[self showSelectResult:0 component:2]:@"";
        }
    }else if (component==1) {
        if (_privceModel==nil) {
            _privceModel=[self.privices objectAtIndex:0];
        }
        
        if (!self.onlyShowCitys) {
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            _subCityModel=nil;
            self.subCitys.count > 0?[self showSelectResult:0 component:2]:@"";
        }
    }else if (component==2) {
        if (_cityModel==nil) {
            _cityModel=[self.citys objectAtIndex:0];
        }
    }
    
    [self showSelectResult:row component:component];
}

#pragma mark - 显示城市名字
-(UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth / 3, 30)];
    lable.font=[UIFont systemFontOfSize:14];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text=[self getCityName:row componet:component];
    
    return lable;
}

#pragma mark - 获取城市名字
-(NSString*)getCityName:(NSInteger)row componet:(NSInteger) component{
    if (component==0) {
        JLGCityModel *city=[self.privices objectAtIndex:row];
        return city.city_name;
    }else if (component==1) {
        JLGCityModel *city=[self.citys objectAtIndex:row];
        return city.city_name;
    }else{
        if (self.subCitys==nil) {
            return @"";
        }else{
            JLGCityModel *city=[self.subCitys objectAtIndex:row];
            return city.city_name;
        }
    }
    
    return @"";
}

#pragma mark - 获取城市编码和城市名字
-(NSString*)getSelectCity{
    NSMutableString *city=[[NSMutableString alloc]init];
    
    //获取城市的字符串
    _privceModel?[city appendFormat:@" %@ ",_privceModel.city_name]:"";
    _cityModel?[city appendFormat:@" %@ ",_cityModel.city_name]:"";
    if (!self.onlyShowCitys) {
        _subCityModel?[city appendFormat:@" %@ ",_subCityModel.city_name]:"";
    }

    //获取城市的编码
    if (self.onlyShowCitys) {
        _selectCityCode = _cityModel.city_code?:@"";
    }else{
        _selectCityCode = _subCityModel.city_code?:@"";
    }

    if ([_selectCityCode isEqualToString:@""]) {
        _selectCityCode = _cityModel.city_code?:@"";
    }
    
    if ([_selectCityCode isEqualToString:@""]) {
        _selectCityCode = _privceModel.city_code?:@"";
    }
    return  city;
}

#pragma mark - 获取城市信息
-(void)showSelectResult:(NSInteger)row component:(NSInteger)component{
    
    switch (component) {
        case 0:
            {
                _privceModel = [self.privices objectAtIndex:row];
                JLGCityModel *privoice=[self.privices objectAtIndex:row];
                self.citys = [TYFMDB getCitysByProvince:privoice];
            }
            break;
        case 1:
            {
                _cityModel = [self.citys objectAtIndex:row];
                JLGCityModel *subCitys=[self.citys objectAtIndex:row];
                self.subCitys=[TYFMDB getSubCitysByCity:subCitys];
            }
            break;
        case 2:
            _subCityModel = [self.subCitys objectAtIndex:row];
            break;
        default:
            break;
    }
    
    _selectCityStr = [self getSelectCity];
}

#pragma mark - 按钮操作
- (IBAction)endSelectPickerView:(UIButton *)sender
{
//    NSDictionary *cityDic = sender.tag==2?@{@"cityCode":_selectCityCode,@"cityName":_selectCityStr}:nil;
//    3-22点击取消按钮,不改变原来数据,隐藏pickView
    if (sender.tag == 1)  {
        
        [self hiddenCityPicker];
        return;
    }
    NSDictionary *cityDic = @{@"cityCode":_selectCityCode,@"cityName":_selectCityStr};
    if (self.indexPath) {//存在indexPath
        if ([self.delegate respondsToSelector:@selector(JLGCityPickerSelect:byIndexPath:)]) {
            [self.delegate JLGCityPickerSelect:cityDic byIndexPath:self.indexPath];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(JLGCityPickerSelect:)]) {
            [self.delegate JLGCityPickerSelect:cityDic];
        }
    }
    [self hiddenCityPicker];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenCityPicker];
}
@end
