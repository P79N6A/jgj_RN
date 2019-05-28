//
//  JGJTRectNotifyWarningCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTRectNotifyWarningCell.h"

@interface JGJTRectNotifyWarningCell ()

@property (weak, nonatomic) IBOutlet UILabel *warnLable;

@end

@implementation JGJTRectNotifyWarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.warnLable.textColor = AppFontccccccColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
