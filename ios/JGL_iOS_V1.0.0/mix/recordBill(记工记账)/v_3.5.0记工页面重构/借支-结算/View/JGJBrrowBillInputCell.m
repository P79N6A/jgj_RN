//
//  JGJBrrowBillInputCell.m
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJBrrowBillInputCell.h"

@interface JGJBrrowBillInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) JGJCusTextField *inputField;// 输入框

@end
@implementation JGJBrrowBillInputCell

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
    
    [self setUpLayout];
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (section == 1) {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"openSalary");
            _typeLabel.text = @"填写金额";
            _inputField.keyboardType = UIKeyboardTypeDecimalPad;
            _inputField.placeholder = @"这里输入金额";
            [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
            [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
            
        }
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
   
    if (row == 0) {
        
        if ([self.yzgGetBillModel.browNum doubleValue] > 0.0) {
            
            _inputField.text = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.browNum doubleValue]];
            
        }else {
            
            _inputField.text = @"";
        }
        
        
    }
}

- (void)startTwinkleAnimation {
    
    self.typeLabel.textColor = AppFontEB4E4EColor;
    
    [_inputField setValue:AppFontEB4E4EColor forKeyPath:@"_placeholderLabel.textColor"];
    CABasicAnimation *animation = [JGJComTool opacityForever_Animation:0.7];
    [self.typeLabel.layer addAnimation:animation forKey:nil];
    [self.inputField.layer addAnimation:animation forKey:nil];
}

- (void)stopTwinkleAnimation {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.typeLabel.textColor = AppFont333333Color;
    [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
    [self.typeLabel.layer removeAllAnimations];
    [self.inputField.layer removeAllAnimations];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldChangeAction:(UITextField *)sender {
    
    [self stopTwinkleAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJBrrowBillInputTextFileEditingText:cellTag:)]) {
        
        [self.delegate JGJBrrowBillInputTextFileEditingText:sender.text cellTag:_cellTag];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextFieldEndEditing)]) {
        
        [self.delegate inputTextFieldEndEditing];
    }
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
        _inputField.textColor = AppFonte83c76eColor;
        _inputField.font = [UIFont boldSystemFontOfSize:13];
        _inputField.textAlignment = NSTextAlignmentRight;
        _inputField.digit = 7;
        _inputField.enabled = NO;
        _inputField.delegate = self;
        [_inputField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputField;
}


@end
