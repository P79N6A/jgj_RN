//
//  JGJNewContractorListCell.m
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorListAttendanceCell.h"
#import "TYTextField.h"
@interface JGJContractorListAttendanceCell ()

@property (nonatomic, strong) UIImageView *imageLogo;
@property (nonatomic, strong) UILabel *typeName;
// 包工业务类型选择
@property (nonatomic, strong) LengthLimitTextField *typeChoice;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *choiceBtn;

@end
@implementation JGJContractorListAttendanceCell

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
    _choiceBtn.sd_layout.rightSpaceToView(self.contentView, 20).widthIs(8).heightIs(13).centerYEqualToView(self.contentView);
    _line.sd_layout.leftEqualToView(_imageLogo).rightEqualToView(_choiceBtn).bottomSpaceToView(self.contentView, 0).heightIs(1);
    _typeChoice.sd_layout.leftSpaceToView(_typeName, 10).rightSpaceToView(self.contentView, 35).centerYEqualToView(self.contentView).heightIs(45);
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    // 获取cell的section和row
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    if ((section == 0 && row == 3) || (section == 1 && row == 2) || (section == 2 && row == 0)) {
        
        _line.hidden = YES;
        
    }else {
        
        _line.hidden = NO;
    }
    
    if (section == 0 && row == 3 && (self.isAgentMonitor || self.isMarkBillMore)) {
        
        _typeChoice.textColor = AppFont999999Color;
        _choiceBtn.sd_layout.widthIs(0);
    }else {
        
        _choiceBtn.sd_layout.widthIs(8);
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
        
        if (_manGo) {
            
            if (row == 0) {
                
                _typeChoice.textColor = AppFont999999Color;
                _choiceBtn.sd_layout.widthIs(0);
                
            }else {
                
                _typeChoice.textColor = AppFont333333Color;
                _choiceBtn.sd_layout.widthIs(8);
            }
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
    
    
    // 考勤模块
    if (section == 1) {
        
        // 上班时间
        if (row == 0) {
            
            if (_yzgGetBillModel.unit_quan_tpl.w_h_tpl == 0 && _yzgGetBillModel.unit_quan_tpl.o_h_tpl == 0) {
                
                _typeChoice.text = @"";
                
            }else {
                
                if (_yzgGetBillModel.unit_quan_tpl.o_h_tpl == 0) {
                    
                    _typeChoice.text = [[NSString stringWithFormat:@"%.1f小时(上班)/(无加班)",_yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                }else {
                    
                    _typeChoice.text = [[NSString stringWithFormat:@"%.1f小时(上班)/%.1f小时(加班)",_yzgGetBillModel.unit_quan_tpl.w_h_tpl,_yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                }
                
            }
            
        }else if (row == 1) {
            
            if (self.yzgGetBillModel.manhour == 0 && self.yzgGetBillModel.isRest) {
                self.typeChoice.text = @"休息";
                
            }else if (self.yzgGetBillModel.manhour == 0 && !self.yzgGetBillModel.isRest){
                
                self.typeChoice.text = @"";
                
            }else{
                
                NSString *unitStr;
                if (self.yzgGetBillModel.unit_quan_tpl.w_h_tpl == self.yzgGetBillModel.manhour) {
                    
                    unitStr = @"(1个工)";
                    
                }else{
                    
                    // 工资标准为整数
                    if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                        
                        if (self.yzgGetBillModel.manhour == self.yzgGetBillModel.unit_quan_tpl.w_h_tpl / 2) {
                            
                            unitStr = @"(半个工)";
                            
                        }else {
                            
                            unitStr = @"";
                        }
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                    
                }
                
                self.typeChoice.text = [[NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.manhour,unitStr] stringByReplacingOccurrencesOfString:@".0" withString:@""];
            }
        }else {
            
            if ((self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.isOverWork) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.manhour >0) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.isRest)) {
                
                self.typeChoice.text = @"无加班";
                
            }else if (self.yzgGetBillModel.overtime == 0 && !self.yzgGetBillModel.isOverWork){
                
                self.typeChoice.text = @"";
                
            }else{
                
                NSString *unitStr;
                if (self.yzgGetBillModel.unit_quan_tpl.o_h_tpl == self.yzgGetBillModel.overtime) {
                    
                    unitStr = @"(1个工)";
                    
                }else{
                    
                    // 工资标准为整数
                    if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                        
                        if (self.yzgGetBillModel.overtime == self.yzgGetBillModel.unit_quan_tpl.o_h_tpl / 2) {
                            
                            unitStr = @"(半个工)";
                            
                        }else {
                            
                            unitStr = @"";
                        }
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                    
                }
                
                self.typeChoice.text = [[NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.overtime,unitStr] stringByReplacingOccurrencesOfString:@".0" withString:@""];
            }
        }
    }
    
    // 设置记工备注
    if (section == 2 && row == 0) {
        
        _typeChoice.textColor = AppFont333333Color;
        if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
            
            _typeChoice.text = self.yzgGetBillModel.notes_txt;
            
        }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count){
            
            _typeChoice.text = @"[图片]";
        }else {
            
            _typeChoice.text = @"";
        }
    }
    
    
}

- (void)setHiddenLine:(BOOL)hiddenLine {

    _hiddenLine = hiddenLine;
    if (_hiddenLine) {
        
        _line.hidden = YES;
    }else {
        
        _line.hidden = NO;
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

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = placeHolder;
    _typeChoice.placeholder = _placeHolder;
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
        _typeChoice.textColor = AppFont333333Color;
        _typeChoice.font = FONT(15);
        _typeChoice.textAlignment = NSTextAlignmentRight;
        _typeChoice.enabled = NO;
        [_typeChoice setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
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
