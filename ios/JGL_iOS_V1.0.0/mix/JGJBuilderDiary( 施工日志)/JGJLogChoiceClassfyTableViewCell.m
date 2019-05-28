//
//  JGJLogChoiceClassfyTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogChoiceClassfyTableViewCell.h"

@implementation JGJLogChoiceClassfyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSelectmodel:(selectvaluelistModel *)Selectmodel
{
    _nameLable.text = Selectmodel.name;

}
@end
