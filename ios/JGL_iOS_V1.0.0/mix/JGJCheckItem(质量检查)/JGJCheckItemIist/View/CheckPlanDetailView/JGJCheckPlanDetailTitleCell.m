//
//  JGJCheckPlanDetailTitleCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPlanDetailTitleCell.h"

@interface JGJCheckPlanDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

@property (weak, nonatomic) IBOutlet UILabel *tilteLable;

@property (weak, nonatomic) IBOutlet UILabel *passRateLable;
@end

@implementation JGJCheckPlanDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tilteLable.textColor = AppFont333333Color;
    
    self.tilteLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.passRateLable.textColor = AppFont333333Color;
    
}

- (void)setInspectListDetailModel:(JGJInspectListDetailModel *)inspectListDetailModel {
    
    _inspectListDetailModel = inspectListDetailModel;
    
    self.tilteLable.text = inspectListDetailModel.plan_name;
    
    self.passRateLable.text = [NSString stringWithFormat:@"通过率%@%%", inspectListDetailModel.pass_percent];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
