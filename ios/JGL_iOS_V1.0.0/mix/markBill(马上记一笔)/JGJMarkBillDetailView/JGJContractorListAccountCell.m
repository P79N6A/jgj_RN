//
//  JGJContractorListAccountCell.m
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorListAccountCell.h"
#import "TYTextField.h"
@interface JGJContractorListAccountCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageLogo;
@property (nonatomic, strong) UILabel *typeName;
// 包工业务类型选择
@property (nonatomic, strong) LengthLimitTextField *typeChoice;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *choiceBtn;
@end
@implementation JGJContractorListAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.imageLogo];
    [self.contentView addSubview:self.typeName];
    [self.contentView addSubview:self.typeChoice];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.choiceBtn];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _imageLogo.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(18).heightIs(18);
    
    CGSize titleSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) content:@"所在项目" font:15];
    _typeName.sd_layout.leftSpaceToView(_imageLogo, 12).centerYEqualToView(_imageLogo).widthIs(titleSize.width).heightIs(18);
    
    _choiceBtn.sd_layout.rightSpaceToView(self.contentView, 20).heightIs(13).centerYEqualToView(self.contentView);
    
    _line.sd_layout.leftSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, 20).bottomSpaceToView(self.contentView, 0).heightIs(1);
    
    _typeChoice.sd_layout.leftSpaceToView(_typeName, 10).rightSpaceToView(self.contentView, 35).centerYEqualToView(self.contentView).heightIs(45);
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    // 获取cell的section和row
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    if (section == 1) {
        
        _choiceBtn.sd_layout.widthIs(0);
        
        if (row == 0 || row == 1) {
            
            // 键盘类型
            if (row == 0) {
                
                _typeChoice.keyboardType = UIKeyboardTypeDefault;
                _typeChoice.textColor = AppFont333333Color;
                
            }else {
                
                _typeChoice.keyboardType = UIKeyboardTypeDecimalPad;
                
                _typeChoice.textColor = AppFontEB4E4EColor;
            }
            _typeChoice.enabled = YES;
        }
        
        if (row == 2) {
            
            _choiceBtn.sd_layout.widthIs(8);
            _typeChoice.enabled = NO;
        }
        
        if (row == 3) {
            
            _typeChoice.textColor = AppFontEB4E4EColor;
            _typeChoice.enabled = NO;
        }
        
    }else {
        
        _choiceBtn.sd_layout.widthIs(8);
        if (section == 0 && row == 3 && (self.isAgentMonitor || self.isMarkBillMore)) {
            
            _typeChoice.textColor = AppFont999999Color;
            _choiceBtn.sd_layout.widthIs(0);
        }
    }
    
    if ((section == 0 && row == 3) || (section == 1 && row == 3) || (section == 2 && row == 0)) {
        
        _line.hidden = YES;
        
    }else {
        
        _line.hidden = NO;
    }
    
    
    if (_manGo) {
        
        if (section == 0 && row == 0) {
            
            _typeChoice.textColor = AppFont999999Color;
            _choiceBtn.sd_layout.widthIs(0);
        }
    }
}


- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    // 获取cell的section和row
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    
    if (section == 0) {
        
        // 设置记工对象
        if (row == 0) {
            
            _typeChoice.text = _yzgGetBillModel.name;
        }
        
        // 记工日期
        if (row == 1) {
            
            _typeChoice.text = _yzgGetBillModel.date;
            if ([self.yzgGetBillModel.bill_num ? :@"0" floatValue] <= 0) {
                
                _line.hidden = NO;
                
            }else {
                
                _line.hidden = YES;
            }
        }
        
        // 设置所在项目
        if (row == 3) {
            
            if ([_yzgGetBillModel.proname isEqualToString:@"无项目名称"]) {
                
                _typeChoice.text = @"  ";
                
            }else {
                
                _typeChoice.text = _yzgGetBillModel.proname;
            }
        }
    }
    
    // 包工工钱
    if (section == 1 ) {
        
        if (row == 0) {
            
            _typeChoice.maxLength = 15;
            if (_yzgGetBillModel.sub_proname) {
                
                _typeChoice.text = _yzgGetBillModel.sub_proname;
                
            }else {
                
                _typeChoice.text = @"";
            }
            
        }
        
        if (row == 1) {
            
            _typeChoice.tag = 10086;
            if (_yzgGetBillModel.unitprice != 0) {
                
                _typeChoice.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.unitprice];
                _typeChoice.font = [UIFont boldSystemFontOfSize:17];
                
            }else {
                
                _typeChoice.text = @"";
                _typeChoice.font = FONT(15);
            }
        }
        if (row == 2) {
            
            _typeChoice.textColor = AppFont333333Color;
            _typeChoice.font = FONT(15);
            if (_yzgGetBillModel.units && _yzgGetBillModel.quantities != 0.0) {
                
                _typeChoice.text = [NSString stringWithFormat:@"%.2f %@",_yzgGetBillModel.quantities,_yzgGetBillModel.units];
                
            }else {
                
                _typeChoice.text = @"";
            }
            
        }

        if (row == 3) {
            
            if (_yzgGetBillModel.salary != 0) {
                
                _typeChoice.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.salary];
                _typeChoice.font = [UIFont boldSystemFontOfSize:17];
            }else {
                
                _typeChoice.text = @"";
                _typeChoice.font = FONT(15);
            }
            
        }
        
    }
    
    // 设置记工备注
    if (section == 2 && row == 0) {
        
        _typeChoice.textColor = AppFont333333Color;
        _typeChoice.font = FONT(15);
        if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
            
            _typeChoice.text = self.yzgGetBillModel.notes_txt;
            
        }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count){
            
            _typeChoice.text = @"[图片]";
            
        }else {
            
            _typeChoice.text = @"";
        }
        
    }
}


- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    _imageLogo.image = IMAGE(imageName);
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    _typeName.text = _title;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    
    _hiddenLine = hiddenLine;
    if (_hiddenLine) {
        
        _line.hidden = YES;
    }else {
        
        _line.hidden = NO;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = placeHolder;
    _typeChoice.placeholder = _placeHolder;
}


- (void)setMaxLength:(int)maxLength {
    
    _maxLength = maxLength;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.yzgGetBillModel.name == nil) {
        
        [TYShowMessage showPlaint:@"请先选择记账对象"];
        return NO;
    }else {
        
        if (self.yzgGetBillModel.date == nil) {
            
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return NO;
        }
    }
    if (![NSString isEmpty: textField.text ]) {
        
        if ([textField.text floatValue] == 0 || [textField.text isEqualToString:@"-.-"]) {
           
//            textField.text = @"";
        }
    }
    
    return YES;
}

- (void)textFieldChangeAction:(UITextField *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJContractorListAccountTextFileEditingText:cellTag:)]) {
        
        [self.delegate JGJContractorListAccountTextFileEditingText:sender.text cellTag:_cellTag];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndEditing)]) {
        
        [self.delegate textFieldEndEditing];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *NumbersWithDot    = @".1234567890";
    NSString *NumbersWithoutDot = @"1234567890";
    if (![string isEqualToString:@""]) {
        
        NSCharacterSet *cs;
        
        if (textField.tag == 10086) {
            
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
    
- (UIImageView *)imageLogo {
    
    if (!_imageLogo) {
        
        _imageLogo = [[UIImageView alloc] init];
        _imageLogo.image = IMAGE(@"lederHeadImage");
    }
    return _imageLogo;
}

- (UILabel *)typeName {
    
    if (!_typeName) {
        
        _typeName = [[UILabel alloc] init];
        _typeName.textColor = AppFont333333Color;
        _typeName.font = [UIFont boldSystemFontOfSize:15];
        _typeName.text = @"所在项目";
    }
    return _typeName;
}

- (LengthLimitTextField *)typeChoice {
    
    if (!_typeChoice) {
        
        _typeChoice = [[LengthLimitTextField alloc] init];
        _typeChoice.font = FONT(15);
        _typeChoice.textAlignment = NSTextAlignmentRight;
        _typeChoice.enabled = NO;
        [_typeChoice setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
        _typeChoice.delegate = self;
        [_typeChoice addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _typeChoice;
}

- (UIButton *)choiceBtn {
    
    if (!_choiceBtn) {
        
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBtn setImage:IMAGE(@"arrow_right") forState:UIControlStateNormal];
        _choiceBtn.contentMode = UIViewContentModeRight;
        _choiceBtn.userInteractionEnabled = NO;
    }
    return _choiceBtn;
}


- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}



@end
