//
//  JGJContractorMakeAccountInputCell.m
//  mix
//
//  Created by Tony on 2019/1/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAccountInputCell.h"

@interface JGJContractorMakeAccountInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) JGJCusTextField *inputField;// 输入框
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJContractorMakeAccountInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.typeImage];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.inputField];
    [self.contentView addSubview:self.bottomLine];
    
    [self setUpLayout];
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (row == 1) {
        
        _typeImage.image = IMAGE(@"openSalary");
        _typeLabel.text = @"填写单价";
        _inputField.keyboardType = UIKeyboardTypeDecimalPad;
        _inputField.placeholder = @"这里输入单价金额";
        [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
        _inputField.textColor = AppFontEB4E4EColor;
        [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
        
    }

}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (![NSString isEmpty:_yzgGetBillModel.name]) {
        
        _inputField.enabled = YES;
        
    }else {
        
        _inputField.enabled = NO;
        
    }

    if (row == 1) {
        
        if (_yzgGetBillModel.unitprice != 0) {
            
            _inputField.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.unitprice];
            _inputField.font = [UIFont boldSystemFontOfSize:13];
            _inputField.textColor = AppFontEB4E4EColor;
            
        }else {
            
            _inputField.text = @"";
            _inputField.font = FONT(13);
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldChangeAction:(UITextField *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJContractorMakeAttendanceInputTextFileEditingText:cellTag:)]) {
        
        [self.delegate JGJContractorMakeAttendanceInputTextFileEditingText:sender.text cellTag:_cellTag];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextFieldEndEditing)]) {

        [self.delegate inputTextFieldEndEditing];
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
- (void)setUpLayout {
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(19);
        make.width.height.mas_equalTo(18);
    }];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.equalTo(_typeImage.mas_right).offset(13);
        make.height.mas_equalTo(15);
    }];
    
    
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(2.5);
        make.bottom.mas_offset(-2.5);
        make.left.equalTo(_typeLabel.mas_right).offset(20);
        make.right.mas_offset(-26);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(19);
        make.bottom.mas_equalTo(0);
        make.right.mas_offset(-19);
        make.height.mas_equalTo(1);
    }];
}

- (UIImageView *)typeImage {
    
    if (!_typeImage) {
        
        _typeImage = [[UIImageView alloc] init];        
    }
    return _typeImage;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = AppFont333333Color;
        _typeLabel.font = FONT(AppFont30Size);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

- (JGJCusTextField *)inputField {
    
    if (!_inputField) {
        
        _inputField = [[JGJCusTextField alloc] init];
        _inputField.textAlignment = NSTextAlignmentRight;
        _inputField.digit = 7;
        _inputField.enabled = NO;
        _inputField.delegate = self;
        [_inputField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputField;
}


- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

@end
