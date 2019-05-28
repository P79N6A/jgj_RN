//
//  TYAvatarGroupImageView.h
//  mix
//
//  Created by Tony on 2016/8/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYAGIImageType) {
    TYAGIImageDefault = 0,
    TYAGIImageRect,//方形
    TYAGIImageCircle//圆形
};

@interface TYAvatarGroupImageView : UIImageView

@property (nonatomic, assign) TYAGIImageType imageType;

/**
 *  获取圆形图片，imgMargin用默认的
 */
- (UIImageView *)getCircleImgView:(NSArray *)images;

/**
 *  获取圆形图片，imgMargin用默认的
 */
- (UIImageView *)getCircleImgView:(NSArray *)images imgMargin:(CGFloat)imgMargin;

/**
 *  获取方形图片，imgMargin用默认的
 */
- (UIImageView *)getRectImgView:(NSArray *)images;

/**
 *  获取方形图片，imgMargin用默认的
 */
- (UIImageView *)getRectImgView:(NSArray *)images imgMargin:(CGFloat)imgMargin;
@end
