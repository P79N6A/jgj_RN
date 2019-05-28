//
//  JGJCloseAccountInputCell.m
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCloseAccountInputCell.h"

@interface JGJCloseAccountInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) JGJCusTextField *inputField;// 输入框
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation JGJCloseAccountInputCell

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
    
    if (section == 2) {// 补贴、奖励、罚款 section
        
        if (row == 0) {
            
            _typeImage.hidden = NO;
            
        }else {
            
            _inputField.font = FONT(AppFont26Size);
            _typeImage.hidden = YES;
            _inputField.placeholder = @"请输入金额(可不填)";
            [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
            [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
            _inputField.textColor = AppFont333333Color;
            if (row == 1) {
                
                _typeLabel.text = @"补贴金额(+)";
                
            }else if (row == 2) {
                
                _typeLabel.text = @"奖励金额(+)";
                
            }else {
                
                _typeLabel.text = @"罚款金额(-)";
            }
            
        }
        
        if (row == 3) {
            
            [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(19);
            }];
        }else {
            
            [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(50);
            }];
        }
        
        
        
    }else if (section == 3) {
        
        _typeImage.hidden = NO;
        
        if (row == 0) {
            
            _bottomLine.hidden = NO;
            _typeImage.image = IMAGE(@"nowPaySalary");
            _typeLabel.text = (JLGisLeaderBool || self.isAgentMonitor)?@"本次实付金额":@"本次实收金额";
            _inputField.placeholder = @"请输入金额";
            [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
            [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
            _inputField.textColor = AppFontEB4E4EColor;
//            _inputField.font = [UIFont boldSystemFontOfSize:13];

            _inputField.font = FONT(AppFont26Size);
            
        }else {
            
            _inputField.font = FONT(AppFont26Size);
            _bottomLine.hidden = YES;
            _typeImage.image = IMAGE(@"countSmall");
            _typeLabel.text = @"抹零金额";
            _inputField.placeholder = @"请输入金额(可不填)";
            [_inputField setValue:FONT(AppFont26Size) forKeyPath:@"_placeholderLabel.font"];
            [_inputField setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
            _inputField.textColor = AppFont333333Color;
        }
        
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(19);
        }];
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
    if (section == 2) {
        
        if (row == 1) {
            if (![NSString isEmpty:self.yzgGetBillModel.subsidy_amount]) {// 补贴金额
                
                _inputField.text = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.subsidy_amount doubleValue]];
            }else {
                
                _inputField.text = @"";
            }
            
        }else if(row == 2){
            
            if (![NSString isEmpty: self.yzgGetBillModel.reward_amount]) {// 奖励金额
                
                _inputField.text = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.reward_amount doubleValue]];
                
            }else {
                
                _inputField.text = @"";
            }
            
        }else if(row == 3){
            
            if (![NSString isEmpty: self.yzgGetBillModel.penalty_amount]) {// 罚款金额
                
                _inputField.text = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.penalty_amount doubleValue]];
                
            }else {
                
                _inputField.text = @"";
            }
        }
    }else if (section == 3) {
        
        if (row == 0) { // 本次实付/实收金额
            
            if (self.yzgGetBillModel.salary != 0.0) {
                
                _inputField.font = [UIFont boldSystemFontOfSize:13];
                _inputField.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
                
            }else {
                
                _inputField.text = @"";
            }
        }else {// 抹零金额
            
            if ([self.yzgGetBillModel.deduct_amount doubleValue] != 0.0) {
                
                _inputField.text = [NSString stringWithFormat:@"%.2f",[self.yzgGetBillModel.deduct_amount doubleValue]];
                
            }else {
                
                _inputField.text = @"";
            }
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCloseAccountInputTextFileEditingText:cellTag:)]) {
        
        [self.delegate JGJCloseAccountInputTextFileEditingText:sender.text cellTag:_cellTag];
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
        _inputField.font = FONT(AppFont26Size);
        _inputField.digit = 7;
        _inputField.enabled = NO;
        _inputField.delegate = self;
        _inputField.keyboardType = UIKeyboardTypeDefault;
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
