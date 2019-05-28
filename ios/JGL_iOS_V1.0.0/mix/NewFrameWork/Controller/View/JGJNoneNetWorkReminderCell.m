//
//  JGJNoneNetWorkReminderCell.m
//  JGJCompany
//
//  Created by YJ on 16/11/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNoneNetWorkReminderCell.h"
#import "UILabel+GNUtil.h"
#import "JGJCustomLable.h"
@interface JGJNoneNetWorkReminderCell ()
@property (weak, nonatomic) IBOutlet JGJCustomLable *reminderLable;
@end

@implementation JGJNoneNetWorkReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.reminderLable.textColor = AppFont666666Color;
}

- (void)setReminderStr:(NSString *)reminderStr {
    _reminderStr = reminderStr;
    self.reminderLable.text = reminderStr;
    UIFont *font = [UIFont systemFontOfSize:AppFont28Size];
    self.reminderLable.font = font;
    [self.reminderLable setAttributedStringText:reminderStr lineSapcing:10.0];
    UIEdgeInsets textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([reminderStr isEqualToString:self.reminderTitles[0]]) {
        self.reminderLable.textColor = AppFont333333Color;
        self.reminderLable.font = [UIFont boldSystemFontOfSize:AppFont34Size];
        textInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    }else if ([reminderStr isEqualToString:self.reminderTitles[1]]) {
        [self.reminderLable markLineText:@"“设置”-“Wi-Fi网络”" withLineFont:font withColor:AppFont333333Color lineSpace:10.0];
       textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    }else if ([reminderStr isEqualToString:self.reminderTitles[2]]){
        [self.reminderLable markLineText:@"“设置” - “通用” - “网络”" withLineFont:font withColor:AppFont333333Color lineSpace:10.0];
    }else {
        textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.reminderLable.textInsets = textInsets;
    self.reminderLable.textAlignment = NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
