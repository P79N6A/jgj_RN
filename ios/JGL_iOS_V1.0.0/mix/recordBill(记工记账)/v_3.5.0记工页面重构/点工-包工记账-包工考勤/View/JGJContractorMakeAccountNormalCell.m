//
//  JGJContractorMakeAccountNormalCell.m
//  mix
//
//  Created by Tony on 2019/1/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorMakeAccountNormalCell.h"

@interface JGJContractorMakeAccountNormalCell ()

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) UILabel *detailLabel;// 详情标签
@property (nonatomic, strong) UIImageView *arrowImage;// 箭头图片
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation JGJContractorMakeAccountNormalCell

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
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.arrowImage];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (section == 0) {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"SitPro");
            _typeLabel.text = @"所在项目";
            _bottomLine.hidden = NO;
            
        }else if (row == 1) {
            
            _typeImage.image = IMAGE(@"lederHeadImage");
            _typeLabel.text = (JLGisLeaderBool || self.isAgentMonitor) ? @"承包对象":@"班组长";
            _bottomLine.hidden = NO;
            
            if (self.subentryType == 0 && (JLGisLeaderBool || self.isAgentMonitor)) {
                
                _typeLabel.text = @"承包对象";
                
            }else if (self.subentryType == 1 && (JLGisLeaderBool || self.isAgentMonitor)) {
                
                _typeLabel.text = @"工人";
            }
            
            if (_markBillMore) {
                
                _typeLabel.text = @"工人";
            }
            
        }else {
            
            _typeImage.image = IMAGE(@"markCalender");
            _typeLabel.text = @"日期";
            _detailLabel.textColor = AppFont333333Color;
            _bottomLine.hidden = YES;
        }
        
    }else if (section == 2 + _subentryAccount - 1) {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"markBillremark");
            _typeLabel.text = @"备注";
            _bottomLine.hidden = YES;
        }
        
        
    }else {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"subProTitle");
            if (_subentryAccount > 1) {
                
                _typeLabel.text = [NSString stringWithFormat:@"分项名称%ld",section];
                
            }else {
                
                _typeLabel.text = @"分项名称";
            }
            _arrowImage.hidden = NO;
            _bottomLine.hidden = NO;
            
        }else {
            
            _typeImage.image = IMAGE(@"residueSalary");
            _typeLabel.text = @"包工工钱";
            _arrowImage.hidden = YES;
            _bottomLine.hidden = YES;
        }
    }
}


- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (section == 0) {
        
        if (row == 0) {
            
            if (![NSString isEmpty:self.yzgGetBillModel.proname]) {
                
                _detailLabel.numberOfLines = 0;
                _detailLabel.text = self.yzgGetBillModel.proname;
                _detailLabel.textColor = AppFont333333Color;
                if (self.markBillMore) {
                    
                    _detailLabel.textColor = AppFont999999Color;
                    _arrowImage.hidden = YES;
                    
                }else {
                    
                    _arrowImage.hidden = NO;
                }
                if (self.yzgGetBillModel.pid == 0) {
                    
                    _detailLabel.text = @"";
                }
                
            }else {
                
                _detailLabel.text = @"例如：万科魅力之城";
                _detailLabel.textColor = AppFont999999Color;
            }
            
        }else if (row == 1) {
            
            if (![NSString isEmpty:_yzgGetBillModel.name]) {
                
                _detailLabel.text = _yzgGetBillModel.name;
                _detailLabel.textColor = AppFont333333Color;
                if (self.is_Home_ComeIn) {
                    
                    _detailLabel.textColor = AppFont999999Color;
                    _arrowImage.hidden = YES;
                    
                }else {
                    
                    _arrowImage.hidden = NO;
                }
            }else {
                
                _detailLabel.text = (JLGisLeaderBool || self.isAgentMonitor) ? @"请选择承包对象":@"请添加你的班组长/工头";
                _detailLabel.textColor = AppFont999999Color;
                
                if (self.subentryType == 0 && (JLGisLeaderBool || self.isAgentMonitor)) {
                    
                    _detailLabel.text = @"请选择承包对象";
                    
                }else if (self.subentryType == 1 && (JLGisLeaderBool || self.isAgentMonitor)) {
                    
                    _detailLabel.text = @"请选择工人";
                }
                
                if (_markBillMore) {
                    
                    _detailLabel.text = @"请选择工人";
                }
            }
            
        }else {
            
            _detailLabel.text = _yzgGetBillModel.date;
            _detailLabel.font = FONT(13);
        }
        
    }else if (section == 2 + _subentryAccount - 1) {
        if (row == 0) {
            
            if (![NSString isEmpty:self.yzgGetBillModel.notes_txt]) {
                
                if (self.yzgGetBillModel.notes_img.count) {
                    
                    if (self.yzgGetBillModel.notes_txt.length > 10) {
                        
                        _detailLabel.text = [NSString stringWithFormat:@"%@... [图片]",[self.yzgGetBillModel.notes_txt substringToIndex:10]];
                    }else {
                        
                        _detailLabel.text = [NSString stringWithFormat:@"%@ [图片]",self.yzgGetBillModel.notes_txt];
                    }
                    
                }else {
                    
                    if (self.yzgGetBillModel.notes_txt.length > 10) {
                        
                        _detailLabel.text = [NSString stringWithFormat:@"%@...",[self.yzgGetBillModel.notes_txt substringToIndex:10]];
                        
                    }else {
                        
                        _detailLabel.text = self.yzgGetBillModel.notes_txt;
                    }
                }
                
                _detailLabel.textColor = AppFont333333Color;
                _detailLabel.numberOfLines = 1;
                
            }else if ([NSString isEmpty:self.yzgGetBillModel.notes_txt] && self.yzgGetBillModel.notes_img.count) {
                
                _detailLabel.text = @"[图片]";
                _detailLabel.textColor = AppFont333333Color;
                
            }else {
                
                _detailLabel.text = @"可填写备注信息";
                _detailLabel.textColor = AppFont999999Color;
            }
            
        }
        
    }else {
        
        if (row == 0) {
            
            if (![NSString isEmpty:_yzgGetBillModel.sub_proname]) {
                
                
                _detailLabel.text = _yzgGetBillModel.sub_proname;
                _detailLabel.textColor = AppFont333333Color;
                
            }else {
                
                _detailLabel.text = @"例如:包柱子/挂窗帘";
                _detailLabel.textColor = AppFont999999Color;
            }
            
        }else {
            
            if (_yzgGetBillModel.salary != 0) {
                
                _detailLabel.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.salary];
                _detailLabel.font = [UIFont boldSystemFontOfSize:13];
                _detailLabel.textColor = AppFontEB4E4EColor;
                
            }else {
                
                _detailLabel.text = @"";
            }
        }
        
    }
}

- (void)startTwinkleAnimation {
    
    self.typeLabel.textColor = AppFontEB4E4EColor;
    self.detailLabel.textColor = AppFontEB4E4EColor;
    CABasicAnimation *animation = [JGJComTool opacityForever_Animation:0.7];
    [self.typeLabel.layer addAnimation:animation forKey:nil];
    [self.detailLabel.layer addAnimation:animation forKey:nil];
    [self.arrowImage.layer addAnimation:animation forKey:nil];
}

- (void)stopTwinkleAnimation {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.typeLabel.textColor = AppFont333333Color;
    [self.typeLabel.layer removeAllAnimations];
    [self.detailLabel.layer removeAllAnimations];
    [self.arrowImage.layer removeAllAnimations];
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
    
    // 设置typeLbael的有显示优先级最高
    [_typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:(UILayoutConstraintAxisHorizontal)];
    
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-19);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(2.5);
        make.bottom.mas_offset(-2.5);
        make.left.equalTo(_typeLabel.mas_right).offset(20);
        make.right.equalTo(_arrowImage.mas_left).offset(-7);
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


- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = AppFont999999Color;
        _detailLabel.font = FONT(AppFont26Size);
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIImageView *)arrowImage {
    
    if (!_arrowImage) {
        
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage.image = IMAGE(@"arrow_right");
        _arrowImage.contentMode = UIViewContentModeRight;
    }
    return _arrowImage;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

@end
