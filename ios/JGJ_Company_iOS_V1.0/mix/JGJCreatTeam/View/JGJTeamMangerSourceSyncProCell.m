//
//  JGJTeamMangerSourceSyncProCell.m
//  JGJCompany
//
//  Created by YJ on 16/11/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamMangerSourceSyncProCell.h"
@interface JGJTeamMangerSourceSyncProCell ()
@property (weak, nonatomic) IBOutlet UILabel *proNameLable;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end

@implementation JGJTeamMangerSourceSyncProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proNameLable.textColor = AppFont333333Color;
    self.proNameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    self.contentView.backgroundColor = AppFontf5f5f5Color;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJTeamMangerSourceSyncProCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJTeamMangerSourceSyncProCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProlistModel:(JGJSyncProlistModel *)prolistModel {
    _prolistModel = prolistModel;
    self.proNameLable.text = prolistModel.pro_name;
    self.selectedButton.selected = prolistModel.isSelected;
}

- (IBAction)handleRemoveSyncProButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(handleTeamMangerSourceSyncProCellRemoveSynproButtonPressed:)]) {
        [self.delegate handleTeamMangerSourceSyncProCellRemoveSynproButtonPressed:self];
    }
}


@end
