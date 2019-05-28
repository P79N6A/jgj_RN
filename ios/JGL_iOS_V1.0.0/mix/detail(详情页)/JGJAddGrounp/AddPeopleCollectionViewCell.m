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
    // Initialization code
}
-(void)setDataNameModel:(JGJSynBillingModel *)DataNameModel
{
//    [_PhtoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,DataNameModel.addHeadPic]]];



}
-(void)setUrl_Str:(NSString *)Url_Str
{
    self.PhtoImage.layer.masksToBounds = YES;
    self.PhtoImage.layer.cornerRadius = JGJCornerRadius;
    [self.PhtoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,Url_Str]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
}


-(void)setNameStr:(NSString *)NameStr
{


    self.NameLable.text = NameStr;
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
    self.NameLable.text = userInfo[@"real_name"]?:@"";
    
}
@end
