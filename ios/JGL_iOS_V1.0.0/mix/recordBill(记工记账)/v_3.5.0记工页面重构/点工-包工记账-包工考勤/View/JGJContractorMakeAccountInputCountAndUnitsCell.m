//
//  JGJContractorMakeAccountInputCountAndUnitsCell.m
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAccountInputCountAndUnitsCell.h"
#import "SJButton.h"
@interface JGJContractorMakeAccountInputCountAndUnitsCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) JGJCusTextField *inputField;// 输入框
@property (nonatomic, strong) SJButton *choiceUnitsBtn;// 选择单位
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJContractorMakeAccountInputCountAndUnitsCell

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
    [self.contentView addSubview:self.choiceUnitsBtn];
    [self setUpLayout];
    
    [_inputField updateLayout];
    [_choiceUnitsBtn updateLayout];
    
    _inputField.layer.cornerRadius = 3;
    _choiceUnitsBtn.layer.cornerRadius = 3;
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (row == 2) {
        
        _typeImage.image = IMAGE(@"writeNumber");
        _typeLabel.text = @"填写数量";
        _inputField.keyboardType = UIKeyboardTypeDecimalPad;
        _inputField.placeholder = @"这里输入数量";
        [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
        _inputField.textColor = AppFont333333Color;
        [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
        
    }
    
}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (![NSString isEmpty:_yzgGetBillModel.name]) {
        
        _inputField.enabled = YES;
        _choiceUnitsBtn.enabled = YES;
        
    }else {
        
        _inputField.enabled = NO;
        _choiceUnitsBtn.enabled = NO;
        
    }
    
    if (row == 2) {
        
        if (_yzgGetBillModel.quantities != 0.0) {
            
            _inputField.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.quantities];
            
        }else {
            
            _inputField.text = @"";
        }
        
        if (![NSString isEmpty:_yzgGetBillModel.units]) {
            
            [_choiceUnitsBtn setTitle:_yzgGetBillModel.units forState:(SJControlStateNormal)];
        }
        _choiceUnitsBtn.backgroundColor = AppFontffffffColor;
        [_choiceUnitsBtn setTitleColor:AppFont333333Color forState:SJControlStateNormal];
    }
}

- (void)choiceUnits {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputCountAndUnitsCellChoiceUnitsWithCellTag:)]) {
        
        [self.delegate inputCountAndUnitsCellChoiceUnitsWithCellTag:self.cellTag];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldChangeAction:(UITextField *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJContractorMakeAttendanceInputCountTextFileEditingText:cellTag:)]) {
        
        [self.delegate JGJContractorMakeAttendanceInputCountTextFileEditingText:sender.text cellTag:_cellTag];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputCountTextFieldEndEditing)]) {
        
        [self.delegate inputCountTextFieldEndEditing];
    }
}


- (void)setUpLayout {
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(19);
        make.width.height.mas_equalTo(18);
    }];
    
    CGSize typeSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"填写数量" font:15];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.equalTo(_typeImage.mas_right).offset(13);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(typeSize.width + 1);
    }];
    
    [_choiceUnitsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-20);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(33);
        make.centerY.mas_offset(0);
    }];
    
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.right.equalTo(_choiceUnitsBtn.mas_left).offset(-9);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(33);
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
        _inputField.font = FONT(AppFont26Size);
        [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
        _inputField.textAlignment = NSTextAlignmentCenter;
        _inputField.enabled = NO;
        _inputField.digit = 7;
        _inputField.delegate = self;
        _inputField.layer.borderWidth = 1;
        _inputField.layer.borderColor = AppFont999999Color.CGColor;
        [_inputField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
        _inputField.clipsToBounds = YES;
    }
    return _inputField;
}

- (SJButton *)choiceUnitsBtn {
    
    if (!_choiceUnitsBtn) {
        
        _choiceUnitsBtn = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        [_choiceUnitsBtn setImage:IMAGE(@"down_press") forState:SJControlStateNormal];
        [_choiceUnitsBtn setTitle:@"平方米" forState:(SJControlStateNormal)];
        [_choiceUnitsBtn setTitleColor:AppFont333333Color forState:SJControlStateNormal];
        _choiceUnitsBtn.titleLabel.font = FONT(AppFont26Size);
        _choiceUnitsBtn.layer.borderWidth = 1;
        _choiceUnitsBtn.layer.borderColor = AppFont999999Color.CGColor;
        _choiceUnitsBtn.clipsToBounds = YES;
        [_choiceUnitsBtn addTarget:self action:@selector(choiceUnits) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceUnitsBtn;
}


- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

@end
