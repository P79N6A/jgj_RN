//
//  JGJNotifyJoinExistProTopCell.m
//  JGJCompany
//
//  Created by YJ on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotifyJoinExistProTopCell.h"
#import "UILabel+GNUtil.h"

@interface JGJNotifyJoinExistProTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *proNameLable;
@end
@implementation JGJNotifyJoinExistProTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    self.proNameLable.textColor = AppFont333333Color;
}

- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    _notifyModel = notifyModel;
    
    
    self.proNameLable.text = [NSString stringWithFormat:@"将 %@ 加入到:",notifyModel.team_name];
    
    NSArray *textArray = @[@"将",@"加入到:"];
    UIFont *textFont = [UIFont systemFontOfSize:13.0];
    [self.proNameLable markattributedTextArray:textArray color:TYColorHex(0x666666) font:textFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
