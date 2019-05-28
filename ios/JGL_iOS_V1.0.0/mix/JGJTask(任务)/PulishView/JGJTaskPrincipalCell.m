//
//  JGJTaskPrincipalCell.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskPrincipalCell.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

@interface JGJTaskPrincipalCell ()

@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation JGJTaskPrincipalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.nameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    [self.headerButton.layer setLayerCornerRadius:JGJHeadCornerRadius];
}

- (void)setPrincipalModel:(JGJSynBillingModel *)principalModel {

    _principalModel = principalModel;
    
    self.nameLable.text = principalModel.real_name;
    
    if (principalModel.isAddModel) {
        
        self.headerButton.backgroundColor = [UIColor whiteColor];
        
        [self.headerButton setBackgroundImage:[UIImage imageNamed:principalModel.head_pic] forState:UIControlStateNormal];
        
        [self.headerButton setTitle:@"" forState:UIControlStateNormal];
        
        [self.headerButton setImage:nil forState:UIControlStateNormal];
        
    }else {
        [self.headerButton setImage:nil forState:UIControlStateNormal];
        [self.headerButton setMemberPicButtonWithHeadPicStr:principalModel.head_pic memberName:principalModel.real_name memberPicBackColor:principalModel.modelBackGroundColor membertelephone:principalModel.telephone];
        
    }
        
    self.headerButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
