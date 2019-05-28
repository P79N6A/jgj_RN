//
//  JGJSingleChatDetailInfoHeadCell.m
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSingleChatDetailInfoHeadCell.h"
#import "UIButton+JGJUIButton.h"
@interface JGJSingleChatDetailInfoHeadCell ()
@property (weak, nonatomic) IBOutlet UIButton *headPicButton;
@property (weak, nonatomic) IBOutlet UIButton *groupChatButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@end
@implementation JGJSingleChatDetailInfoHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headPicButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    _contactModel = contactModel;
    self.nameLable.text = contactModel.real_name;
    [self.headPicButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.real_name memberPicBackColor:contactModel.modelBackGroundColor];
}

- (IBAction)handleHeadPicButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(JGJSingleChatDetailInfoHeadCell:buttonType:)]) {
        [self.delegate JGJSingleChatDetailInfoHeadCell:self buttonType:JGJSingleChatDetailInfoHeadCellHeadPicButtonType];
    }
}

- (IBAction)handleGroupChatButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(JGJSingleChatDetailInfoHeadCell:buttonType:)]) {
        [self.delegate JGJSingleChatDetailInfoHeadCell:self buttonType:JGJSingleChatDetailInfoHeadCellGroupButtonType];
    }
}
@end
