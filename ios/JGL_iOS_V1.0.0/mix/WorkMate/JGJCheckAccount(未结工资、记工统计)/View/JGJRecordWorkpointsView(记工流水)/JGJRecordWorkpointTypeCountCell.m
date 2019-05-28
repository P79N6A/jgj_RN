//
//  JGJRecordWorkpointTypeCountCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointTypeCountCell.h"

@interface JGJRecordWorkpointTypeCountCell ()

@property (weak, nonatomic) IBOutlet UILabel *workLable;

@property (weak, nonatomic) IBOutlet UILabel *contractorLable;

@property (weak, nonatomic) IBOutlet UILabel *borrowLable;

@property (weak, nonatomic) IBOutlet UILabel *overTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *settlementLable;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation JGJRecordWorkpointTypeCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIFont *font = [UIFont systemFontOfSize:AppFont26Size];
    
    UIColor *color = AppFont999999Color;
    
    self.workLable.font = font;
    
    self.overTimeLable.font = font;
    
    self.contractorLable.font = font;
    
    self.borrowLable.font = font;
    
    self.settlementLable.font = font;
    
    
    self.workLable.textColor = color;
    
    self.overTimeLable.textColor = color;
    
    self.contractorLable.textColor = color;
    
    self.borrowLable.textColor = color;
    
    self.settlementLable.textColor = color;
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    NSString *space = @":  ";
    
    //点工
    
    NSString *unit = @"个工";
    
    if (self.isShowWork) {
        
        unit = @"小时";
    }
    
    NSString *otherUnit = @"笔";
    
    //上班
    self.workLable.text = [NSString stringWithFormat:@"上班%@%@%@", space,self.isShowWork ?recordWorkStaModel.work_type.manhour?:@"" :recordWorkStaModel.work_type.working_hours?:@"", unit];
    
    //加班
    self.overTimeLable.text = [NSString stringWithFormat:@"加班%@%@%@", space,self.isShowWork ?recordWorkStaModel.work_type.overtime?:@"" :recordWorkStaModel.work_type.overtime_hours?:@"", unit];
    
    //包工
    self.contractorLable.text = [NSString stringWithFormat:@"包工%@%@%@", space,recordWorkStaModel.contract_type.total?:@"", otherUnit];
    
    //借支
    
    self.borrowLable.text = [NSString stringWithFormat:@"借支%@%@%@", space,recordWorkStaModel.expend_type.total?:@"", otherUnit];
    
    //结算
    
    self.settlementLable.text = [NSString stringWithFormat:@"结算%@%@%@", space,recordWorkStaModel.balance_type.total?:@"", otherUnit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
