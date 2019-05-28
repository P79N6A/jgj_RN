//
//  JGJAvatarView.h
//  mix
//
//  Created by YJ on 17/5/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJAvatarView : UIImageView

- (void)getRectImgView:(NSArray *)images;

//人头像背景宽高
@property (assign, nonatomic) CGFloat AvatarViewWH;

/**
 设置头像中字体大小比例,默认为1.0(以50为基准)
 */
@property (nonatomic, assign) CGFloat fontSizeRatio;

@end
