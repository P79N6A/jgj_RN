//
//  JGJClosedGroupCell.m
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJClosedGroupCell.h"
#import "UIImage+Size.h"
#import "TYAvatarGroupImageView.h"
#import "JGJHeadView.h"
@interface  JGJClosedGroupCell()

@property (weak, nonatomic) IBOutlet TYAvatarGroupImageView *avatarGroupImageView;
@property (weak, nonatomic) IBOutlet UIButton *openAgain;

@property (weak, nonatomic) IBOutlet UILabel *proNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *closedTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *closedImageView;
@end

@implementation JGJClosedGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.openAgain.layer setLayerBorderWithColor:TYColorHex(0x999999) width:0.5 radius:4.0];
    
    self.avatarGroupImageView.backgroundColor = AppFontf1f1f1Color;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    if (TYIS_IPHONE_5_OR_LESS) {
        [self.closedImageView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.firstAttribute == NSLayoutAttributeWidth || obj.firstAttribute == NSLayoutAttributeHeight) {
                obj.constant *= 0.7;
            }
        }];
    }
}

- (void)setJgjClosedGroupModel:(JGJClosedGroupModel *)jgjClosedGroupModel{
    _jgjClosedGroupModel = jgjClosedGroupModel;
    self.openAgain.hidden = !jgjClosedGroupModel.canOpen;
    self.proNameLabel.text = jgjClosedGroupModel.group_name;
    self.personCountLabel.text = [NSString stringWithFormat:@"(共%@人)",jgjClosedGroupModel.members_num];
    self.closedTimeLabel.text = jgjClosedGroupModel.close_time;
    if ([jgjClosedGroupModel.class_type isEqualToString:@"team"]) {
       // [self.avatarGroupImageView getCircleImgView:jgjClosedGroupModel.members_head_pic];
        JGJHeadView *head = [[JGJHeadView alloc]initWithFrame:CGRectMake(0, 0, 51, 51) withframe:jgjClosedGroupModel.members_head_pic];
        [self.avatarGroupImageView addSubview:head];
    } else {
//        [self.avatarGroupImageView getRectImgView:jgjClosedGroupModel.members_head_pic];
        JGJHeadView *head = [[JGJHeadView alloc]initWithFrame:CGRectMake(0, 0, 51, 51) withframe:jgjClosedGroupModel.members_head_pic];
        [self.avatarGroupImageView addSubview:head];

    }
}

- (IBAction)openAgainBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(openAgainBtnClick:)]) {
        [self.delegate openAgainBtnClick:self];
    }
}
@end
