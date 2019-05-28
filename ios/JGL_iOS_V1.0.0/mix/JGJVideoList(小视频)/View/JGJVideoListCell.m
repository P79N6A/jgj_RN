//
//  JGJVideoListCell.m
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJVideoListCell.h"

#import "UIImageView+WebCache.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJVideoListCell ()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UILabel *cmsContentLable;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;

@property (weak, nonatomic) IBOutlet UIButton *cmsButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *nameHead;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *contentBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewH;

@property (weak, nonatomic) IBOutlet UIButton *desButton;

@end

@implementation JGJVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.coverImageView.tag = 101;
    
    [self.nameHead.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
    [self.coverImageView addSubview:self.playBtn];
    
    self.coverImageViewH.constant = TYGetUIScreenWidth * 0.56;

    self.coverVideoView.alpha = 0.0;
    
    self.coverBottomView.alpha = 0.0;
    
    self.cmsContentLable.textColor = AppFont999999Color;
    
    self.desButton.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.desButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.desButton.titleLabel.numberOfLines = 2;
    
    [self.desButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
        
    [self.shareButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    [self.cmsButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    [self.praiseButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    self.desButton.titleLabel.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
}

- (void)setListModel:(JGJVideoListModel *)listModel {
    
    _listModel = listModel;

    if (listModel.pic_src.count > 0) {
        
        NSString *coverUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_IP_center, listModel.pic_src.firstObject];
        
        NSURL *url = [NSURL URLWithString:coverUrl];
        
        [self.coverImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"video_default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }else {
        
        self.coverImageView.image = [UIImage imageNamed:@"video_default_image"];
        
    }
    
    self.name.text = listModel.user_info.real_name;
    

    
    [self.nameHead setMemberPicButtonWithHeadPicStr:listModel.user_info.head_pic memberName:listModel.user_info.real_name memberPicBackColor:listModel.user_info.modelBackGroundColor membertelephone:listModel.user_info.telephone];

    self.playBtn.hidden = listModel.playerState == JGJPlayerStatePlaying;
    
    NSString *likeNum = [listModel.like_num isEqualToString:@"0"] || [NSString isEmpty:listModel.like_num] ? @"点赞" : listModel.like_num;
    
    [self.praiseButton setTitle:likeNum forState:UIControlStateNormal];
    
    NSString *comment_num = [listModel.comment_num isEqualToString:@"0"] || [NSString isEmpty:listModel.comment_num] ? @"评论" : listModel.comment_num;
    
    [self.cmsButton setTitle:comment_num forState:UIControlStateNormal];
    
    NSString *praiseImageStr = [listModel.is_liked isEqualToString:@"0"] ? @"video_ praise_icon" : @"my_praise_icon";
    
    UIImage *praiseImage = [UIImage imageNamed:praiseImageStr];
    
    [self.praiseButton setImage:praiseImage forState:UIControlStateNormal];
    
    self.nameHead.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    listModel.cms_content = nil;
    
    [self.desButton setTitle:listModel.cms_content?:@"" forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributeStr = [self.desButton.titleLabel markColor:AppFont5BA0EDColor pattern:[NSString toppattern]];
    
    [self.desButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
}

- (IBAction)playButtonAction:(UIButton *)sender {
    
    if(self.playBlock) {

        self.playBlock(sender, self.listModel);

    }
    
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    JGJVideoListCellButtonType ButtonType = sender.tag - 200;
    
    if ([self.delegate respondsToSelector:@selector(videoListCell:buttonType:)]) {
        
        [self.delegate videoListCell:self buttonType:ButtonType];
    }
    
}

- (IBAction)handleDetailAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(videoListCell:buttonType:)]) {
        
        [self.delegate videoListCell:self buttonType:JGJVideoListCellButtonComType];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
