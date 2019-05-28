//
//  AddPeopleCollectionViewCell.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "AddPeopleCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JGJUIButton.h"
@implementation AddPeopleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setDataNameModel:(JGJSynBillingModel *)DataNameModel
{
//    [_PhtoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,DataNameModel.addHeadPic]]];
//    
//    UIColor *memberColor = [UIColor whiteColor];
//
//    if (![NSString isEmpty:DataNameModel.real_name]) {
//
//        memberColor = [NSString modelBackGroundColor:DataNameModel.real_name];
//
//    }
//    [self.headButton setMemberPicButtonWithHeadPicStr:DataNameModel.head_pic memberName:model.user_name memberPicBackColor:memberColor];
//
//    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
//    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
}
-(void)setUrl_Str:(NSString *)Url_Str
{
    self.Photo.layer.masksToBounds = YES;
    self.Photo.layer.cornerRadius = JGJCornerRadius;
    [self.Photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,Url_Str]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
    
    
}


-(void)setNameStr:(NSString *)NameStr
{
    
    
    self.Name.text = NameStr;
}
- (void)setUserInfo:(NSMutableDictionary *)userInfo
{
    UIColor *memberColor = [UIColor whiteColor];
    
    if (![NSString isEmpty:userInfo[@"real_name"]]) {
        
        memberColor = [NSString modelBackGroundColor:userInfo[@"real_name"]];
        
    }
    [self.headButton setMemberPicButtonWithHeadPicStr:userInfo[@"head_pic"] memberName:userInfo[@"real_name"] memberPicBackColor:memberColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    self.Name.text = userInfo[@"real_name"]?:@"";

}

@end
