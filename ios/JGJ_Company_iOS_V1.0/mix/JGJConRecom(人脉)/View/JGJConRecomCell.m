//
//  JGJConRecomCell.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJConRecomCell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJConRecomCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *comment;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end

@implementation JGJConRecomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addFriendButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:2.5];

    self.name.textColor = AppFont333333Color;
    
    self.comment.textColor = AppFont999999Color;
    
    [self.headButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
    
    self.name.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}

-(void)setFriendlyModel:(JGJSynBillingModel *)friendlyModel {
    
    _friendlyModel = friendlyModel;
    
    self.name.textColor = AppFont333333Color;
    
    if ([NSString isEmpty:friendlyModel.signature]) {
        
        self.name.text = friendlyModel.real_name;
        
        self.comment.text = friendlyModel.comment;
        
    }else {
        
        self.name.text = [NSString stringWithFormat:@"%@ %@", friendlyModel.real_name, friendlyModel.comment];
        
        [self.name markText:friendlyModel.comment withFont:[UIFont systemFontOfSize:AppFont24Size] color:AppFont999999Color];
        
        self.comment.text = friendlyModel.signature;
    }
    
    [self.headButton setMemberPicButtonWithHeadPicStr:friendlyModel.head_pic memberName:friendlyModel.real_name memberPicBackColor:friendlyModel.modelBackGroundColor membertelephone:friendlyModel.telephone];
    
    NSString *title = @"好友";
    
    NSString *imageStr = @"add_conRecom_icon";
    
    if (friendlyModel.isSelected) {
        
        title = @"已发送";
        
        imageStr = nil;
        
    }
    
    [self.addFriendButton setTitle:title forState:UIControlStateNormal];
    
    [self.addFriendButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

- (IBAction)addFriendButtonPressed:(UIButton *)sender {
    
    if (self.conRecomCellBlock) {
        
        self.conRecomCellBlock(self.friendlyModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
