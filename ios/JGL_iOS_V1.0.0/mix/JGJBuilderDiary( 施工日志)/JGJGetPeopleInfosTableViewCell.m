//
//  JGJGetPeopleInfosTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
#import "JGJGetPeopleInfosTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
@implementation JGJGetPeopleInfosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setMdeol:(JGJSetRainWorkerModel *)mdeol
{
    UIColor *memberColor = [UIColor whiteColor];

    if (![NSString isEmpty:mdeol.real_name]) {
        
        memberColor = [NSString modelBackGroundColor:mdeol.real_name];
    }
    [self.headButton setMemberPicButtonWithHeadPicStr:mdeol.head_pic memberName:mdeol.real_name memberPicBackColor:memberColor];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    _nameLable.text = mdeol.real_name;
    
}

-(void)setModel:(JGJSynBillingModel *)model
{
    UIColor *memberColor = [UIColor whiteColor];
    
    if (![NSString isEmpty:model.real_name]) {
        
        memberColor = [NSString modelBackGroundColor:model.real_name];
    }
    [self.headButton setMemberPicButtonWithHeadPicStr:model.head_pic memberName:model.real_name memberPicBackColor:memberColor];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    _nameLable.text = model.real_name;
    
}
@end
