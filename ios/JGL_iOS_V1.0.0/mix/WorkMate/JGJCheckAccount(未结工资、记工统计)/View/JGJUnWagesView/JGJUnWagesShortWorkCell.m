//
//  JGJUnWagesShortWorkCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWagesShortWorkCell.h"

#import "CustomView.h"

@interface JGJUnWagesShortWorkCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLableW;

@property (weak, nonatomic) IBOutlet UILabel *workLable;

@property (weak, nonatomic) IBOutlet UILabel *overTimeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overTimeLabelTopConsraints;

@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@property (weak, nonatomic) IBOutlet UILabel *workLeaderNameLable;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *diffAccountImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mulSelButtonW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTrail;

@property (weak, nonatomic) IBOutlet UIButton *mulSelButton;


@property (weak, nonatomic) IBOutlet UIImageView *mulSelImageView;

@property (weak, nonatomic) IBOutlet UILabel *otherType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lead;

@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageViewW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageViewCenterY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyImageViewTrail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteCenterY;

@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteTrail;

@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;


@end

@implementation JGJUnWagesShortWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIFont *font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.nameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    [self.nameBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.workLable.textColor = AppFont333333Color;
    
    self.workLable.font = font;
    
    self.overTimeLable.textColor = AppFont333333Color;
    
    self.overTimeLable.font = font;
    
    self.proNameLable.textColor = AppFont999999Color;
    
    self.proNameLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.workLeaderNameLable.textColor = AppFont999999Color;
    
    self.workLeaderNameLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.mulSelButtonW.constant = 0;
    
    self.otherType.textColor = AppFont333333Color;
    
    self.moneyLable.textColor = AppFont333333Color;
    
    self.moneyLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.lineView.hidden = YES;
    
}

- (void)setIsHiddenLineView:(BOOL)isHiddenLineView {
    
    _isHiddenLineView = isHiddenLineView;
    
    self.lineView.hidden = isHiddenLineView;
}

- (void)setListModel:(JGJRecordWorkPointListModel *)listModel {
    
    _listModel = listModel;
    
    //点工
    
    NSString *space = @":  ";
    
    //点工
    
    NSString *unit = @"小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @"个工";
    }
    
    
    NSString *working_hours = listModel.working_hours;
    
    NSString *manhour = listModel.manhour;
    
    if ([working_hours isEqualToString:@"0"]) {
        
        working_hours = @"休息";
        
        unit = @"";
    }
    
    if ([manhour isEqualToString:@"0"]) {
        
        manhour = @"休息";
        
        unit = @"";
    }
    
    self.workLable.text = [NSString stringWithFormat:@"上班%@%@%@", space, _showType == 2 ? manhour : working_hours, unit];
    
    NSString *overtimeUnit = @"小时";
    
    if (_showType == 1) {
        
        overtimeUnit = @"个工";
    }
    
    NSString *overtime_hours = listModel.overtime_hours;
    
    NSString *overtime = listModel.overtime;
    
    if ([overtime_hours isEqualToString:@"0"]) {
        
        overtime_hours = @"无加班";
        
        overtimeUnit = @"";
    }
    
    if ([overtime isEqualToString:@"0"]) {
        
        overtime = @"无加班";
        
        overtimeUnit = @"";
    }
    
    self.overTimeLable.text = [NSString stringWithFormat:@"加班%@%@%@", space, _showType != 1 ?overtime : overtime_hours, overtimeUnit];
    
    CGFloat amountMoney = 0.0;
    if (self.isCurrentSureBillVCComeIn) {
        
        if ([listModel.accounts_type isEqualToString:@"1"]) {
            
            CGFloat listManHoure = [listModel.manhour floatValue];
            CGFloat listw_h_tpl = [listModel.set_tpl.w_h_tpl floatValue];
            CGFloat listOverTime = [listModel.overtime floatValue];
            CGFloat listo_h_tpl = [listModel.set_tpl.o_h_tpl floatValue];
            if (listModel.set_tpl.hour_type == 1) {// 按小时算加班
                
                if (listw_h_tpl > 0) {
                    
                    amountMoney = (listManHoure / listw_h_tpl) * listModel.set_my_amounts_tpl;
                }
                
                amountMoney = amountMoney + listOverTime * listModel.set_tpl.o_s_tpl;
                
            }else {// 按工天算加班
                
                if (listw_h_tpl > 0) {
                    
                    amountMoney = (listManHoure / listw_h_tpl) * listModel.set_my_amounts_tpl;
                }
                
                if (listo_h_tpl > 0) {
                    
                    amountMoney = amountMoney + (listOverTime / listo_h_tpl) * listModel.set_my_amounts_tpl;
                }
            }
            
            
        }else {
            
            amountMoney = [listModel.amounts floatValue];
        }
        
    }else {
        
        amountMoney = [listModel.amounts floatValue];
        
    }
    
    if (amountMoney == 0.0) {
        
        if ([listModel.accounts_type isEqualToString:@"1"] || [listModel.accounts_type isEqualToString:@"5"]) {
            
            if ([listModel.set_tpl.s_tpl floatValue] == 0) {
                
                self.moneyLable.text = @"-";
                
            }else {
                
                self.moneyLable.text = [NSString stringWithFormat:@"%.2f",amountMoney];
            }
        }else {
            
            self.moneyLable.text = [NSString stringWithFormat:@"%.2f",amountMoney];
            
        }
        
    }else {
        
        self.moneyLable.text = [NSString stringWithFormat:@"%.2f",amountMoney];
    }
    
    
    self.proNameLable.text = listModel.proname;
    
    //存在差账显示差账标记
    self.diffAccountImageView.hidden = !listModel.amounts_diff;
    
    //    //批量删除
    
    [self otherTypeWithListModel:listModel];
    
    NSString *contractor_type = listModel.contractor_type;
    
    NSString *foreman_name = [NSString shortWorkeCelCutWithContent:_listModel.foreman_name maxLength:4];
    
    self.workLeaderNameLable.text  = [NSString stringWithFormat:@"班组长：%@", foreman_name];
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    if (JLGisLeaderBool && [contractor_type isEqualToString:@"1"]) {
        
        self.workLeaderNameLable.text  = [NSString stringWithFormat:@"承包对象：%@", foreman_name];
        
        self.moneyLable.textColor = AppFont83C76EColor;
        
    }
    
    [self jgj_updateWithConstraint:self.mulSelButtonW width:_isBatchDel ? 45 : 12];
    
    NSString *selFlagStr = listModel.isSel ? @"MultiSelected" : @"RecordWorkpoints_not_selected";
    
    self.mulSelImageView.hidden = !_isBatchDel;
    
    self.mulSelImageView.image = [UIImage imageNamed:selFlagStr];
    
    [self setNameWithListModel:listModel];
    
}

- (void)jgj_updateWithConstraint:(NSLayoutConstraint *)constraint width:(CGFloat)width {
    
    if (constraint.constant == width) {
        
        return;
        
    }
    
    constraint.constant = width;
    
}

#pragma mark - 包工、借支、结算 工种 1：点工；2：包工；3：借支；4：结算
- (void)otherTypeWithListModel:(JGJRecordWorkPointListModel *)listModel {
    
    BOOL isShortWork = [listModel.accounts_type isEqualToString:@"1"];
    
    self.workLable.hidden = !isShortWork;
    
    self.overTimeLable.hidden = !isShortWork;
    
    self.otherType.hidden = isShortWork;
    
    self.moneyLable.textColor = AppFontEB4E4EColor;
    
    if (!isShortWork) {
        
        if ([listModel.accounts_type isEqualToString:@"2"]) {
            
            self.otherType.text = @"包工";
            NSString *contractor_type = listModel.contractor_type;
            
            if ([contractor_type isEqualToString:@"1"]) {
                
                self.otherType.text = @"包工(承包)";
                
            }else if ([contractor_type isEqualToString:@"2"]) {
                
                self.otherType.text = @"包工(分包)";
            }
            
            self.moneyLable.textColor = AppFontEB4E4EColor;
            
        }else if ([listModel.accounts_type isEqualToString:@"3"]) {
            
            self.otherType.text = @"借支";
            
            self.moneyLable.textColor = AppFont83C76EColor;
            
        }else if ([listModel.accounts_type isEqualToString:@"4"]) {
            
            self.otherType.text = @"结算";
            
            self.moneyLable.textColor = AppFont83C76EColor;
            
        }else if ([listModel.accounts_type isEqualToString:@"5"]) {
            
            self.workLable.hidden = NO;
            self.overTimeLable.hidden = NO;
            self.otherType.hidden = YES;
            
        }
        
    }
    
}

- (void)setIsScreenShowLine:(BOOL)isScreenShowLine {
    
    _isScreenShowLine = isScreenShowLine;
    
    [self jgj_updateWithConstraint:self.lead width:_isScreenShowLine ? 0 : 12];
    
    [self jgj_updateWithConstraint:self.trail width:_isScreenShowLine ? 0 : 12];
    
}

#pragma mark - 设置名字
- (void)setNameWithListModel:(JGJRecordWorkPointListModel *)listModel {
    
    NSString *name = [NSString shortWorkeCelCutWithContent:_listModel.worker_name maxLength:4];
    
    self.nameLable.text = name;
    
    NSString *typeStr = nil;
    
    if ([listModel.accounts_type isEqualToString:@"1"]) { //点工
        
        typeStr = @"work_type_icon";
        
    }else if ([listModel.accounts_type isEqualToString:@"5"]) {// 包工考勤
        
        typeStr = @"contract_type_icon";
        
    }
    
    UIImage *typeImage = [UIImage imageNamed:typeStr];
    
    //结算借支和没有标记和名字对齐
    //    [self jgj_updateWithConstraint:self.tyImageViewTrail width:[NSString isEmpty:typeStr] && !listModel.is_notes ? 0 : 5];
    
    //    [self jgj_updateWithConstraint:self.typeImageViewW width:[NSString isEmpty:typeStr] && !listModel.is_notes ? 0 : 14];
    
    CGFloat centerY = listModel.is_notes ? 10 : 0;
    
    //是借支和结算情况
    BOOL is_borrow = ![listModel.accounts_type isEqualToString:@"1"] && ![listModel.accounts_type isEqualToString:@"5"];
    
    self.noteImageView.hidden = !listModel.is_notes;
    
    [self jgj_updateWithConstraint:self.noteCenterY width:centerY];
    
    [self jgj_updateWithConstraint:self.typeImageViewCenterY width:-centerY];
    
    if (is_borrow && listModel.is_notes) {//借支结算有备注居中显示 备
        
        [self jgj_updateWithConstraint:self.noteCenterY width:0];
        
    }else if (!is_borrow && listModel.is_notes) {
        
        [self jgj_updateWithConstraint:self.noteCenterY width:centerY];
        
        [self jgj_updateWithConstraint:self.typeImageViewCenterY width:-centerY];
        
    }else if (!is_borrow && !listModel.is_notes) {
        
        [self jgj_updateWithConstraint:self.typeImageViewCenterY width:0];
        
    }
    
    self.typeImageView.image = typeImage;
    
    self.typeImageView.hidden = [NSString isEmpty:typeStr];
    
    self.noteImageView.image = [UIImage imageNamed:@"note_icon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
