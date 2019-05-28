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

    self.nameLabel.text = @"工人";
    self.recordLabel.text = @"上班";
    self.timeLabel.text = @"加班";
    
    self.nameLabel.textColor  = AppFont666666Color;
    
    self.recordLabel.textColor  = AppFont666666Color;
    
    self.timeLabel.textColor  = AppFont666666Color;
    
    self.nameLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.recordLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.timeLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    
    UIColor *lightColor = AppFontf7f7f7Color;
    
    self.contentView.backgroundColor = lightColor;
    
    self.timeLabel.backgroundColor = lightColor;
    
    self.recordLabel.backgroundColor = lightColor;
    
    self.nameLabel.backgroundColor = lightColor;
    
}

@end
