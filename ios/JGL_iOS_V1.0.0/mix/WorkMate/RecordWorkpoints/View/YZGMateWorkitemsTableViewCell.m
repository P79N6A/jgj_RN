//
//  YZGMateWorkitemsTableViewCell.m
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateWorkitemsTableViewCell.h"
#import "CustomView.h"
#import "NSString+Extend.h"
#import "TYVerticalLabel.h"
#import "YZGMateWorkitemsModel.h"
#import "YZGRecordWorkpointTool.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@interface YZGMateWorkitemsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountType;
@property (weak, nonatomic) IBOutlet UILabel *amountsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIImageView *leaderMarkerImageView;
@property (weak, nonatomic) IBOutlet TYVerticalLabel *amoutDiffLabel;
@property (weak, nonatomic) IBOutlet LineView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaderMarkerImageLayoutL;
@end

@implementation YZGMateWorkitemsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deleteButton.hidden = YES;
    self.removeButton.hidden = YES;

    [self.removeButton.layer setLayerBorderWithColor:self.removeButton.titleLabel.textColor width:0.5 ration:0.08];
//    self.jgjCellBottomLineView = self.bottomLineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMateWorkitemsValue:(MateWorkitemsItems *)mateWorkitemsValue{
    _mateWorkitemsValue = mateWorkitemsValue;

    if (JLGisMateBool) {//工人身份的时候就根据内容是否显示"工人记"的标记
        self.leaderMarkerImageView.image = [UIImage imageNamed:@"RecordWorkpoints_leader Marker"];
        self.leaderMarkerImageView.hidden = mateWorkitemsValue.role != 2;
    }else{//班组长/工头身份的时候直接不显示
        self.leaderMarkerImageView.image = [UIImage imageNamed:@"RecordWorkpoints_mate Marker"];
        self.leaderMarkerImageView.hidden = mateWorkitemsValue.role != 1;
    }

    self.nameLabel.text = mateWorkitemsValue.name;
    self.amountsLabel.hidden = mateWorkitemsValue.is_del;
    self.removeButton.hidden = !mateWorkitemsValue.is_del;
    
    if (mateWorkitemsValue.is_del) {//显示移除的情况
        self.accountType.text  = mateWorkitemsValue.accounts_type.txt;
    }else{//不移除的情况
        //设置中间的label
        if (mateWorkitemsValue.accounts_type.code != 1) {
            self.accountType.text  = mateWorkitemsValue.accounts_type.txt;
        }else{
            NSMutableAttributedString *contentStr;
            if ([NSString isEmpty:mateWorkitemsValue.overtime]) {
                contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",mateWorkitemsValue.manhour]];
            }else{
                contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",mateWorkitemsValue.manhour,mateWorkitemsValue.overtime]];
            }
            
            
            [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x333333) range:NSMakeRange(0, mateWorkitemsValue.manhour.length)];
            [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, mateWorkitemsValue.manhour.length)];
            
            if (![NSString isEmpty:mateWorkitemsValue.overtime]) {
                [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(mateWorkitemsValue.manhour.length + 1, mateWorkitemsValue.overtime.length)];
                [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(mateWorkitemsValue.manhour.length + 1, mateWorkitemsValue.overtime.length)];
            }
            self.accountType.attributedText = contentStr;
        }
    }
    
    //2.1.1删除之后形成差账显示--
    if (mateWorkitemsValue.amounts_diff && [mateWorkitemsValue.manhour isEqualToString:@"0"]) {
//        self.accountType.textColor = AppFontd7252cColor;
        self.accountType.text = @"--";
    }

    CGFloat amounts = mateWorkitemsValue.amounts*(mateWorkitemsValue.accounts_type.code == 3?-1:1);
    if (mateWorkitemsValue.accounts_type.code == 4) {
     amounts = mateWorkitemsValue.amounts*(mateWorkitemsValue.accounts_type.code == 4?-1:1);
    }
    [YZGRecordWorkpointTool setLabel:self.amountsLabel amount:amounts];
    if (mateWorkitemsValue.accounts_type.code > 2) {//后台该除了问题 2017-6-11添加
        _amountsLabel.textColor = TYColorHex(0x92c977);
    }
    if (mateWorkitemsValue.is_del) {//是移除的情况
        self.deleteButton.hidden = YES;
    }else{//不是移除的情况
        self.deleteButton.hidden = NO;
        switch (mateWorkitemsValue.modify_marking) {
            case 0://没有查账,显示叉的图片
            {
                [self.deleteButton setImage:[UIImage imageNamed:@"RecordWorkpoints_cellDelete"] forState:UIControlStateNormal];
                self.deleteButton.userInteractionEnabled = YES;
                self.deleteButton.hidden = YES; //删除当前隐藏 2.1.2-yj
                break;
            }
            case 2:
            {
                [self.deleteButton setImage:[UIImage imageNamed:@"RecordWorkpoints_cellOther"] forState:UIControlStateNormal];
                self.deleteButton.userInteractionEnabled = NO;
                break;
            }
            case 3:
            {
                [self.deleteButton setImage:[UIImage imageNamed:@"RecordWorkpoints_cellMine"] forState:UIControlStateNormal];
                self.deleteButton.userInteractionEnabled = NO;
                break;
            }case 4:
            {
                [self.deleteButton setImage:[UIImage imageNamed:@"RecordWorkpoints_cellMine"] forState:UIControlStateNormal];
                self.deleteButton.userInteractionEnabled = NO;
                break;
            }

            default:
                break;
        }
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.yzdelegate && [self.yzdelegate respondsToSelector:@selector(MateWorkitemsDeleteBtnClick:)]) {
        [self.yzdelegate MateWorkitemsDeleteBtnClick:self];
    }
}

- (IBAction)removeBtnClick:(id)sender {
    if (self.yzdelegate && [self.yzdelegate respondsToSelector:@selector(MateWorkitemsRemoveBtnClick:)]) {
        [self.yzdelegate MateWorkitemsRemoveBtnClick:self];
    }
}
//amounts_diff 1是有差张
-(void)setDayCheckingModel:(JGJDayCheckingModel *)DayCheckingModel
{
    NSString *ManunitStr;
    NSString *OverunitStr;

    NSString *manHourStr;
    NSString *overStr;

    ManunitStr = @"小时";
    
    manHourStr = DayCheckingModel.manhour?:@"";
    
    if (_showType == 0 || _showType == 1) {
        
        ManunitStr = @"个工";
        
        manHourStr = DayCheckingModel.working_hours?:@"";
    }
    
    OverunitStr = @"小时";
    
    overStr = DayCheckingModel.overtime?:@"";
    
    if (_showType == 1) {
        
        OverunitStr = @"个工";
        
        overStr = DayCheckingModel.overtime_hours?:@"";
    }
    
    
    if (DayCheckingModel.is_rest) {
        manHourStr = @"休息";
        ManunitStr = @"";

    }
    if (![DayCheckingModel.overtime floatValue]){
        
        overStr = @"无加班";
        OverunitStr = @"";
    }
    
    if ([DayCheckingModel.manhour floatValue] == 0) {
        
        manHourStr = @"休息";
        ManunitStr = @"";
    }
    
    self.proNameLabler.text = DayCheckingModel.proname;
    if (DayCheckingModel.contractor_type == 1 && JLGisLeaderBool) {
        
        self.recordNameLable.text = [NSString stringWithFormat:@"承包对象：%@" ,[self.recordNameLable sublistNameSurplusFour:DayCheckingModel.foreman_name]];
        
    }else {
        
        self.recordNameLable.text = [NSString stringWithFormat:@"班组长：%@" ,[self.recordNameLable sublistNameSurplusFour:DayCheckingModel.foreman_name] ];
    }
    

    self.leaderMarkerImageView.hidden = YES;
    self.nameLabel.text = [self.nameLabel sublistNameSurplusFour:DayCheckingModel.worker_name];
    
    if ([DayCheckingModel.accounts_type isEqualToString: @"1"] || [DayCheckingModel.accounts_type isEqualToString: @"5"]) {
        
        self.accountType.text = [NSString stringWithFormat:@"上班：%@%@\n加班：%@%@",manHourStr,ManunitStr,overStr,OverunitStr];
        [self.accountType SetLinDepart:5];
        
        if ([DayCheckingModel.accounts_type isEqualToString: @"1"]) {
            
            self.typeImage.image = IMAGE(@"work_type_icon");
            
        }else {
            
            self.typeImage.image = IMAGE(@"contract_type_icon");
        }
        
        if (DayCheckingModel.is_notes) {// 有备注
            
            self.remarkImage.hidden = NO;
            self.typeImageCenterY.constant = -8;
            
            
        }else {
            
            self.remarkImage.hidden = YES;
            self.typeImageCenterY.constant = 0;
        }
        
    }else{
        
        if ([DayCheckingModel.accounts_type isEqualToString:@"2"]) {
            
            
            if (DayCheckingModel.contractor_type == 1) {// 承包
            
                self.accountType.text  = @"包工(承包)";
                
            }else if (DayCheckingModel.contractor_type == 2) {// 分包
                
                self.accountType.text  = @"包工(分包)";
                
            }
            
        }else if ([DayCheckingModel.accounts_type isEqualToString:@"3"]){
            
            self.accountType.text  = @"借支";
            
        }else{
            
            self.accountType.text  = @"结算";
        }
        
        
        if (DayCheckingModel.is_notes) {// 有备注
            
            self.remarkImage.hidden = NO;
            self.remakrCenterY.constant = 0;
            
            
        }else {
            
            self.remarkImage.hidden = YES;
        }

    }
    
    int code = [DayCheckingModel.accounts_type intValue];

    self.amountsLabel.text = DayCheckingModel.amounts?:@"";
    
    
    if (code > 2) {//后台该除了问题 2017-6-11添加
        
        _amountsLabel.textColor = AppFont83C76EColor;
        
    }else{
        
        self.amountsLabel.textColor = AppFontd7252cColor;
    }
    
    if (code == 5) {
        
        self.amountsLabel.textColor = AppFontd7252cColor;
    }
    
    if (code == 2) {
        
        if (DayCheckingModel.contractor_type == 1) {// 承包
            
            if (JLGisLeaderBool) {
                
                _amountsLabel.textColor = AppFont83C76EColor;
                
            }else {
                
                self.amountsLabel.textColor = AppFontd7252cColor;
            }
            
        }else if (DayCheckingModel.contractor_type == 2) {// 分包
            
            self.amountsLabel.textColor = AppFontd7252cColor;
        }
    }
    
    if ([DayCheckingModel.amounts_diff intValue]) {
        
        self.amoutDiffImageview.hidden = NO;
        self.amoutConstance.constant = 30;
        
    }else{
        
        self.amoutDiffImageview.hidden = YES;
        self.amoutConstance.constant = 10;

    }
}

@end
