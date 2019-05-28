//
//  JGJCheckListCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckListCell.h"

#import "UILabel+GNUtil.h"

@interface JGJCheckListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *redFlagImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *execuTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *execuPerLable;

@property (weak, nonatomic) IBOutlet UILabel *checkItemLable;

@property (weak, nonatomic) IBOutlet UILabel *passRateLable;

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@end

@implementation JGJCheckListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containView.layer setLayerCornerRadius:2.5];
    
    self.titleLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.execuTimeLable.textColor = AppFont333333Color;
    
    self.execuPerLable.textColor = AppFont333333Color;
    
    self.passRateLable.textColor = AppFont333333Color;
    
    self.statusLable.textColor = [UIColor whiteColor];
    
    [self.statusLable.layer setLayerCornerRadius:1.5];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)setInspectListModel:(JGJInspectListModel *)inspectListModel {
    
    _inspectListModel = inspectListModel;
    
    self.titleLable.text = inspectListModel.plan_name;
    
    self.passRateLable.text = [NSString stringWithFormat:@"通过率%@%%",inspectListModel.pass_percent];
    
    [self handleExecuteStatusWithInspectListModel:inspectListModel];
    
    self.execuTimeLable.text = [NSString stringWithFormat:@"执行时间：%@", inspectListModel.execute_time];
    
    [self.execuTimeLable markText:@"执行时间：" withColor:AppFont999999Color];
    
    self.execuPerLable.text = [NSString stringWithFormat:@"执行人：%@", inspectListModel.execute_name];
    
    [self.execuPerLable markText:@"执行人：" withColor:AppFont999999Color];
    
    self.checkItemLable.text = [NSString stringWithFormat:@"检查项：%@项检查", inspectListModel.pro_num];
    
    [self.checkItemLable markText:@"检查项：" withColor:AppFont999999Color];
    
}

#pragma mark - 执行状态
- (void)handleExecuteStatusWithInspectListModel:(JGJInspectListModel *)inspectListModel {
    
    NSString *status = [NSString stringWithFormat:@"进行中%@%%",inspectListModel.execute_percent];
    
    UIColor *stausBackColor = AppFontF9A00FColor;
    
    CGFloat statusW = 55;
    
    if ([inspectListModel.execute_percent isEqualToString:@"0"]) {
        
        stausBackColor = AppFont999999Color;
        
        status = @"未开始";
        
        
    }else if ([inspectListModel.execute_percent isEqualToString:@"100"]) {
        
        stausBackColor = AppFont83C76EColor;
        
        status = @"已完成";
    }else {
        
        statusW = [NSString stringWithContentSize:CGSizeMake(300, 50) content:status font:AppFont30Size].width + 8;
    }
    
    
    [self.statusLable mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(statusW);
    }];
    
    self.statusLable.text = status;
    
    self.statusLable.backgroundColor = stausBackColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
