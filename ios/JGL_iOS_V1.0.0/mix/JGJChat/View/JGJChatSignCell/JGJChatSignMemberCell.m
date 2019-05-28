//
//  JGJChatSignMemberCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignMemberCell.h"
#import "CustomView.h"

@interface JGJChatSignMemberCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet LineView *lineView;
@end

@implementation JGJChatSignMemberCell
- (void)setChatSign_Sign_List:(ChatSign_Sign_List *)chatSign_Sign_List{
    _chatSign_Sign_List = chatSign_Sign_List;
    
    self.addressLabel.text = chatSign_Sign_List.sign_addr;
    self.timeLabel.text = chatSign_Sign_List.sign_time;
}

- (void)setIsHiddenLineView:(BOOL)isHiddenLineView{
    self.lineView.hidden = isHiddenLineView;
}

@end
