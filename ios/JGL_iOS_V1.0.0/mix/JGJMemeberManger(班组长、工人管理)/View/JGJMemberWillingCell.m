//
//  JGJMemberWillingCell.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberWillingCell.h"

@interface JGJMemberWillingCell ()

@property (weak, nonatomic) IBOutlet UIButton *willingBtn;

@end

@implementation JGJMemberWillingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)willingButtonPressed:(UIButton *)sender {
        
    sender.selected = !sender.selected;
    
    JGJMemberWillingButtonType type = sender.selected ? JGJMemberWillingType : JGJMemberUnWillingType;

    if ([self.delegate respondsToSelector:@selector(memberWillingCell:buttonType:)]) {
        
        [self.delegate memberWillingCell:self buttonType:type];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
