//
//  JGJTinyAmountMarkBillTableViewCell.m
//  mix
//
//  Created by Tony on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJTinyAmountMarkBillTableViewCell.h"
#import "NSDate+Extend.h"
#import "IDJCalendar.h"
#import "NSString+Extend.h"
#import "JGJMarkBillManHourDefaultView.h"
@interface JGJTinyAmountMarkBillTableViewCell ()

@property (nonatomic, strong) IDJCalendar *calendar;
@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) UILabel *detailLabel;// 详情标签
@property (nonatomic, strong) UIImageView *arrowImage;// 箭头图片
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) JGJMarkBillManHourDefaultView *defaultView;

@end
@implementation JGJTinyAmountMarkBillTableViewCell

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
    [self.detailLabel addSubview:self.defaultView];
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
            
            _typeImage.image = IMAGE(@"lederHeadImage");
            _typeLabel.text = (JLGisLeaderBool || self.isAgentMonitor) ? @"工人":@"班组长";
            _bottomLine.hidden = NO;
        }else {
            
            _typeImage.image = IMAGE(@"markCalender");
            _typeLabel.text = @"日期";
            _detailLabel.textColor = AppFont333333Color;
            _bottomLine.hidden = YES;
        }
        
    }else if (section == 1) {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"openSalary");
            _typeLabel.text = @"工资标准";
            _arrowImage.hidden = NO;
            _bottomLine.hidden = NO;
        }else if (row == 1) {
            
            _typeImage.image = IMAGE(@"workNormalTime");
            _typeLabel.text = @"上班时长";
            _arrowImage.hidden = NO;
            _bottomLine.hidden = NO;
        }else if (row == 2) {
            
            _typeImage.image = IMAGE(@"overTimeNormal");
            _typeLabel.text = @"加班时长";
            _arrowImage.hidden = NO;
            _bottomLine.hidden = NO;
        }else {
            
            _typeImage.image = IMAGE(@"residueSalary");
            _typeLabel.text = @"点工工钱";
            
            _arrowImage.hidden = YES;
            _bottomLine.hidden = YES;
        }
        
    }else {
        
        if (row == 0) {
            
            _typeImage.image = IMAGE(@"SitPro");
            _typeLabel.text = @"所在项目";
            _bottomLine.hidden = NO;
        }else {
            
            _typeImage.image = IMAGE(@"markBillremark");
            _typeLabel.text = @"备注";
            _bottomLine.hidden = YES;
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



- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    NSInteger section = _cellTag / 10;
    NSInteger row = _cellTag % 10;
    
    if (section == 0) {
        
        if (row == 0) {
           
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
                
                _detailLabel.text = (JLGisLeaderBool || self.isAgentMonitor) ? @"请选择工人":@"请添加你的班组长/工头";
                _detailLabel.textColor = AppFont999999Color;
            }
           
        }else {
            
            _detailLabel.text = _yzgGetBillModel.date;
            _detailLabel.font = FONT(13);
        }
        
    }else if (section == 1) {
        
        if (row == 0) {// 设置工资标准
            
            [self setTplFromLabel:_detailLabel];
            
        }else if (row == 1) {// 设置上班时长
            
            [self setManhourTimeForLabel:_detailLabel];
            
        }else if (row == 2) {// 设置加班时长
            
            [self setoverTimeForLabel:_detailLabel];
            
        }else {// 设置点工工钱
            
            [self setSalaryFromLabel:_detailLabel];
        }
        
    }else {
        
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
            
        }else {
            
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
        
    }
    
}

#pragma mark - 设置薪资模板显示
- (void)setTplFromLabel:(UILabel *)label {
    
    // 工资标准显示方式 0 - 按工天算加班显示b方式 1 - 按小时算加班显示方式
    if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
        
        if (self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
            
            label.textColor = AppFont333333Color;
            if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
                
                NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.w_h_tpl];
                
                w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.o_h_tpl];
                o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                label.text = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                
            }else{
                
                NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.w_h_tpl];
                
                w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.o_h_tpl];
                
                o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                NSString *o_s_tpl = @"";
                if (_yzgGetBillModel.set_tpl.o_h_tpl > 0) {
                    
                    o_s_tpl = [NSString stringWithFormat:@"%.2f",[NSString roundFloat:_yzgGetBillModel.set_tpl.s_tpl / _yzgGetBillModel.set_tpl.o_h_tpl]];

                }
                
                
                label.text = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,_yzgGetBillModel.set_tpl.s_tpl,o_s_tpl];
            }
        }else {
            
            label.text = @"这里设置工资";
            
            label.textColor = AppFont999999Color;
        }
        
    }else {
        
        if (self.yzgGetBillModel.set_tpl.w_h_tpl > 0) {
            
            label.textColor = AppFont333333Color;
            
            NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", _yzgGetBillModel.set_tpl.w_h_tpl];
            
            w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            NSString *o_s_tpl = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.set_tpl.o_s_tpl];
            
            label.text = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,_yzgGetBillModel.set_tpl.s_tpl,o_s_tpl];
            
        }else {
            
            label.text = @"这里设置工资";
            
            label.textColor = AppFont999999Color;
        }
    }
    
}

#pragma mark - 设置上班是长显示
- (void)setManhourTimeForLabel:(UILabel *)label
{
    if (self.yzgGetBillModel.manhour >= 0) {
        
        label.textColor = AppFont333333Color;
        if (self.yzgGetBillModel.manhour == 0 && self.yzgGetBillModel.isRest) {
            
            label.text = @"休息";
            _defaultView.hidden = YES;
            
        }else if (self.yzgGetBillModel.manhour == 0 && !self.yzgGetBillModel.isRest){
            
            label.text = @"";
            _defaultView.hidden = NO;
            
        }else{
            _defaultView.hidden = YES;
            NSString *unitStr;
            if (self.yzgGetBillModel.set_tpl.w_h_tpl == self.yzgGetBillModel.manhour) {
                
                unitStr = @"(1个工)";
                
            }else{
                
                // 工资标准为整数
                if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                    
                    if (self.yzgGetBillModel.manhour == self.yzgGetBillModel.set_tpl.w_h_tpl / 2) {
                        
                        unitStr = @"(半个工)";
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                }else {
                    
                    unitStr = @"";
                }
                
                
            }
            
            
            if ((int)self.yzgGetBillModel.manhour == self.yzgGetBillModel.manhour) {
                
                label.text = [NSString stringWithFormat:@"%.0f小时%@",self.yzgGetBillModel.manhour,unitStr];
                
            }else{
                
                label.text = [NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.manhour,unitStr];
                
            }
        }
        
    }else {
        
        _defaultView.hidden = YES;
        label.text = @"";
    }
    
}
#pragma mark - 设置加班时长显示
- (void)setoverTimeForLabel:(UILabel *)label
{
   
    label.textColor = AppFont333333Color;
    
    if (self.yzgGetBillModel.overtime >= 0) {
        
        if ((self.yzgGetBillModel.overtime == 0 && self.yzgGetBillModel.isOverWork) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.manhour >0) ||(self.yzgGetBillModel.overtime == 0&& self.yzgGetBillModel.isRest)) {
           
            label.text = @"无加班";
            
        }else if (self.yzgGetBillModel.overtime == 0 && !self.yzgGetBillModel.isOverWork) {
            
            label.text = @"";
            
        }else{
            
            NSString *unitStr;
            if (self.yzgGetBillModel.set_tpl.o_h_tpl == self.yzgGetBillModel.overtime) {
                
                unitStr = @"(1个工)";
                
            }else{
                
                // 工资标准为整数
                if ([NSString isPureInt:[[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""]]) {
                    
                    if (self.yzgGetBillModel.overtime == self.yzgGetBillModel.set_tpl.o_h_tpl / 2) {
                        
                        unitStr = @"(半个工)";
                        
                    }else {
                        
                        unitStr = @"";
                    }
                    
                }else {
                    
                    unitStr = @"";
                }
                
                
            }
            
            
            if ((int)self.yzgGetBillModel.overtime == self.yzgGetBillModel.overtime) {
                
                label.text = [NSString stringWithFormat:@"%.0f小时%@",self.yzgGetBillModel.overtime, unitStr];
                
            }else{
                
                label.text = [NSString stringWithFormat:@"%.1f小时%@",self.yzgGetBillModel.overtime, unitStr];
                
            }
        }
        
    }else {
        
        label.text = @"";
    }
    
}

#pragma mark - 设置金额
- (void)setSalaryFromLabel:(UILabel *)label
{
    
    if (![NSString isEmpty:self.yzgGetBillModel.name]) {
        
        if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
            
            label.text = @"-";
            
        }else{
            
            label.text = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
        }
        
        
        label.textColor = AppFontEB4E4EColor;
        
    }else {
        
        label.text = @"";
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
    
    [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
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

- (IDJCalendar *)calendar {
    
    if (!_calendar) {
        
        _calendar = [IDJCalendar new];
    }
    return _calendar;
}

- (JGJMarkBillManHourDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJMarkBillManHourDefaultView alloc] init];
        _defaultView.hidden = YES;
    }
    return _defaultView;
}

@end
