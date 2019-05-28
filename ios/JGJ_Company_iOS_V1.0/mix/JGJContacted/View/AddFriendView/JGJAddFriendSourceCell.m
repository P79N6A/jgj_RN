//
//  JGJAddFriendSourceCell.m
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendSourceCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
@interface JGJAddFriendSourceCell ()

@property (weak, nonatomic) IBOutlet UIButton *friendStyleButton;
@property (weak, nonatomic) IBOutlet UILabel *friendStyleTitle;

@property (weak, nonatomic) IBOutlet UILabel *friendStyleDes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageViewH;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@end

@implementation JGJAddFriendSourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    self.friendStyleTitle.textColor = AppFont333333Color;
    self.friendStyleDes.textColor = AppFont999999Color;
    self.friendStyleTitle.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    self.friendStyleDes.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.friendStyleButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
}

- (void)setSourceModel:(JGJAddFriendStyleModel *)sourceModel {
    _sourceModel = sourceModel;
    self.nextImageViewW.constant = 9.0;
    self.nextImageViewH.constant = 15.0;
    UIColor *userNameColor = [UIColor whiteColor];
    if (![NSString isEmpty:_sourceModel.real_name]) {
        userNameColor = [NSString modelBackGroundColor:_sourceModel.real_name];
    }
    if (sourceModel.addFriendSourceCellStyle != JGJAddFriendSourceSearchResult) {
        if ([NSString isEmpty:sourceModel.uid]) {
            //默认图片扫一扫、手机通讯录
            [self.friendStyleButton setImage:[UIImage imageNamed:sourceModel.head_pic] forState:UIControlStateNormal];
        }else {
            
            //当前头像类型
            [self.friendStyleButton setMemberPicButtonWithHeadPicStr:sourceModel.head_pic memberName:sourceModel.real_name memberPicBackColor:userNameColor];
            
            self.friendStyleButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        }
        self.friendStyleTitle.text = sourceModel.title;
        self.friendStyleDes.text = sourceModel.des;
        self.nextImageView.image = [UIImage imageNamed:@"arrow_right"];
        if (_sourceModel.isShowQrcode) {
            self.nextImageViewW.constant = 20.0;
            self.nextImageViewH.constant = 20.0;
            self.nextImageView.image = [UIImage imageNamed:@"teamManger_Qrcode"];
        }
    }else if (sourceModel.addFriendSourceCellStyle == JGJAddFriendSourceSearchResult) {
        [self.friendStyleButton setMemberPicButtonWithHeadPicStr:sourceModel.head_pic memberName:sourceModel.real_name memberPicBackColor:userNameColor];
        self.friendStyleTitle.text = sourceModel.real_name;
        self.friendStyleDes.text = sourceModel.telephone;
        self.nextImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
