//
//  JGJChatSignNumberCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignNumberCell.h"

@interface JGJChatSignNumberCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation JGJChatSignNumberCell

- (void)setSignNumStr:(NSString *)signNumStr{
    _signNumStr = signNumStr;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日签到%@人",signNumStr]];
    
    NSRange allRange = NSMakeRange(0, attrStr.length);
    [attrStr addAttributes:@{NSForegroundColorAttributeName:TYColorHex(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:15.0]} range:allRange];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:TYColorHex(0xd7252c),NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]} range:NSMakeRange(4, signNumStr.length)];
    self.descLabel.attributedText = attrStr;
}

@end
