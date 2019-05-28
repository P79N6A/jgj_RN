//
//  JGJSourceSynedProCell.m
//  JGJCompany
//
//  Created by yj on 16/11/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSourceSynedProCell.h"

@interface JGJSourceSynedProCell ()
@property (weak, nonatomic) IBOutlet UILabel *proNameLable;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end

@implementation JGJSourceSynedProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = AppFontf5f5f5Color;
}
+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSourceSynedProCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSourceSynedProCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProlistModel:(JGJSyncProlistModel *)prolistModel {
    _prolistModel = prolistModel;
    self.proNameLable.text = prolistModel.pro_name;
    self.selectedButton.selected = prolistModel.isSelected;
}

@end
