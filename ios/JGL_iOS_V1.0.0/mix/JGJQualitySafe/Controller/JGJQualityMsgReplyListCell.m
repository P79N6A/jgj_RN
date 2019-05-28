//
//  JGJQualityMsgReplyListCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityMsgReplyListCell.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

#import "UIButton+WebCache.h"

@interface JGJQualityMsgReplyListCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *BtnImage;

@end

@implementation JGJQualityMsgReplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.contentLable.textColor = AppFont666666Color;
    
    self.timeLable.textColor = AppFont999999Color;
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    [self.BtnImage.layer setLayerCornerRadius:2.5];
    
    self.BtnImage.backgroundColor = [UIColor whiteColor];
}

- (void)setListModel:(JGJQualityDetailReplayListModel *)listModel {

    _listModel = listModel;
    
    self.nameLable.text = listModel.user_info.real_name;
    
    NSString *line = @"";
    if (![NSString isEmpty:listModel.reply_status_text] && ![NSString isEmpty:listModel.reply_text]) {
        
        line = @"\n";
    }
    
    self.contentLable.text = [NSString stringWithFormat:@"%@%@%@", listModel.reply_status_text,line, listModel.reply_text];

    self.timeLable.text = listModel.create_time;
    
    UIColor *headColor = [NSString modelBackGroundColor:listModel.user_info.real_name];
    
    NSString *replyMsgSrc = @"";
    if (listModel.msg_src.count > 0) {
        
        replyMsgSrc = listModel.msg_src.firstObject;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JLGHttpRequest_UpLoadPicUrl,replyMsgSrc]];
    
    [self.BtnImage setTitle:@"" forState:UIControlStateNormal];
    
    [self.BtnImage setBackgroundImage:nil forState:UIControlStateNormal];
    
    self.BtnImage.hidden = listModel.msg_src.count == 0;
    
    if (listModel.msg_src.count == 0) {
        
        NSString *flag = @"";
        if ([listModel.reply_type isEqualToString:@"quality"]) {
            
            flag = @"质量";
        }else if ([listModel.reply_type isEqualToString:@"safe"]) {
            
            flag = @"安全";
        }
        
        UIColor *typeColor = [NSString modelBackGroundColor:flag];
        
        self.BtnImage.backgroundColor = typeColor;
        
        [self.BtnImage setBackgroundImage:nil forState:UIControlStateNormal];
        [self.BtnImage setTitle:flag forState:UIControlStateNormal];
        
    }else {
        [self.BtnImage setTitle:@"" forState:UIControlStateNormal];
        [self.BtnImage sd_setBackgroundImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
                
            }
            
        }];
    }
    
    
    [self.headButton setMemberPicButtonWithHeadPicStr:listModel.user_info.head_pic memberName:listModel.user_info.real_name memberPicBackColor:headColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
