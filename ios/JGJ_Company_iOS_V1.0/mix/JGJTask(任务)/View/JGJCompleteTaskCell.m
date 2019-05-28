//
//  JGJCompleteTaskCell.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCompleteTaskCell.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

@interface JGJCompleteTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation JGJCompleteTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLable.textColor = AppFont999999Color;
    
    [self.headButton.layer setLayerCornerRadius:2.5];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"JGJCompleteTaskCell";
    JGJCompleteTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCompleteTaskCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setTaskModel:(JGJTaskModel *)taskModel {

    _taskModel = taskModel;
    
    self.contentLable.text = _taskModel.task_content;
    
    [self.headButton setTitle:nil forState:UIControlStateNormal];
    
    [self.headButton setImage:nil forState:UIControlStateNormal];
    
    if ([taskModel.principal_user_info.uid isEqualToString:@"0"]) {
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"wait_task_member_icon"] forState:UIControlStateNormal];
        
    }else {
        
        UIColor *memberColor = [NSString modelBackGroundColor:taskModel.principal_user_info.real_name];
        
        [self.headButton setMemberPicButtonWithHeadPicStr:taskModel.principal_user_info.head_pic memberName:taskModel.principal_user_info.real_name memberPicBackColor:memberColor membertelephone:@""];
        
    }
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    _taskModel.taskHeight = 86.0;

}

- (IBAction)handleChangeTaskStatus:(UIButton *)sender {
    
    if (self.handleCompleteTaskCellBlock) {
        
        self.handleCompleteTaskCellBlock(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
