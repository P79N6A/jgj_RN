//
//  JGJReadInfoCell.m
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReadInfoCell.h"
#import "UIButton+WebCache.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
@interface JGJReadInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation JGJReadInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.avatarButton.layer setLayerCornerRadiusWithRatio:0.5];
    [self.avatarButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.avatarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nameLabel.textColor = AppFont333333Color;
    self.nameLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.phoneLabel.textColor = AppFont666666Color;
    self.phoneLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    UIView *lineView = [self.contentView viewWithTag:100];
    lineView.backgroundColor = AppFontf1f1f1Color;
}


- (void)setReadedInfo:(ChatMsgList_Read_User_List *)readedInfo{
    _readedInfo = readedInfo;
#if 0
    __weak typeof(self) weakSelf = self;

    [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:_readedInfo.head_pic]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            [weakSelf.avatarButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            [weakSelf.avatarButton setBackgroundColor:_readedInfo.nameColor];
            weakSelf.avatarButton.backgroundColor = _readedInfo.nameColor;
            
            [weakSelf.avatarButton setTitle:[_readedInfo.real_name substringFromIndex:_readedInfo.real_name.length - 1] forState:UIControlStateNormal];
        }
    }];
#else
//    [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:_readedInfo.head_pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
    UIColor *backColor = [NSString modelBackGroundColor:_readedInfo.real_name];
    [self.avatarButton setMemberPicButtonWithHeadPicStr:_readedInfo.head_pic memberName:_readedInfo.real_name memberPicBackColor:backColor membertelephone:_readedInfo.telphone];
    
#endif
    self.nameLabel.text = _readedInfo.real_name;
    self.phoneLabel.text = _readedInfo.telphone;
}

@end
