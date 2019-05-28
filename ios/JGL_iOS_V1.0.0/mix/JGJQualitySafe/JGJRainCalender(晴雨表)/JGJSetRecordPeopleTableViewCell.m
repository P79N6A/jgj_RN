//
//  JGJSetRecordPeopleTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSetRecordPeopleTableViewCell.h"
#import "UIButton+JGJUIButton.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
@implementation JGJSetRecordPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectButton.layer.masksToBounds = YES;
//    self.selectButton.layer.cornerRadius = self.selectButton.frame.size.width/2;
//    self.selectButton.layer.borderWidth = .5;
//    self.selectButton.layer.borderColor = AppFontdbdbdbColor.CGColor;
    self.selectButton.userInteractionEnabled = NO;
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageButton setFrame:CGRectMake(50, 7, 45, 45)];
    _imageButton.layer.masksToBounds = YES;
    _imageButton.layer.cornerRadius = JGJCornerRadius;
    [self.contentView addSubview:_imageButton];
    
#pragma mark -yong 

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.imageviews.image = [UIImage imageNamed:@"椭圆-1"];
    }else{
        self.imageviews.image = [UIImage imageNamed:@"moreSelect"];

    }
    
    UIColor *userNameColor = [UIColor whiteColor];
    if (![NSString isEmpty:_rainModel.real_name]) {
        userNameColor = [NSString modelBackGroundColor:_rainModel.real_name];
    }
    [_imageButton setMemberPicButtonWithHeadPicStr:_rainModel.head_pic memberName:_rainModel.real_name memberPicBackColor:userNameColor];

}
-(void)setRainModel:(JGJSetRainWorkerModel *)rainModel
{
    _rainModel = [JGJSetRainWorkerModel new];
    _rainModel = rainModel;
    _nameLable.text = rainModel.real_name;
    _haveReal.hidden = [rainModel.is_active intValue];
    UIColor *userNameColor = [UIColor whiteColor];
    if (![NSString isEmpty:rainModel.real_name]) {
        userNameColor = [NSString modelBackGroundColor:rainModel.real_name];
    }
    [_imageButton setMemberPicButtonWithHeadPicStr:rainModel.head_pic memberName:rainModel.real_name memberPicBackColor:userNameColor];

}

-(void)setModel:(JGJSynBillingModel *)model
{
    _nameLable.text = model.real_name;
    _haveReal.hidden = [model.is_active intValue];
    UIColor *userNameColor = [UIColor whiteColor];
    if (![NSString isEmpty:model.real_name]) {
        userNameColor = [NSString modelBackGroundColor:model.real_name];
    }
    [self.headBUtton setMemberPicButtonWithHeadPicStr:model.head_pic memberName:model.real_name memberPicBackColor:userNameColor];
    self.headBUtton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    [self.headBUtton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
}
@end
