//
//  JGJReciveHeadCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/1/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJReciveHeadCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
@interface JGJReciveHeadCollectionViewCell ()

@end

@implementation JGJReciveHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
//    [self.headImageView addSubview:self.NodataLable];
}
-(void)setImage:(UIImage *)image
{
//    [self.headButton setImage:image forState:UIControlStateNormal];
    _headImageView.image = image;
}


- (void)setDetailMemeberModel:(JGJSynBillingModel *)detailMemeberModel {

    _detailMemeberModel = detailMemeberModel;
    
//    if (!_headImageView.hidden) {
//        CGRect rect = _headImageView.frame;
//        rect.size.height = 35;
//        [_headImageView setFrame:rect];
//        [self layoutIfNeeded];
//    }
    [self.headButton setTitle:@"" forState:UIControlStateNormal];
    [self.headButton setMemberPicButtonWithHeadPicStr:detailMemeberModel.head_pic memberName:detailMemeberModel.real_name memberPicBackColor:detailMemeberModel.modelBackGroundColor membertelephone:detailMemeberModel.telphone];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    if ([detailMemeberModel.uid isEqualToString:@"0"]) {
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"wait_task_member_icon"] forState:UIControlStateNormal];
        
    }


}


@end
