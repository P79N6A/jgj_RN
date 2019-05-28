//
//  JGJRecordWorkpointsAllTypeMoneyCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsAllTypeMoneyCell.h"

#import "UILabel+GNUtil.h"

@interface JGJRecordWorkpointsAllTypeMoneyCell ()
//上班
@property (weak, nonatomic) IBOutlet UILabel *workLable;

@property (weak, nonatomic) IBOutlet UIView *workFlagView;
//加班
@property (weak, nonatomic) IBOutlet UILabel *overTimeLable;

//加班标识
@property (weak, nonatomic) IBOutlet UIView *overTimeFlagView;


@property (weak, nonatomic) IBOutlet UIView *borrowMoneyFlagView;

@property (weak, nonatomic) IBOutlet UILabel *borrowCountLable;

@property (weak, nonatomic) IBOutlet UIView *borrowCountFlagView;

@property (weak, nonatomic) IBOutlet UILabel *settlementCountLable;

@property (weak, nonatomic) IBOutlet UIView *settlementCountFlagView;

//分包
@property (weak, nonatomic) IBOutlet UIView *contractorFlagView;

@property (weak, nonatomic) IBOutlet UILabel *contractorLable;

@property (weak, nonatomic) IBOutlet UILabel *contractorMoneyLable;


//点工
@property (weak, nonatomic) IBOutlet UIView *shortWorkFlagView;


@property (weak, nonatomic) IBOutlet UILabel *shortWorkLable;

@property (weak, nonatomic) IBOutlet UILabel *shortWorkMoneyLable;

//承包

@property (weak, nonatomic) IBOutlet UILabel *undertakeLable;

@property (weak, nonatomic) IBOutlet UILabel *undertakeMoneyLable;

@property (weak, nonatomic) IBOutlet UIView *undertakeFlagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undetakeLableTop;

//借支

@property (weak, nonatomic) IBOutlet UILabel *borrowMoneyLable;

@property (weak, nonatomic) IBOutlet UILabel *borrowTitleLable;

//结算
@property (weak, nonatomic) IBOutlet UILabel *settlementMoneyLable;

@property (weak, nonatomic) IBOutlet UILabel *settlementTitleLable;

@property (weak, nonatomic) IBOutlet UIView *settlementMoneyFlagView;

@end

@implementation JGJRecordWorkpointsAllTypeMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    CGFloat radius = 3.0;
    
    self.shortWorkFlagView.backgroundColor = redColor;
    
    self.workFlagView.backgroundColor = redColor;
    
    self.overTimeFlagView.backgroundColor = redColor;
    
    self.contractorFlagView.backgroundColor = redColor;
    
    
    [self.shortWorkFlagView.layer setLayerCornerRadius:radius];
    
    [self.contractorFlagView.layer setLayerCornerRadius:radius];
    
    [self.workFlagView.layer setLayerCornerRadius:radius];
    
    [self.overTimeFlagView.layer setLayerCornerRadius:radius];
    
    [self.undertakeFlagView.layer setLayerCornerRadius:radius];
    
    //借支、结算
    
    self.borrowMoneyFlagView.backgroundColor = greenColor;
    
    self.borrowCountFlagView.backgroundColor = greenColor;
    
    self.settlementMoneyFlagView.backgroundColor = greenColor;
    
    self.settlementCountFlagView.backgroundColor = greenColor;
    
    self.undertakeFlagView.backgroundColor = JLGisLeaderBool ? greenColor : redColor;
    
    
    
    [self.borrowMoneyFlagView.layer setLayerCornerRadius:radius];
    
    [self.borrowCountFlagView.layer setLayerCornerRadius:radius];
    
    [self.settlementMoneyFlagView.layer setLayerCornerRadius:radius];
    
    [self.settlementCountFlagView.layer setLayerCornerRadius:radius];
    
    
    
    self.shortWorkLable.textColor = AppFont333333Color;
    
    self.borrowCountLable.textColor = AppFont333333Color;
    
    self.contractorLable.textColor = AppFont333333Color;
    
    self.workLable.textColor = AppFont333333Color;
    
    
    self.borrowMoneyLable.textColor = AppFont333333Color;
    
    self.borrowCountLable.textColor = AppFont333333Color;
    
    self.settlementMoneyLable.textColor = AppFont333333Color;
    
    self.settlementCountLable.textColor = AppFont333333Color;
    
    self.undetakeLableTop.constant = JLGisLeaderBool ? 25 : 3;
    
    self.contractorLable.hidden = JLGisMateBool;
    
    self.contractorFlagView.hidden = JLGisMateBool;
    
    self.contractorMoneyLable.hidden = JLGisMateBool;
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.shortWorkMoneyLable.font = boldFont;
    
    self.shortWorkMoneyLable.textColor = redColor;
    
    self.contractorMoneyLable.font = boldFont;
    
    self.contractorMoneyLable.textColor = redColor;
    
    self.undertakeMoneyLable.font = boldFont;
    
    //承包
    self.undertakeMoneyLable.textColor = JLGisLeaderBool ? greenColor: redColor;
    
    self.borrowMoneyLable.font = boldFont;
    
    //借支
    self.borrowMoneyLable.textColor = greenColor;
    
//    结算
    self.settlementMoneyLable.font = boldFont;
    
    self.settlementMoneyLable.textColor = greenColor;
    
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    UIColor *redColor = AppFontEB4E4EColor;
    
    UIColor *greenColor = AppFont83C76EColor;
    
    //点工
    
    NSString *unit = @" 小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @" 个工";
    }
    
    NSString *over_work_unit = @" 小时";
    
    if (_showType == 1) {
        
        over_work_unit = @" 个工";
    }
    
    NSString *space = @":  ";
    
    NSString *Rspace = @"";
    
    //上班
    
    self.workLable.text = [NSString stringWithFormat:@"上班%@%@%@", space,_showType == 2 ?_recordWorkStaModel.work_type.manhour?:@"0" :_recordWorkStaModel.work_type.working_hours?:@"0", unit];
    
    //点工
    self.shortWorkMoneyLable.text = [NSString stringWithFormat:@"%@%@", Rspace, _recordWorkStaModel.work_type.amounts?:@""];
    
    UIFont *changeFont = [UIFont systemFontOfSize:AppFont26Size];
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:AppFont30Size];
        
    //加班
    self.overTimeLable.text = [NSString stringWithFormat:@"加班%@%@%@", space,_showType != 1 ?_recordWorkStaModel.work_type.overtime?:@"0" :_recordWorkStaModel.work_type.overtime_hours?:@"0", over_work_unit];
    
    //包工分包
    self.contractorMoneyLable.text =  [NSString stringWithFormat:@"%@",  _recordWorkStaModel.contract_type_two.amounts?:@""];
    
    //包工承包
    self.undertakeMoneyLable.text =  [NSString stringWithFormat:@"%@",  _recordWorkStaModel.contract_type_one.amounts?:@""];
    
    
    // 借支
    self.borrowMoneyLable.text =  [NSString stringWithFormat:@"%@%@", Rspace, _recordWorkStaModel.expend_type.amounts?:@""];
    
    // 借支金额
    self.borrowMoneyLable.text =  [NSString stringWithFormat:@"%@%@", Rspace, _recordWorkStaModel.expend_type.amounts?:@""];
    
    NSString *countUnit = [NSString stringWithFormat:@" 笔"];
    
    //借支笔数
    self.borrowCountLable.text = [NSString stringWithFormat:@"借支%@%@%@", space, _recordWorkStaModel.expend_type.total?:@"", countUnit];
    
    //结算
    self.settlementMoneyLable.text = [NSString stringWithFormat:@"%@%@", Rspace, _recordWorkStaModel.balance_type.amounts?:@""];
    
    //结算笔数
    self.settlementCountLable.text = [NSString stringWithFormat:@"结算%@%@%@", space, _recordWorkStaModel.balance_type.total?:@"", countUnit];
    
    if (_showType == 0 || _showType == 1) {
        
        //上班工颜色
        if (![NSString isEmpty:_recordWorkStaModel.work_type.working_hours]) {
            
            [self.workLable markText:_recordWorkStaModel.work_type.working_hours withFont:boldFont color:redColor];
        }
        
        if (_showType == 1) {
            
            //加班工颜色
            if (![NSString isEmpty:_recordWorkStaModel.work_type.overtime_hours]) {
                
                [self.overTimeLable markText:_recordWorkStaModel.work_type.overtime_hours withFont:boldFont color:redColor];
            }
            
        }else {
            
            //加班小时颜色
            if (![NSString isEmpty:_recordWorkStaModel.work_type.overtime]) {
                
                [self.overTimeLable markText:_recordWorkStaModel.work_type.overtime withFont:boldFont color:redColor];
            }
        }
        
    }else {
        
        //上班小时颜色
        if (![NSString isEmpty:_recordWorkStaModel.work_type.manhour]) {
            
            [self.workLable markText:_recordWorkStaModel.work_type.manhour withFont:boldFont color:redColor];
            
        }
        
        //加班小时颜色
        if (![NSString isEmpty:_recordWorkStaModel.work_type.overtime]) {
            
            [self.overTimeLable markText:_recordWorkStaModel.work_type.overtime withFont:boldFont color:redColor];
        }
    }
    
    
    
    
    
    
    
    
    //点工
    if (![NSString isEmpty:_recordWorkStaModel.work_type.amounts]) {
        
        [self.shortWorkLable markText:_recordWorkStaModel.work_type.amounts withFont:boldFont color:redColor];
        
    }
    
    //包工分包
    if (![NSString isEmpty:_recordWorkStaModel.contract_type_two.amounts]) {
        
        [self.contractorLable markText:_recordWorkStaModel.contract_type_two.amounts withFont:boldFont color:redColor];
    }
    
    //包工承包
    if (![NSString isEmpty:_recordWorkStaModel.contract_type_one.amounts]) {
        
        UIColor *color = JLGisLeaderBool ? greenColor : redColor;
        
        [self.undertakeLable markText:_recordWorkStaModel.contract_type_one.amounts withFont:boldFont color:color];
    }
    
    //借支颜色
    if (![NSString isEmpty:_recordWorkStaModel.expend_type.total]) {

        [self.borrowCountLable markText:_recordWorkStaModel.expend_type.total withFont:boldFont color:greenColor];
    }

    if (![NSString isEmpty:_recordWorkStaModel.expend_type.amounts]) {

        [self.borrowMoneyLable markText:_recordWorkStaModel.expend_type.amounts withFont:boldFont color:greenColor];
    }
    
    //结算颜色
    
    TYLog(@"=========%@", self.settlementMoneyLable.text);
    
    if (![NSString isEmpty:_recordWorkStaModel.balance_type.total]) {
        
        [self.settlementCountLable markText:_recordWorkStaModel.balance_type.total withFont:boldFont color:greenColor];
    }
    
    if (![NSString isEmpty:_recordWorkStaModel.balance_type.amounts]) {
        
        [self.settlementMoneyLable markText:_recordWorkStaModel.balance_type.amounts withFont:boldFont color:greenColor];
    }

}

+(CGFloat)cellHeight {
    
    CGFloat height = 134.0 - (JLGisLeaderBool ? 0 : 25);
    
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
