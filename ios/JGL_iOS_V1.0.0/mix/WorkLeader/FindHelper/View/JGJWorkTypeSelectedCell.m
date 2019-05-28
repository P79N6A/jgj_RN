//
//  JGJWorkTypeSelectedCell.m
//  mix
//
//  Created by celion on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkTypeSelectedCell.h"
@interface JGJWorkTypeSelectedCell ()
@property (weak, nonatomic) IBOutlet UILabel *workTypeName;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedTitle;

@end

@implementation JGJWorkTypeSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.workTypeName.font = [UIFont systemFontOfSize:AppFont30Size];
    self.workTypeName.textColor = AppFont666666Color;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.selectedButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:AppFont999999Color forState:UIControlStateSelected];
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    [self.selectedButton setImage:[UIImage imageNamed:@"RecordWorkpoints_AddFmNoContactsSelected"] forState:UIControlStateSelected];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"Cell";
    JGJWorkTypeSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkTypeSelectedCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setWorkTypeModel:(FHLeaderWorktype *)workTypeModel {
    _workTypeModel = workTypeModel;
    self.workTypeName.text = workTypeModel.type_name;
    self.selectedButton.selected = workTypeModel.isSelected;
    if (workTypeModel.isSelected) {
        self.workTypeName.textColor = AppFontd7252cColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
