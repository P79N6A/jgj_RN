//
//  JGJChatListRecordCell.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListRecordCell.h"

@interface JGJChatListRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation JGJChatListRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.text = @"唐杰";
    self.recordLabel.text = @"1个工";
    self.timeLabel.text = @"2小时";
    
    self.nameLabel.textColor  = AppFont333333Color;
    
    self.recordLabel.textColor  = AppFont333333Color;
    
    self.timeLabel.textColor  = AppFont333333Color;
}

- (void)setChatListRecordModel:(ChatListRecord_List *)chatListRecordModel{
    
    _chatListRecordModel = chatListRecordModel;
    
    NSString *agencyFlag = [NSString stringWithFormat:@"%@", chatListRecordModel.is_agency?@"(代班长)" : @""];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@", chatListRecordModel.name, agencyFlag];
    
    NSString *unit = @"小时";
    
    if (_showType == 0 || _showType == 1) {
        
        unit = @"个工";
    }
    
    NSString *working_hours = chatListRecordModel.working_hours;
    
    NSString *manhour = chatListRecordModel.manhour;
    
    if ([working_hours isEqualToString:@"0"]) {
        
        working_hours = @"休息";
        
        unit = @"";
    }
    
    if ([manhour isEqualToString:@"0"]) {
        
        manhour = @"休息";
        
        unit = @"";
    }
    
    self.recordLabel.text = [NSString stringWithFormat:@"%@%@", _showType == 2 ? manhour : working_hours, unit];
    
    
    
    NSString *overtime_hours = chatListRecordModel.overtime_hours;
    
    NSString *overtime = chatListRecordModel.overtime;
    
//    NSString *overtimeUnit = @"个工";
//
//    if (self.isShowWork) {
//
//        overtimeUnit = @"小时";
//    }
    
    NSString *overtimeUnit = @"小时";
    
    if (_showType == 1) {
        
        overtimeUnit = @"个工";
    }
    
    if ([NSString isFloatZero:chatListRecordModel.overtime_hours.floatValue]) {
        
        overtime_hours = @"无加班";
        
        overtimeUnit = @"";
    }
    
    
    if ([NSString isFloatZero:chatListRecordModel.overtime.floatValue]) {
        
        overtime = @"无加班";
        
        overtimeUnit = @"";
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@", _showType != 1 ? overtime: overtime_hours, overtimeUnit];
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    UIColor *recordMemberColor = [chatListRecordModel.uid isEqualToString:myUid] ? AppFontEB4E4EColor : AppFont333333Color;
    
    self.nameLabel.textColor  = recordMemberColor;
    
    self.recordLabel.textColor = recordMemberColor;
    
    self.timeLabel.textColor  = recordMemberColor;
    
}
@end
