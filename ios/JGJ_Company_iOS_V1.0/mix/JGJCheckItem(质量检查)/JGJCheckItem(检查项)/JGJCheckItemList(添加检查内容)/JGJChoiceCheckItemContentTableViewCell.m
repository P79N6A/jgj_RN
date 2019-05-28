//
//  JGJChoiceCheckItemContentTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJChoiceCheckItemContentTableViewCell.h"

@implementation JGJChoiceCheckItemContentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected) {
        self.selectImage.image = [UIImage imageNamed:@"checkItemSelected"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"checkItemNormal"];

    }
}
- (IBAction)clickSelectBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCheckItemContentBtn:)]) {
        [self.delegate clickCheckItemContentBtn:_indexpaths];
    }
}
-(void)setModel:(JGJCheckContentDetailModel *)model
{
    self.titleLable.text = model.content_name?:@"";

}
-(void)setCheckItemModel:(JGJCheckContentListModel *)checkItemModel
{
    self.titleLable.text = checkItemModel.pro_name?:@"";

}
@end
