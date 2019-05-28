//
//  JGJChatSignBottomCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignBottomCell.h"
#import "UIImageView+WebCache.h"

@interface JGJChatSignBottomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *signImage;

@end

@implementation JGJChatSignBottomCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.avatarImage.layer setLayerCornerRadiusWithRatio:0.5];
}

- (void)setChatSignModel:(JGJChatSignModel *)chatSignModel{
    _chatSignModel = chatSignModel;
    
    //设置头像
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:chatSignModel.user_info.head_pic?:@""]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
    
    //设置签到的描述
    if ([chatSignModel.today_sign_record_num integerValue] == 0) {
        self.signImage.hidden = NO;
        self.descLabel.text = @"今日未签到";
    }else{
        self.signImage.hidden = YES;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日签到%@次",chatSignModel.today_sign_record_num]];
        
        NSRange allRange = NSMakeRange(0, attrStr.length);
        [attrStr addAttributes:@{NSForegroundColorAttributeName:TYColorHex(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:15.0]} range:allRange];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:TYColorHex(0x83c76e),NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]} range:NSMakeRange(4, chatSignModel.today_sign_record_num.length)];
        self.descLabel.attributedText = attrStr;
    }
}
@end

