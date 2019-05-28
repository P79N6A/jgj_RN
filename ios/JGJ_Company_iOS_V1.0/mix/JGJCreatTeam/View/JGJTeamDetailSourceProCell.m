//
//  JGJTeamDetailSourceProCell.m
//  JGJCompany
//
//  Created by yj on 16/11/11.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamDetailSourceProCell.h"

@interface JGJTeamDetailSourceProCell ()
@property (weak, nonatomic) IBOutlet UILabel *proNameLable;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end


@implementation JGJTeamDetailSourceProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJTeamDetailSourceProCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJTeamDetailSourceProCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProlistModel:(JGJSyncProlistModel *)prolistModel {
    _prolistModel = prolistModel;
    self.proNameLable.text = prolistModel.pro_name;
    self.selectedButton.selected = prolistModel.isSelected;
}
@end
