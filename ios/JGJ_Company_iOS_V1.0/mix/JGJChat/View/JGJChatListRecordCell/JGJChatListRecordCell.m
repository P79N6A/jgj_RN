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
}

- (void)setChatListRecordModel:(ChatListRecord_List *)chatListRecordModel{
    _chatListRecordModel = chatListRecordModel;
    self.nameLabel.text = chatListRecordModel.name;
    self.recordLabel.text = chatListRecordModel.manhour;
    self.timeLabel.text = chatListRecordModel.overtime;
}
@end
