//
//  JGJSelectedCreaterCell.m
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSelectedCreaterCell.h"
#import "UIButton+JGJUIButton.h"
@interface JGJSelectedCreaterCell ()
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedCreaterButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@end
@implementation JGJSelectedCreaterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.selectedCreaterButton setTitleColor:AppFont999999Color forState:UIControlStateSelected];
    [self.selectedCreaterButton setTitle:@"已选中" forState:UIControlStateSelected];
    [self.selectedCreaterButton setImage:[UIImage imageNamed:@"proType_selected"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    _contactModel = contactModel;
    self.nameLable.text = contactModel.name;
    [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.name memberPicBackColor:contactModel.modelBackGroundColor];
    self.selectedCreaterButton.selected = contactModel.isSelected;
}

@end
