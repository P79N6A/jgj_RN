//
//  JGJCreatTeamSelectedCell.m
//  mix
//
//  Created by yj on 16/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatTeamSelectedCell.h"

#import "UILabel+GNUtil.h"

@interface JGJCreatTeamSelectedCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIButton *selectedFlagButton;

@end
@implementation JGJCreatTeamSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJCreatTeamSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCreatTeamSelectedCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setProjectListModel:(JGJProjectListModel *)projectListModel {
    
    _projectListModel = projectListModel;
    
    self.proName.text = _projectListModel.pro_name;
    
    if (projectListModel.isSelected) {
        
        [self.selectedFlagButton setTitle:@"已选中" forState:UIControlStateNormal];
        
        [self.selectedFlagButton setImage:[UIImage imageNamed:@"proType_selected"] forState:UIControlStateNormal];
        
         self.selectedFlagButton.hidden = NO;
        
    } else {
        
        if ([_projectListModel.is_create_group isEqualToString:@"1"]) {
            
            [self.selectedFlagButton setTitle:@"已有班组" forState:UIControlStateNormal];
            
            self.selectedFlagButton.hidden = NO;
            
        } else {
            
            self.selectedFlagButton.hidden = YES;
            
         }
    }
    
    self.proName.textColor = [_projectListModel.is_create_group isEqualToString:@"1"] ? AppFont999999Color : AppFont333333Color;
    
    [self.proName markText:self.searchValue withColor:AppFontEB4E4EColor];
}

@end
