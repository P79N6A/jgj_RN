//
//  JGJJoinTeamCell.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJJoinTeamDescribeCell.h"

@implementation JGJJoinTeamDescribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJJoinTeamDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJJoinTeamDescribeCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
