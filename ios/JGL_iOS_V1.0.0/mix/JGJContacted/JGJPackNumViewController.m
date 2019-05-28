//
//  JGJPackNumViewController.m
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPackNumViewController.h"
#import "JGJWeatherPickerview.h"
#import "JGJQRecordViewController.h"
#import "JGJMarkContractBillVc.h"
#import "JGJModifyBillListViewController.h"
#import "JGJMarkBillViewController.h"

@interface JGJPackNumViewController ()
<
didselectweaterindexpath,
UITextFieldDelegate

>
{
    NSString *num;
    NSString *numprice;
    NSString *_selectedUnits;
}
@end

@implementation JGJPackNumViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSelfView];
}
- (void)loadSelfView{
    _textfiled.keyboardType = UIKeyboardTypeNumberPad;
    [_textfiled becomeFirstResponder];
    self.title = @"填写数量";
    _textfiled.delegate = self;
    _textfiled.keyboardType =
    UIKeyboardTypeDecimalPad;
    _numlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShowUnites)];
    [_numlable addGestureRecognizer:tap];
    
    if ([_filloutmodel.Num?:@"0" floatValue] > 0) {
        self.textfiled.text = _filloutmodel.Num?:@"";
    }
    _numlable.text  = _filloutmodel.priceNum?:@"";
    _selectedUnits = @"平方米";
}
- (IBAction)clickShowBtn:(id)sender {
    
    [self.view endEditing:YES];
    
    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 265, TYGetUIScreenWidth, 265)];
    picker.delegate = self;
    picker.topname = @"选择单位";

    [picker showWeatherPickerView];
    picker.classmodel = JGJPacknumPickermodel;
    picker.selectedUnits = _selectedUnits;
    picker.titlearray = [NSMutableArray arrayWithObjects:@"平方米",@"立方米",@"吨",@"米",@"个",@"次",@"天",@"块",@"组",@"台",@"捆",@"宗",@"项",@"株",nil];
    [picker setLeftButtonTitle:@"" rightButtonTitle:@"关闭"];
}
-(void)setFilloutmodel:(JGJFilloutNumModel *)filloutmodel
{
    num = filloutmodel.Num;
    numprice = filloutmodel.priceNum;
    _filloutmodel = filloutmodel;
    if ([NSString isEmpty: filloutmodel.priceNum ]) {
        _filloutmodel.priceNum = @"平方米";
    }
    if ([filloutmodel.Num?:@"0" floatValue] > 0) {
        self.textfiled.text = filloutmodel.Num?:@"";
    }
    _numlable.text  = filloutmodel.priceNum?:@"";
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    UITextField *countTextField = self.textfiled;
    NSString *NumbersWithDot = @".1234567890";
    NSString *NumbersWithoutDot = @"-1234567890";
    if (![string isEqualToString:@""]) {
        
        
        NSCharacterSet *cs;
        
        if ([textField isEqual:countTextField]) {
            
            // 小数点在字符串中的位置 第一个数字从0位置开始
            
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            
            if (dotLocation == NSNotFound && range.location != 0) {
                
                
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                
                /*
                 
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 
                 */
                
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                
                if (range.location >= 6) {
                    
                    
                    if ([string isEqualToString:@"."] && range.location == 6) {
                        
                        return YES;
                        
                    }
                    
                    return NO;
                    
                }
                
                
            }else {
                
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                
            }
            
            // 按cs分离出数组,数组按@""分离出字符串
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            BOOL basicTest = [string isEqualToString:filtered];
            
            if (!basicTest) {
                
                NSLog(@"只能输入数字和小数点");
                
                return NO;
                
            }
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                
                NSLog(@"小数点后最多两位");
                
                return NO;
                
            }
            
            
            if (textField.text.length > 8) {
                
                return NO;
                
            }
            
            
        }
        
    }
    
    return YES;
}
-(void)clickTopbutton:(NSString *)buttonTitle
{
    if ([buttonTitle isEqual:@"关闭"]) {
        
    }
}
- (IBAction)clickShow:(id)sender {
    [self.view endEditing:YES];

    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 300, TYGetUIScreenWidth, 300)];
    picker.delegate = self;
    [picker showWeatherPickerView];
    picker.classmodel = JGJPacknumPickermodel;
    picker.topname = @"选择单位";
    picker.titlearray = [NSMutableArray arrayWithObjects:@"平方米",@"立方米",@"吨",@"米",@"个",@"次",@"天",@"块",@"组",@"台",@"捆",@"宗",@"项",@"株",nil];
    [picker setLeftButtonTitle:@"" rightButtonTitle:@"关闭"];
}
-(void)clickShowUnites
{
    [self.view endEditing:YES];
    
    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 300, TYGetUIScreenWidth, 300)];
    picker.delegate = self;
    [picker showWeatherPickerView];
    picker.classmodel = JGJPacknumPickermodel;
    
    picker.topname = @"选择单位";
    picker.titlearray = [NSMutableArray arrayWithObjects:@"平方米",@"立方米",@"吨",@"米",@"个",@"次",@"天",@"块",@"组",@"台",@"捆",@"宗",@"项",@"株",nil];
    [picker setLeftButtonTitle:@"" rightButtonTitle:@"关闭"];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content
{
    _numlable.text = content;
    _filloutmodel.Num = _textfiled.text;
    _filloutmodel.priceNum = content;
    _selectedUnits = content;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}
- (void)backButtonPressed
{
    _filloutmodel.Num = _textfiled.text;

    if (!_filloutmodel.priceNum) {
      _filloutmodel.priceNum = @"平方米";
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        
        if ([vc isKindOfClass:[JGJMarkBillViewController class]]) {
            
            JGJMarkBillViewController *record = (JGJMarkBillViewController *)vc;
            record.fillOutModel = _filloutmodel;
            
        }
        //包工界面修改账单
        else  if ([vc isKindOfClass:[JGJMarkContractBillVc class]]) {
            
            JGJMarkContractBillVc *record = (JGJMarkContractBillVc *)vc;
            record.fillOutModel = _filloutmodel;
     
        }else if ([vc isKindOfClass:[JGJModifyBillListViewController class]]){
      
            JGJModifyBillListViewController *record = (JGJModifyBillListViewController *)vc;
            record.fillOutModel = _filloutmodel;
        }
    }
    
    if (self.fillBackBlock) {
        
        _fillBackBlock(_filloutmodel);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
