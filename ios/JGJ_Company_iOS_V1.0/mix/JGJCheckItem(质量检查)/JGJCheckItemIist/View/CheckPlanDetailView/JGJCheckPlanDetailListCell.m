//
//  JGJCheckPlanDetailListCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPlanDetailListCell.h"

#import "UILabel+GNUtil.h"

@interface JGJCheckPlanDetailListCell ()

@property (weak, nonatomic) IBOutlet UILabel *checkItemLable;

@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@property (weak, nonatomic) IBOutlet UILabel *timeInfoLable;

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@end
@implementation JGJCheckPlanDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkItemLable.textColor = AppFont333333Color;
    
    self.statusLable.textColor = AppFont999999Color;
    
    self.timeInfoLable.textColor = AppFont999999Color;
    
    self.rightLineView.backgroundColor = AppFontccccccColor;
    
    self.statusLable.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setCheckItemModel:(JGJInspectListDetailCheckItemModel *)checkItemModel {
    
    _checkItemModel = checkItemModel;
    
    self.checkItemLable.text = checkItemModel.pro_name;
    
    self.statusLable.text = checkItemModel.status;
    
    NSString *real_name = @"";
    
    if (![NSString isEmpty:checkItemModel.real_name]) {
        
        real_name = [NSString stringWithFormat:@"%@%@", @"检查人：", checkItemModel.real_name];
    }
    
    NSString *update_time = @"";
    
    if (![NSString isEmpty:checkItemModel.update_time]) {
        
        update_time = [NSString stringWithFormat:@"%@ ", checkItemModel.update_time];
    }
    
    self.timeInfoLable.text = [NSString stringWithFormat:@"%@%@", update_time, real_name];
    
//    if (![NSString isEmpty:checkItemModel.update_time]) {
//
//       [self.timeInfoLable markText:checkItemModel.update_time withColor:AppFontccccccColor];
//    }
    
    NSString *status = @"未检查";
    
    UIColor *statusColor = AppFont999999Color;
    
    if ([checkItemModel.status isEqualToString:@"0"]) {
        
        status = @"未检查";
        
    }else if ([checkItemModel.status isEqualToString:@"1"]) {
        
        status = @"待整改";
        
        statusColor = AppFontEB4E4EColor;
        
    }else if ([checkItemModel.status isEqualToString:@"2"]) {
        
        status = @"不用检查";

    }else if ([checkItemModel.status isEqualToString:@"3"]) {
        
        status = @"通过";
        
        statusColor = AppFont83C76EColor;
    }
    
    self.statusLable.textColor = statusColor;
    
    self.statusLable.text = status;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
