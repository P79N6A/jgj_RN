//
//  JGJHelpCenterCell.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHelpCenterCell.h"
@interface JGJHelpCenterCell ()
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@end

@implementation JGJHelpCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLable.textColor = AppFont333333Color;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJHelpCenterCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setHelpCenterListModel:(JGJHelpCenterListModel *)helpCenterListModel {
    _helpCenterListModel = helpCenterListModel;
    self.descLable.text = helpCenterListModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
