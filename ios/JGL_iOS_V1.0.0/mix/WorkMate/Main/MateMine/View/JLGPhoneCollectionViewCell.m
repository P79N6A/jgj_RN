//
//  JLGPhoneCollectionViewCell.m
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGPhoneCollectionViewCell.h"


@interface JLGPhoneCollectionViewCell ()

@end

@implementation JLGPhoneCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backGroundImage.clipsToBounds = YES;
}

- (void)setPicUrl:(NSString *)picUrl{
    _picUrl = picUrl;
    [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
}

- (void)setBackImage:(UIImage *)backImage{
    _backImage = backImage;
    self.backGroundImage.image = backImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backGroundImage layoutIfNeeded];
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton{
    _showDeleteButton = showDeleteButton;
    self.deleteButton.hidden = !showDeleteButton;
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
        [self.delegate deleteBtnClick:self];
    }
}
@end
