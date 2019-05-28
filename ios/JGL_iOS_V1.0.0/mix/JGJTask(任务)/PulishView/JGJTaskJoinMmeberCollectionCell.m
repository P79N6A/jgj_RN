//
//  JGJTaskJoinMmeberCollectionCell.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskJoinMmeberCollectionCell.h"

#import "UIButton+JGJUIButton.h"

@interface JGJTaskJoinMmeberCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@end

@implementation JGJTaskJoinMmeberCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = AppFont333333Color;
    self.nameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    [self.headerButton.layer setLayerCornerRadius:2.5];
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {

    _memberModel = memberModel;
    
    self.nameLable.text = _memberModel.real_name;
    
    if (memberModel.isAddModel) {
        
        self.headerButton.backgroundColor = [UIColor whiteColor];
        [self.headerButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.headerButton setTitle:@"" forState:UIControlStateNormal];
        [self.headerButton setImage:[UIImage imageNamed:memberModel.head_pic] forState:UIControlStateNormal];
        
    }else {
             [self.headerButton setImage:nil forState:UIControlStateNormal];
            [self.headerButton setMemberPicButtonWithHeadPicStr:_memberModel.head_pic memberName:_memberModel.real_name memberPicBackColor:_memberModel.modelBackGroundColor membertelephone:memberModel.telephone];
        
        self.headerButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    }

}

@end
