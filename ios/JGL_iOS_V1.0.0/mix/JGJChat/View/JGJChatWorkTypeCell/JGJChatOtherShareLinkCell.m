//
//  JGJChatOtherShareLinkCell.m
//  mix
//
//  Created by ccclear on 2019/3/29.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatOtherShareLinkCell.h"
#import "UILabel+GNUtil.h"
@interface JGJChatOtherShareLinkCell ()
@property (weak, nonatomic) IBOutlet UILabel *shareMsgTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareTitleConstraintH;

@property (weak, nonatomic) IBOutlet UIImageView *shareMsgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareImageConstraintH;


@property (weak, nonatomic) IBOutlet UILabel *shareMsgContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareMsgContentConstraintH;

@end
@implementation JGJChatOtherShareLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shareMsgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.shareMsgImageView.clipsToBounds = YES;
    
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    self.shareMsgTitle.text = self.chatListModel.shareMenuModel.title;
    
    if (![NSString isEmpty:self.chatListModel.shareMenuModel.imgUrl]) {
        
        [self.shareMsgImageView sd_setImageWithURL:[NSURL URLWithString:self.chatListModel.shareMenuModel.imgUrl] placeholderImage:IMAGE(@"chat_link_msg")];
        
    }else {
        
        self.shareMsgImageView.image = IMAGE(@"chat_link_msg");
    }
    
    BOOL titleIsEmpty = [NSString isEmpty:_chatListModel.shareMenuModel.title];
    BOOL describeIsEmpty = [NSString isEmpty:_chatListModel.shareMenuModel.describe];
    
    if (titleIsEmpty) {
        
        self.shareMsgTitle.hidden = YES;
        self.shareTitleConstraintH.constant = 0;
        self.shareImageConstraintH.constant = 0;
        
    }else {
        
        self.shareMsgTitle.hidden = NO;
        self.shareImageConstraintH.constant = 7;
        CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 30 - 7, CGFLOAT_MAX) content:self.chatListModel.shareMenuModel.title font:16];
        
        CGFloat title_height = ceil(size.height) + 1;
        UIFont *font = [UIFont systemFontOfSize:16];
        if (title_height >= 2 * font.lineHeight) {
            
            title_height = 2 * font.lineHeight;
        }
        self.shareTitleConstraintH.constant = title_height + 5;
    }
    
    CGFloat describeHeight = 0.0;
    CGFloat urlHeight = 0.0;
    if (![NSString isEmpty:self.chatListModel.shareMenuModel.describe]) {
        
        CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 92 - 7, CGFLOAT_MAX) content:self.chatListModel.shareMenuModel.describe font:12];
        describeHeight = ceil(size.height) + 1;
        UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
        
        if (describeHeight >= 3 * font.lineHeight) {
            
            describeHeight = 3 * font.lineHeight + 5;
        }
        
    }
    
    if (![NSString isEmpty:self.chatListModel.shareMenuModel.url]) {
        
        CGSize size =  [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 64 - 76 - 92 - 7, CGFLOAT_MAX) content:self.chatListModel.shareMenuModel.describe font:12];
        
        urlHeight = ceil(size.height) + 1;
        
        UIFont *font = [UIFont systemFontOfSize:AppFont24Size];
        
        if (urlHeight >= 3 * font.lineHeight) {
            
            urlHeight = 3 * font.lineHeight + 5;
        }
        
    }
    
    if (describeIsEmpty) {
        
        self.shareMsgContent.text = self.chatListModel.shareMenuModel.url;
        self.shareMsgContentConstraintH.constant = urlHeight;
    }else {
        
        self.shareMsgContent.text = self.chatListModel.shareMenuModel.describe;
        self.shareMsgContentConstraintH.constant = describeHeight;
        
    }
//    [self.shareMsgContent alignTop];
    
}

@end
