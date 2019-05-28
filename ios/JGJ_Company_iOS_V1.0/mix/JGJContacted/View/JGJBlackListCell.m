//
//  JGJBlackListCell.m
//  mix
//
//  Created by YJ on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBlackListCell.h"
#import "NSString+Extend.h"
#import "UIButton+WebCache.h"
#import "UIButton+JGJUIButton.h"
@interface JGJBlackListCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delButtonW;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end

@implementation JGJBlackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    _contactModel = contactModel;
    self.nameLable.text = contactModel.name;
//    if ([NSString isEmpty:contactModel.head_pic]) {
//        if (![NSString isEmpty:contactModel.name]) {
//            NSString *lastName = [contactModel.name substringFromIndex:contactModel.name.length - 1];
//            [self.headButton setTitle:lastName forState:UIControlStateNormal];
//            self.headButton.backgroundColor = contactModel.modelBackGroundColor;
//        }
//    }else {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JLGHttpRequest_UpLoadPicUrl,contactModel.head_pic]];
//        [self.headButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
//    }
    [self.headButton setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.name memberPicBackColor:contactModel.modelBackGroundColor];
    if (contactModel.isSelected) {
        [UIView animateWithDuration:0.1 animations:^{
            self.delButtonW.constant = 12;
            [self layoutIfNeeded];
        }];
    }else {
        [UIView animateWithDuration:0.1 animations:^{
            self.delButtonW.constant = 46;
            [self layoutIfNeeded];
        }];
    }
    self.delButton.hidden = contactModel.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleDelButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(JGJBlackListCell:contactModel:)]) {
        [self.delegate JGJBlackListCell:self contactModel:self.contactModel];
    }
}


@end
