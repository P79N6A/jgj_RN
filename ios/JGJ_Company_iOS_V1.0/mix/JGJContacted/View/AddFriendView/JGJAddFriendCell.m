//
//  JGJAddFriendCell.m
//  mix
//
//  Created by yj on 2018/10/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddFriendCell.h"

@interface JGJAddFriendCell()

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *selFlag;


@end

@implementation JGJAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {
    
    _memberModel = memberModel;
    
    self.name.text = memberModel.real_name;
    
    self.selFlag.hidden = !memberModel.is_exist;
    
    self.selBtn.selected = memberModel.isSelected;
    
    if (memberModel.is_exist) {
        
        [self.selBtn setImage:[UIImage imageNamed:@"OldSelected"] forState:UIControlStateNormal];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
