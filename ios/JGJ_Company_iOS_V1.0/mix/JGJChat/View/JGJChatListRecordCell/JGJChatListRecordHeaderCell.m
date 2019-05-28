//
//  JGJChatListRecordHeaderCell.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListRecordHeaderCell.h"


@interface JGJChatListRecordHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation JGJChatListRecordHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.nameLabel.text = @"姓名";
    self.recordLabel.text = @"工时";
    self.timeLabel.text = @"加班";
}

@end
