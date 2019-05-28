//
//  JGJChatWorkLoaclVerifiedCell.m
//  mix
//
//  Created by ccclear on 2019/4/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkLoaclVerifiedCell.h"

@implementation JGJChatWorkLoaclVerifiedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    
}
- (IBAction)gotoRealNameAuthentication:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(loaclVerifiedCellGotoRealNameAuthenticationWithChatListModel:cell:)]) {
        
        [self.delegate loaclVerifiedCellGotoRealNameAuthenticationWithChatListModel:_chatListModel cell:self];
    }
}

@end
