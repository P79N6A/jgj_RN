//
//  JGJJoinGroupCollectionViewCell.m
//  mix
//
//  Created by Tony on 2016/12/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJJoinGroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JGJUIButton.h"
#import "UIButton+WebCache.h"
@implementation JGJJoinGroupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataNameModel:(JGJSynBillingModel *)DataNameModel
{
    _HeadButton.layer.masksToBounds = YES;
    _HeadButton.layer.cornerRadius = JGJCornerRadius / 2.0;
    _HeadButton.userInteractionEnabled = NO;
    [_HeadButton setMemberPicButtonWithHeadPicStr:DataNameModel.head_pic memberName:DataNameModel.real_name memberPicBackColor:DataNameModel.modelBackGroundColor];
    _HeadButton.titleLabel.font = [UIFont systemFontOfSize:AppFont20Size];
//    [_HeadButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,DataNameModel.head_pic]] forState:UIControlStateNormal];

    
}
@end
