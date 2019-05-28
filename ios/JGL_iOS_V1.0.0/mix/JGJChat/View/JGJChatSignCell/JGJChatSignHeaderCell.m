//
//  JGJChatSignHeaderCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignHeaderCell.h"
#import "UILabel+GNUtil.h"

#import "NSDate+Extend.h"

@interface JGJChatSignHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (nonatomic,strong) ChatSign_List *chatSign_List;
@end

@implementation JGJChatSignHeaderCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.timeLabel.textColor = TYColorHex(0x666666);
}

- (void)setModel:(ChatSign_List *)chatSign_List signType:(SignHeaderType )signHeaderType{
    _chatSign_List = chatSign_List;
    
    NSString *today = [NSDate stringFromDate:[NSDate date] format:@"yyyyMMdd"];
    
    chatSign_List.is_today = [today isEqualToString:chatSign_List.sign_date?:@""]?@"1":@"0";
    
    NSString *sign_tile = [chatSign_List.is_today isEqualToString:@"1"]?@"今日 ":@"";;
    self.timeLabel.text = [sign_tile stringByAppendingString:chatSign_List.sign_date_str?:@""];
    
    if (signHeaderType == SignHeaderTypeSignSubVc) {
        self.signLabel.text = [NSString stringWithFormat:@"签到 %@ 次",chatSign_List.sign_date_num];
    }else{
        self.signLabel.text = [NSString stringWithFormat:@"%@ 人已签到",chatSign_List.sign_date_num];
        
    }
    
    [self.signLabel markattributedTextArray:@[chatSign_List.sign_date_num?:@""] color:TYColorHex(0xd7252c) font:self.signLabel.font];
}
@end
