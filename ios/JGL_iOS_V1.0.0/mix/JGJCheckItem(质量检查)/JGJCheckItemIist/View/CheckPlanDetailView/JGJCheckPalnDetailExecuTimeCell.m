//
//  JGJCheckPalnDetailExecuTimeCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPalnDetailExecuTimeCell.h"

@interface JGJCheckPalnDetailExecuTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@end

@implementation JGJCheckPalnDetailExecuTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLable.textColor = AppFont333333Color;
    
    self.statusLable.textColor = [UIColor whiteColor];
    
    [self.statusLable.layer setLayerCornerRadius:1.5];
    
    self.statusLable.font = [UIFont systemFontOfSize:AppFont30Size];
}

- (void)setInspectListDetailModel:(JGJInspectListDetailModel *)inspectListDetailModel {
    
    _inspectListDetailModel = inspectListDetailModel;
    
    self.timeLable.text = inspectListDetailModel.execute_time;
    
    [self handleExecuteStatusWithInspectListDetailModel:inspectListDetailModel];
}

#pragma mark - 执行状态
- (void)handleExecuteStatusWithInspectListDetailModel:(JGJInspectListDetailModel *)inspectListDetailModel {
    
    NSString *status = [NSString stringWithFormat:@"进行中%@%%",inspectListDetailModel.execute_percent];
    
    UIColor *stausBackColor = AppFontF9A00FColor;
    
    CGFloat statusW = 55;
    
    if ([inspectListDetailModel.execute_percent isEqualToString:@"0"]) {
        
        stausBackColor = AppFont999999Color;
        
        status = @"未开始";
        
        
    }else if ([inspectListDetailModel.execute_percent isEqualToString:@"100"]) {
        
        stausBackColor = AppFont83C76EColor;
        
        status = @"已完成";
        
    }else {
        
        statusW = [NSString stringWithContentSize:CGSizeMake(300, 50) content:status font:AppFont30Size].width + 8;
                
    }
    
    
    [self.statusLable mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(statusW);
    }];
    
    [self.statusLable layoutIfNeeded];
    
    self.statusLable.text = status;
    
    self.statusLable.backgroundColor = stausBackColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
