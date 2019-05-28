//
//  JGJModifyBillImageCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJModifyBillImageCollectionViewCell.h"

@implementation JGJModifyBillImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    _imageview.clipsToBounds = YES;
    
    _deleteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage:)];
    [_deleteImageView addGestureRecognizer:tap];
    [self initupImageButton:self.addBtn];
    
    [self.addBtn.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:5];
}
-(void)initupImageButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 2 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-25.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
-(void)deleteImage:(UITapGestureRecognizer *)guestrue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJModifyBillImageCollectionViewDeleteImageAndIndex:)]) {
        [self.delegate JGJModifyBillImageCollectionViewDeleteImageAndIndex:self.tag];
    }
};
@end
